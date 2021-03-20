import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'SeekBar.dart';
import 'AudioPlayerTask.dart';
import 'MediaState.dart';
import 'package:imusic_mobile/QueueState.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('iMusic'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20.0),
            child: StreamBuilder<PlaybackState>(
                stream: AudioService.playbackStateStream,
                builder: (context, snapshot) {
                  final playing = snapshot.data?.playing ?? false;
                  final processingState = snapshot.data?.processingState
                      ?? AudioProcessingState.stopped;
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      if (playing)
                        pauseButton()
                      else
                        playButton(),
                      if (processingState != AudioProcessingState.stopped)
                        stopButton(),
                      ],
                  );
                },
            ),
          ),
          // Seek Bar
          StreamBuilder<MediaState>(
            stream: _mediaStateStream,
            builder: (context, snapshot) {
              final mediaState = snapshot.data;
              return SeekBar(
                duration:
                  mediaState?.mediaItem?.duration ?? Duration.zero,
                position: mediaState?.position ?? Duration.zero,
                onChangeEnd: (newPosition) {
                  AudioService.seekTo(newPosition);
                },
              );
            },
          ),
          // Display the processing state.
          StreamBuilder<AudioProcessingState>(
            stream: AudioService.playbackStateStream
                .map((state) => state.processingState)
                .distinct(),
            builder: (context, snapshot) {
              final processingState =
                  snapshot.data ?? AudioProcessingState.none;
              return Text(
                  "Processing state: ${describeEnum(processingState)}");
            },
          ),
          // Display the latest custom event.
          StreamBuilder(
            stream: AudioService.customEventStream,
            builder: (context, snapshot) {
              return Text("custom event: ${snapshot.data}");
            },
          ),
          // Display the notification click status.
          StreamBuilder<bool>(
            stream: AudioService.notificationClickEventStream,
            builder: (context, snapshot) {
              return Text(
                'Notification Click Status: ${snapshot.data}',
              );
            },
          ),
        ],
      ),
    );
  }

  /// A stream reporting the combined state of the current media item and its
  /// current position.
  Stream<MediaState> get _mediaStateStream =>
      Rx.combineLatest2<MediaItem, Duration, MediaState>(
          AudioService.currentMediaItemStream,
          AudioService.positionStream,
              (mediaItem, position) => MediaState(mediaItem, position));

  /// A stream reporting the combined state of the current queue and the current
  /// media item within that queue.
  Stream<QueueState> get _queueStateStream =>
      Rx.combineLatest2<List<MediaItem>, MediaItem, QueueState>(
          AudioService.queueStream,
          AudioService.currentMediaItemStream,
              (queue, mediaItem) => QueueState(queue, mediaItem));


  start() =>
      AudioService.start(backgroundTaskEntrypoint: backgroundTaskEntrypoint);
  stop() => AudioService.stop();

  play() async {
    if (await AudioService.running) {
      AudioService.play();
    } else {
      AudioService.start(backgroundTaskEntrypoint: backgroundTaskEntrypoint);
    }
  }

  pause() => AudioService.pause();

  IconButton playButton() => IconButton(
    icon: Icon(Icons.play_arrow),
    iconSize: 64.0,
    onPressed: play,
  );

  IconButton pauseButton() => IconButton(
    icon: Icon(Icons.pause),
    iconSize: 64.0,
    onPressed: pause,
  );

  IconButton stopButton() => IconButton(
    icon: Icon(Icons.stop),
    iconSize: 64.0,
    onPressed: stop,
  );
}