import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:imusic_mobile/utils/user_secure_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:imusic_mobile/Seeker.dart';
import 'models/myAudioService.dart';
import 'utils/MediaItemExtensions.dart';



// Must be a top-level function
void audioPlayerTaskEntrypoint() {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

class AudioPlayerTask extends BackgroundAudioTask{
  //
  bool _isLoggedIn = false;
  bool _isAddPointRequestSent = false;
  bool _isListenRequestSent = false;

  String? _token;
  Timer? timer;
  int playingTime = 0;



  final _player = AudioPlayer();
  AudioProcessingState? _skipState;

  Seeker? _seeker;
  late StreamSubscription<PlaybackEvent> _eventSubscription;

  List<MediaItem> _queue = [];


  int? get index => _player.currentIndex;
  MediaItem? get mediaItem => index == null ? null : _queue[index!];

  Future<void> checkAuthenticatedStatus() async{
    _token = await UserSecureStorage.getToken();
    if (_token != null) {
      _isLoggedIn = true;
    } else {
      _isLoggedIn = false;
    }
  }


  @override
  Future<void> onStart(Map<String, dynamic>? params) async {

    // Broadcast media item changes.
    _player.currentIndexStream.listen((index) {
      if (index != null) AudioServiceBackground.setMediaItem(_queue[index]);
      playingTime = 0;
      _isListenRequestSent = false;
    });

    // Propagate all events from the audio player to AudioService clients.
    _eventSubscription = _player.playbackEventStream.listen((event) {
      _broadcastState();
    });

    // Special processing for state transitions.
    _player.processingStateStream.listen((state) {
      switch (state) {

        case ProcessingState.completed:
        // In this example, the service stops when reaching the end.
          _player.seek(Duration.zero);
          onPause();
          break;
        case ProcessingState.ready:
        // If we just came from skipping between tracks, clear the skip
        // state now that we're ready to play.
          _skipState = null;
          break;
        default:
          break;
      }
    });


    // AudioService.currentMediaItemStream.listen((MediaItem? item) {
    //   print(item!.title);
    // });
  }

  @override
  Future<void> onRemoveQueueItem(MediaItem mediaItem) async {
    _queue.remove(mediaItem);
    await AudioServiceBackground.setQueue(_queue);
    try {
      await _player.setAudioSource(ConcatenatingAudioSource(
        children:
        _queue.map((item) => AudioSource.uri(Uri.parse(item.id))).toList(),
      ));
    } catch (e) {
      print("Error: $e");
      onStop();
    }
    return super.onRemoveQueueItem(mediaItem);
  }



  @override
  Future<void> onSkipToQueueItem(String mediaId) async{
    // Then default implementations of onSkipToNext and onSkipToPrevious will
    // delegate to this method.


    final newIndex = _queue.indexWhere((item) => item.id == mediaId);

    if (newIndex == -1) return;
    // During a skip, the player may enter the buffering state. We could just
    // propagate that state directly to AudioService clients but AudioService
    // has some more specific states we could skipping to next and
    // previous. This variable holds the preferred state to send instead of
    // buffering during a skip, and it is cleared as soon as the player exits
    // buffering (see the listener in onStart).
    _skipState = newIndex > index!
        ? AudioProcessingState.skippingToNext
        : AudioProcessingState.skippingToPrevious;
    // This jumps to the beginning of the queue item at newIndex.
    _player.seek(Duration.zero, index: newIndex);
    // Demonstrate custom events.
    AudioServiceBackground.sendCustomEvent('skip to $newIndex');
    AudioService.play();
  }

  @override
  Future<void> onSkipToNext() {
    // if (AudioService.playbackState.shuffleMode == AudioServiceShuffleMode.all) {
    //   _player.seekToNext();
    // }
    return super.onSkipToNext();
  }

  void _startTimer() {
    if(timer != null) {
      timer!.cancel();
    }
    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      print('playing time: $playingTime');
      if (playingTime <= 20) {
        playingTime++;
      } else {
        await MyAudioService.listenFor20Sec(mediaItem!.getServerId());
        _isAddPointRequestSent = true;
        timer.cancel();
      }
    });
  }

  @override
  Future<void> onStop() async {
    if(timer != null) {
      timer!.cancel();
      playingTime = 0;
    }
    await _player.dispose();
    _eventSubscription.cancel();
    // It is important to wait for this state to be broadcast before we shut
    // down the task. If we don't, the background task will be destroyed before
    // the message gets sent to the UI.
    await _broadcastState();
    // Shut down this task
    await super.onStop();
  }

  @override
  Future<void> onPlay()  async {
    _player.play();

    if (_isListenRequestSent == false) {
      await MyAudioService.listenToItem(mediaItem!.getServerId());
      _isListenRequestSent = true;
    }

    await checkAuthenticatedStatus();

    // if User has logged in, count listen time and send to server
    if (_isLoggedIn && !_isAddPointRequestSent) {
      _startTimer();
    }

    // send listen count to server
  }

  @override
  Future<void> onPause() async {
    _player.pause();
    try {
      if (timer!.isActive) {
        timer!.cancel();
      }
    } catch (e) {
      print('Caught error: Counter is null when user is a guest');
    }

  }

  @override
  Future<void> onSeekTo(Duration position) => _player.seek(position);

  @override
  Future<void> onFastForward() => _seekRelative(fastForwardInterval);

  @override
  Future<void> onRewind() => _seekRelative(-rewindInterval);

  @override
  Future<void> onSeekForward(bool begin) async => _seekContinuously(begin, 1);

  @override
  Future<void> onSeekBackward(bool begin) async => _seekContinuously(begin, -1);

  @override
  Future<void> onSetRepeatMode(AudioServiceRepeatMode repeatMode) async{
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        await _player.setLoopMode(LoopMode.off);
        break;
      case AudioServiceRepeatMode.one:
        await _player.setLoopMode(LoopMode.one);
        break;
      case AudioServiceRepeatMode.all:
        await _player.setLoopMode(LoopMode.all);
        break;
      case AudioServiceRepeatMode.group:
        break;
    }
    await AudioServiceBackground.setState(repeatMode: repeatMode);
    return super.onSetRepeatMode(repeatMode);
  }


  /// Jumps away from the current position by [offset].
  Future<void> _seekRelative(Duration offset) async {
    var newPosition = _player.position + offset;
    // Make sure we don't jump out of bounds.
    if (newPosition < Duration.zero) newPosition = Duration.zero;
    if (newPosition > mediaItem!.duration!) newPosition = mediaItem!.duration!;
    // Perform the jump via a seek.
    await _player.seek(newPosition);
  }


  /// Begins or stops a continuous seek in [direction]. After it begins it will
  /// continue seeking forward or backward by 10 seconds within the audio, at
  /// intervals of 1 second in app time.
  void _seekContinuously(bool begin, int direction) {
    _seeker?.stop();
    if (begin) {
      _seeker = Seeker(_player, Duration(seconds: 10 * direction),
          Duration(seconds: 1), mediaItem!)
        ..start();
    }
  }

  /// Broadcasts the current state to all clients.
  Future<void> _broadcastState() async {
    await AudioServiceBackground.setState(
      controls: [
        MediaControl.skipToPrevious,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: [
        MediaAction.seekTo,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      ],
      androidCompactActions: [0, 1, 3],
      processingState: _getProcessingState(),
      playing: _player.playing,
      position: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
    );
  }

  /// Maps just_audio's processing state into into audio_service's playing
  /// state. If we are in the middle of a skip, we use [_skipState] instead.
  AudioProcessingState _getProcessingState() {
    if (_skipState != null) return _skipState!;
    switch (_player.processingState) {
      case ProcessingState.idle:
        return AudioProcessingState.stopped;
      case ProcessingState.loading:
        return AudioProcessingState.connecting;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
      default:
        throw Exception("Invalid state: ${_player.processingState}");
    }
  }


  @override
  Future<void> onAddQueueItem(MediaItem mediaItem) async {
      _queue.add(mediaItem);
      // unique item on a queue
      _queue = _queue.toSet().toList();
      await AudioServiceBackground.setQueue(_queue);
    try {
      await _player.setAudioSource(ConcatenatingAudioSource(
        children:
        _queue.map((item) => AudioSource.uri(Uri.parse(item.id))).toList(),
      ));
    } catch (e) {
      print("Error: $e");
      onStop();
    }
    return super.onAddQueueItem(mediaItem);
  }



  @override
  Future<void> onUpdateQueue(List<MediaItem> queue) async{
    _queue = queue;
    await AudioServiceBackground.setQueue(_queue);

    try {
      await _player.setAudioSource(ConcatenatingAudioSource(
        children:
        _queue.map((item) => AudioSource.uri(Uri.parse(item.id))).toList(),
      ));
      AudioServiceBackground.setMediaItem(_queue.first);
    } catch (e) {
      print("Error: $e");
      onStop();
    }
    return super.onUpdateQueue(queue);

  }

  @override
  Future<void> onSetSpeed(double speed) {
    _player.setSpeed(speed);
    return super.onSetSpeed(speed);
  }

  @override
  Future<void> onSetShuffleMode(AudioServiceShuffleMode shuffleMode) async{
    if (shuffleMode == AudioServiceShuffleMode.all) {
      await _player.setShuffleModeEnabled(true);
    } else {
      await _player.setShuffleModeEnabled(false);
    }
    _player.shuffle();
    await AudioServiceBackground.setState(shuffleMode: shuffleMode);
    return super.onSetShuffleMode(shuffleMode);
  }
}