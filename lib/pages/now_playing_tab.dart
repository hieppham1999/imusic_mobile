import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:imusic_mobile/components/now_playing_tile.dart';
import 'package:rxdart/rxdart.dart';

import '../QueueState.dart';

class NowPlayingTab extends StatefulWidget {
  const NowPlayingTab({Key? key}) : super(key: key);

  @override
  _NowPlayingTabState createState() => _NowPlayingTabState();
}

class _NowPlayingTabState extends State<NowPlayingTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<bool>(
        stream: AudioService.runningStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.active) {
            return SizedBox();
          }
          return Container(
            child: StreamBuilder<QueueState>(
              stream: _queueStateStream,
              builder: (context, snapshot) {
                final queueState = snapshot.data;
                final mediaItem = queueState?.mediaItem;
                if (queueState == null) {
                  return SizedBox();
                }
                return ListView.builder(
                    itemCount: queueState.queue.length,
                    itemBuilder: (context, index) => NowPlayingTile(
                        mediaItem: queueState.queue[index],
                        isCurrentPlaying: (queueState.queue[index].id != mediaItem!.id) ? false : true,
                        onTap: () {}));
              },
            ),
          );
        },
      ),
    );
  }

  /// A stream reporting the combined state of the current queue and the current
  /// media item within that queue.
  Stream<QueueState> get _queueStateStream =>
      Rx.combineLatest2<List<MediaItem>?, MediaItem?, QueueState>(
          AudioService.queueStream,
          AudioService.currentMediaItemStream,
          (queue, mediaItem) => QueueState(queue!, mediaItem!));
}
