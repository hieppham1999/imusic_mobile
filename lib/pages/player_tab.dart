import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:imusic_mobile/MediaState.dart';
import 'package:rxdart/rxdart.dart';

import '../AudioPlayerTask.dart';
import '../QueueState.dart';
import '../SeekBar.dart';

class PlayerTab extends StatefulWidget {
  const PlayerTab({Key? key}) : super(key: key);

  @override
  _PlayerTabState createState() => _PlayerTabState();
}

class _PlayerTabState extends State<PlayerTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
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
                  return Container(
                    width: MediaQuery. of(context). size. width*0.7,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          child: AspectRatio(
                            aspectRatio: 1 / 1,
                            child: FadeInImage(
                                placeholder:
                                    AssetImage('assets/images/no_artwork.png'),
                                image: (mediaItem != null
                                        ? NetworkImage(mediaItem.artUri.toString())
                                        : AssetImage(
                                            'assets/images/no_artwork.png'))
                                    as ImageProvider),
                          ),
                          // (mediaItem?.artUri == null) ? Image(image: AssetImage('assets/images/no_artwork.png')) : Image.network(mediaItem!.artUri.toString()),
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          mediaItem?.title ?? "Unknown",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w500),
                        ),
                        Text(mediaItem?.artist ?? "Unknown",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  );
                },
              ),
              // A seek bar.
              StreamBuilder<MediaState>(
                stream: _mediaStateStream,
                builder: (context, snapshot) {
                  final mediaState = snapshot.data;
                  return SeekBar(
                    duration: mediaState?.mediaItem.duration ?? Duration.zero,
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
                  StreamBuilder<AudioServiceShuffleMode>(
                      stream: AudioService.playbackStateStream
                          .map((state) => state.shuffleMode)
                          .distinct(),
                      builder: (context, snapshot) {
                        final shuffleMode = snapshot.data ?? AudioServiceShuffleMode.none;
                        return IconButton(
                          icon: (shuffleMode == AudioServiceShuffleMode.all) ? Icon(Icons.shuffle_rounded, color: Colors.lightBlueAccent,) : Icon(Icons.shuffle_rounded, color: Colors.black38,),
                          iconSize: 32,
                          onPressed: () async {
                            await AudioService.setShuffleMode(AudioServiceShuffleMode.all);
                          }, );

                      }),

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
                        onPressed:
                            mediaItem == (queue.isNotEmpty ? queue.first : null)
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
                          // stopButton(),
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
                        onPressed:
                            mediaItem == (queue.isNotEmpty ? queue.last : null)
                                ? null
                                : AudioService.skipToNext,
                      );
                    },
                  ),
                  StreamBuilder<AudioServiceRepeatMode>(
                      stream: AudioService.playbackStateStream
                          .map((state) => state.repeatMode)
                          .distinct(),
                      builder: (context, snapshot) {
                        final repeatMode = snapshot.data ?? AudioServiceRepeatMode.none;
                        print('ui: ' + repeatMode.toString());
                        return IconButton(
                          icon: (repeatMode == AudioServiceRepeatMode.one) ? Icon(Icons.repeat_one_rounded) : Icon(Icons.repeat_rounded, color: Colors.black38,),
                          iconSize: 32,
                          onPressed: () {
                            AudioService.setRepeatMode(AudioServiceRepeatMode.one);
                          }, );

                      }),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              // Display the processing state.
              // StreamBuilder<AudioProcessingState>(
              //   stream: AudioService.playbackStateStream
              //       .map((state) => state.processingState)
              //       .distinct(),
              //   builder: (context, snapshot) {
              //     final processingState =
              //         snapshot.data ?? AudioProcessingState.none;
              //     return Text(
              //         "Processing state: ${describeEnum(processingState)}");
              //   },
              // ),
              // // Display the latest custom event.
              // StreamBuilder(
              //   stream: AudioService.customEventStream,
              //   builder: (context, snapshot) {
              //     return Text("custom event: ${snapshot.data}");
              //   },
              // ),
              // // Display the notification click status.
              // StreamBuilder<bool>(
              //   stream: AudioService.notificationClickEventStream,
              //   builder: (context, snapshot) {
              //     return Text(
              //       'Notification Click Status: ${snapshot.data}',
              //     );
              //   },
              // ),
            ],
          );
        },
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

  start() => AudioService.start(
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

  Widget _loopButton (AudioServiceRepeatMode repeatMode) {
    print('init RepeatMode: ' + repeatMode.toString());
    const cycleRepeatMode = [
      AudioServiceRepeatMode.none,
      AudioServiceRepeatMode.all,
      AudioServiceRepeatMode.one
    ];

    // final index = cycleRepeatMode.indexOf(repeatMode);

    Icon loopIcon;
    switch (repeatMode) {
      case AudioServiceRepeatMode.one:
        loopIcon = Icon(Icons.repeat_one_rounded, color: Colors.lightBlueAccent,);
        break;
      case AudioServiceRepeatMode.all:
        loopIcon = Icon(Icons.repeat_rounded, color: Colors.lightBlueAccent,);
        break;
      case AudioServiceRepeatMode.none:
        loopIcon = Icon(Icons.repeat_rounded,);
        break;
      default:
        loopIcon = Icon(Icons.repeat_on,);
    }
    return IconButton(onPressed: () {
      print('onpressed: ' + cycleRepeatMode[(cycleRepeatMode.indexOf(repeatMode) + 1) % cycleRepeatMode.length].toString());
      // AudioService.setRepeatMode(cycleRepeatMode[(cycleRepeatMode.indexOf(repeatMode) + 1) % cycleRepeatMode.length]);
      AudioService.setRepeatMode(AudioServiceRepeatMode.one);
    }, icon: loopIcon);
  }

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
