import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

MediaControl playControl = MediaControl(
  androidIcon: 'drawable/play_arrow',
  label: 'Play',
  action: MediaAction.play,
);
MediaControl pauseControl = MediaControl(
  androidIcon: 'drawable/pause',
  label: 'Pause',
  action: MediaAction.pause,
);
MediaControl skipToNextControl = MediaControl(
  androidIcon: 'drawable/skip_to_next',
  label: 'Next',
  action: MediaAction.skipToNext,
);
MediaControl skipToPreviousControl = MediaControl(
  androidIcon: 'drawable/skip_to_previous',
  label: 'Previous',
  action: MediaAction.skipToPrevious,
);
MediaControl stopControl = MediaControl(
  androidIcon: 'drawable/stop',
  label: 'Stop',
  action: MediaAction.stop,
);

class AudioPlayerTask extends BackgroundAudioTask{
  //
  final _queue = <MediaItem>[
    MediaItem(
      id: "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3",
      album: "Science Friday",
      title: "A Salute To Head-Scratching Science",
      artist: "Science Friday and WNYC Studios",
      duration: Duration(milliseconds: 5739828),
    ),
    MediaItem(
      id: "https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3",
      album: "Science Friday",
      title: "From Cat Rheology and Operatic Incompetence",
      artist: "Science Friday and WNYC Studios",
      duration: Duration(milliseconds: 2856950),
    ),
  ];
  int _queueIndex = -1;
  AudioPlayer _audioPlayer = AudioPlayer();
  AudioProcessingState _audioProcessingState;
  bool _playing;

  bool get hasNext => _queueIndex + 1 < _queue.length;
  bool get hasPrevious => _queueIndex > 0;
  MediaItem get mediaItem => _queue[_queueIndex];

  StreamSubscription<Audio>

  @override
  Future<void> onStart(Map<String, dynamic> params) {
    // TODO: implement onStart
    return super.onStart(params);
  }

  @override
  Future<void> onPlay() {
    // TODO: implement onPlay
    return super.onPlay();
  }

  @override
  Future<void> onPause() {
    // TODO: implement onPause
    return super.onPause();
  }

  @override
  Future<void> onSkipToNext() {
    // TODO: implement onSkipToNext
    return super.onSkipToNext();
  }

  @override
  Future<void> onSkipToPrevious() {
    // TODO: implement onSkipToPrevious
    return super.onSkipToPrevious();
  }

  @override
  Future<void> onSeekTo(Duration position) {
    // TODO: implement onSeekTo
    return super.onSeekTo(position);
  }

  @override
  Future<void> onClick(MediaButton button) {
    // TODO: implement onClick
    return super.onClick(button);
  }

  @override
  Future<void> onFastForward() {
    // TODO: implement onFastForward
    return super.onFastForward();
  }

  @override
  Future<void> onRewind() {
    // TODO: implement onRewind
    return super.onRewind();
  }

  @override
  Future<void> onStop() {
    // TODO: implement onStop
    return super.onStop();
  }
}