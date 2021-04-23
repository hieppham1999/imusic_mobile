import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'SeekBar.dart';
import 'package:imusic_mobile/AudioPlayerTask.dart';
import 'MediaState.dart';
import 'package:imusic_mobile/QueueState.dart';


class MusicPlayer extends StatefulWidget {
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<bool>(
          stream: AudioService.runningStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.active) {
              return SizedBox();
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Media Info
                StreamBuilder<QueueState>(
                  stream: _queueStateStream,
                  builder: (context, snapshot) {
                    final queueState = snapshot.data;
                    final mediaItem = queueState?.mediaItem;
                    return Column(
                      children: [
                        Container(
                          width: 300,
                          height: 300,
                          child: FadeInImage(image: NetworkImage(mediaItem!.artUri.toString()), placeholder: AssetImage('assets/images/no_artwork.png')),
                          // (mediaItem?.artUri == null) ? Image(image: AssetImage('assets/images/no_artwork.png')) : Image.network(mediaItem!.artUri.toString()),
                        ),
                        Text(mediaItem.title),
                        Text(mediaItem.artist ?? "Unknown"),
                      ],
                    );
                  },
                ),
                // A seek bar.
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
                // UI to show when we're running, i.e. player state/controls.
                Row(
                  children: [
                    // Queue display/controls.
                    StreamBuilder<QueueState>(
                      stream: _queueStateStream,
                      builder: (context, snapshot) {
                        final queueState = snapshot.data;
                        final queue = queueState?.queue ?? [];
                        final mediaItem = queueState?.mediaItem;
                        return IconButton(
                          icon: Icon(Icons.skip_previous),
                          iconSize: 64.0,
                          onPressed: mediaItem ==
                              (queue.isNotEmpty ? queue.first : null)
                              ? null
                              : AudioService.skipToPrevious,
                        );
                      },
                    ),
                    // Play/pause/stop buttons.
                    StreamBuilder<bool>(
                      stream: AudioService.playbackStateStream
                          .map((state) => state.playing)
                          .distinct(),
                      builder: (context, snapshot) {
                        final playing = snapshot.data ?? false;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (playing) pauseButton() else playButton(),
                            stopButton(),
                          ],
                        );
                      },
                    ),
                    // Queue display/controls.
                    StreamBuilder<QueueState>(
                      stream: _queueStateStream,
                      builder: (context, snapshot) {
                        final queueState = snapshot.data;
                        final queue = queueState?.queue ?? [];
                        final mediaItem = queueState?.mediaItem;
                        return IconButton(
                          icon: Icon(Icons.skip_next),
                          iconSize: 64.0,
                          onPressed: mediaItem == (queue.isNotEmpty ? queue.last : null)
                              ? null
                              : AudioService.skipToNext,
                        );
                      },
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
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
            );
          },
        ),
      ),
    );
  }
  /// A stream reporting the combined state of the current media item and its
  /// current position.
  Stream<MediaState> get _mediaStateStream =>
      Rx.combineLatest2<MediaItem?, Duration, MediaState>(
          AudioService.currentMediaItemStream,
          AudioService.positionStream,
              (mediaItem, position) => MediaState(mediaItem!, position));

  /// A stream reporting the combined state of the current queue and the current
  /// media item within that queue.
  Stream<QueueState> get _queueStateStream =>
      Rx.combineLatest2<List<MediaItem>?, MediaItem?, QueueState>(
          AudioService.queueStream,
          AudioService.currentMediaItemStream,
              (queue, mediaItem) => QueueState(queue!, mediaItem!));

  start() =>
      AudioService.start(
          backgroundTaskEntrypoint: audioPlayerTaskEntrypoint,
          androidResumeOnClick: true,
          androidEnableQueue: true,
      );

  stop() => AudioService.stop();

  play() async {
    if (AudioService.running) {
      AudioService.play();
    } else {
      start();
      // AudioService.start(backgroundTaskEntrypoint: backgroundTaskEntrypoint);
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
