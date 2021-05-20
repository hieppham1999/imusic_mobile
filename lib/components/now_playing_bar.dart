import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../QueueState.dart';
import '../music_player.dart';

class NowPlayingBar extends StatefulWidget {
  const NowPlayingBar({Key? key}) : super(key: key);

  @override
  _NowPlayingBarState createState() => _NowPlayingBarState();
}

class _NowPlayingBarState extends State<NowPlayingBar> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AudioProcessingState>(
      stream: AudioService.playbackStateStream
          .map((state) => state.processingState)
          .distinct(),
      builder: (context, snapshot) {
        final processingState = snapshot.data ?? AudioProcessingState.none;
        return Visibility(
          visible: processingState != AudioProcessingState.none ? true : false,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.12,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MusicPlayer(),
                ));
              },
              style: ButtonStyle(
                  enableFeedback: false,
                  overlayColor: MaterialStateProperty.all<Color>(
                      Colors.black.withOpacity(0.0)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.black.withOpacity(0.7))),
              child: StreamBuilder<QueueState>(
                  stream: _queueStateStream,
                  builder: (context, snapshot) {
                    final queueState = snapshot.data;
                    final mediaItem = queueState?.mediaItem;
                    final artCover = (mediaItem != null
                            ? NetworkImage(mediaItem.artUri.toString())
                            : AssetImage('assets/images/no_artwork.png'))
                        as ImageProvider;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(image: artCover),
                          ),
                          child: AspectRatio(
                            aspectRatio: 1 / 1,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mediaItem?.title ?? "Unknown",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                  mediaItem?.artist ?? "Unknown",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        StreamBuilder<QueueState>(
                          stream: _queueStateStream,
                          builder: (context, snapshot) {
                            final queueState = snapshot.data;
                            final queue = queueState?.queue ?? [];
                            final mediaItem = queueState?.mediaItem;
                            final bool notHasPrevious = mediaItem ==
                                (queue.isNotEmpty ? queue.first : null);
                            return InkWell(
                              child: notHasPrevious
                                  ? Icon(
                                      Icons.skip_previous_rounded,
                                      color: Colors.grey,
                                      size: 40,
                                    )
                                  : Icon(
                                      Icons.skip_previous_rounded,
                                      size: 40,
                                    ),
                              customBorder: CircleBorder(),
                              onTap: notHasPrevious
                                  ? null
                                  : AudioService.skipToPrevious,
                            );
                          },
                        ),
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
                        StreamBuilder<QueueState>(
                          stream: _queueStateStream,
                          builder: (context, snapshot) {
                            final queueState = snapshot.data;
                            final queue = queueState?.queue ?? [];
                            final mediaItem = queueState?.mediaItem;
                            final bool notHasNext = mediaItem ==
                                (queue.isNotEmpty ? queue.last : null);
                            return InkWell(
                              child: notHasNext
                                  ? Icon(
                                Icons.skip_next_rounded,
                                color: Colors.grey,
                                size: 40,
                              )
                                  : Icon(
                                Icons.skip_next_rounded,
                                size: 40,
                              ),
                              // borderRadius: BorderRadius.circular(100),
                              customBorder: CircleBorder(),
                              onTap: notHasNext
                                  ? null
                                  : AudioService.skipToNext,
                            );
                          },
                        ),
                      ],
                    );
                  }),
            ),
          ),
        );
      },
    );
  }

  /// A stream reporting the combined state of the current queue and the current
  /// media item within that queue.
  Stream<QueueState> get _queueStateStream =>
      Rx.combineLatest2<List<MediaItem>?, MediaItem?, QueueState>(
          AudioService.queueStream,
          AudioService.currentMediaItemStream,
          (queue, mediaItem) => QueueState(queue!, mediaItem!));

  InkWell playButton() => InkWell(
        child: Icon(
          Icons.play_circle_filled_rounded,
          size: 40,
        ),
        borderRadius: BorderRadius.circular(100),
        radius: 40,
        onTap: play,
      );

  InkWell pauseButton() => InkWell(
        child: Icon(
          Icons.pause,
          size: 40,
        ),
        borderRadius: BorderRadius.circular(100),
        radius: 40,
        onTap: pause,
      );

  play() async {
    // if (AudioService.running) {
    AudioService.play();
    // } else {
    //   start();
    //   // AudioService.start(backgroundTaskEntrypoint: backgroundTaskEntrypoint);
    // }
  }

  pause() => AudioService.pause();
}