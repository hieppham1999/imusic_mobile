import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:imusic_mobile/utils/user_secure_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:imusic_mobile/Seeker.dart';
import 'package:imusic_mobile/services/auth.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:imusic_mobile/services/dio.dart';

import 'models/myMediaItem.dart';



// Must be a top-level function
void audioPlayerTaskEntrypoint() {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

class AudioPlayerTask extends BackgroundAudioTask{
  //

  Timer? timer;

  int playingTime = 0;

  final _player = AudioPlayer();
  AudioProcessingState? _skipState;

  Seeker? _seeker;
  late StreamSubscription<PlaybackEvent> _eventSubscription;


  // List<MediaItem> get queue => _mediaLibrary.items;
  List<MediaItem> queue = [];
  List<MediaItem> singleMediaQueue = [];
  int? get index => _player.currentIndex;
  MediaItem? get mediaItem => index == null ? null : queue[index!];

  @override
  Future<void> onStart(Map<String, dynamic>? params) async {

    // Broadcast media item changes.
    _player.currentIndexStream.listen((index) {
      if (index != null) AudioServiceBackground.setMediaItem(queue[index]);
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
          onStop();
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
  }


  @override
  Future<void> onSkipToQueueItem(String mediaId) async{
    // Then default implementations of onSkipToNext and onSkipToPrevious will
    // delegate to this method.
    final newIndex = queue.indexWhere((item) => item.id == mediaId);
    if (newIndex == -1) return;
    // During a skip, the player may enter the buffering state. We could just
    // propagate that state directly to AudioService clients but AudioService
    // has some more specific states we could use for skipping to next and
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

    playingTime = 0;

    onPlay();
  }

  void _startTimer() {
    if(timer != null) {
      timer!.cancel();
    }
    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      print('playing time: $playingTime');
      if (playingTime <= 15) {
        playingTime++;
      } else {
        // try {
        //   String? token = await UserSecureStorage.getToken();
        //   Dio.Response response = await dio().put('/me/listen/',
        //       data: {'serverId' : mediaItem!.serverId},
        //       options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
        //   print(response);
        //
        // } catch (e, stacktrace) {
        //   print('caught $e : $stacktrace');
        // }
        timer.cancel();
      }
    });
  }

  @override
  Future<void> onStop() async {
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
    // if (timer != null) {
    //   timer.cancelTimer();
    // }
    // timer = MyTimer();
    // timer.startTimer(15, (){
    //   print('timer has reached the submitted value');
    //   timer.cancelTimer();
    // });
    if (Auth().authenticated){
      _startTimer();
    }
  }

  @override
  Future<void> onPause() async {
    _player.pause();
    if (timer!.isActive) {
      timer!.cancel();
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
      queue.add(mediaItem);
      await AudioServiceBackground.setQueue(queue);
    try {
      await _player.setAudioSource(ConcatenatingAudioSource(
        children:
        queue.map((item) => AudioSource.uri(Uri.parse(item.id))).toList(),
      ));
    } catch (e) {
      print("Error: $e");
      onStop();
    }


    return super.onAddQueueItem(mediaItem);
  }
}