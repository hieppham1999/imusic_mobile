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
          visible:
          processingState != AudioProcessingState.none ? true : false,
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
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                            image: artCover),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 8),
                      height: 70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mediaItem?.title ?? "Unknown",
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
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }
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

}

// Widget nowPlayingBar(BuildContext context) {
//   return StreamBuilder<AudioProcessingState>(
//     stream: AudioService.playbackStateStream
//         .map((state) => state.processingState)
//         .distinct(),
//     builder: (context, snapshot) {
//       final processingState = snapshot.data ?? AudioProcessingState.none;
//       return Visibility(
//         visible:
//           processingState != AudioProcessingState.none ? true : false,
//         child: TextButton(
//           onPressed: () {
//             Navigator.of(context).push(MaterialPageRoute(
//               builder: (context) => MusicPlayer(),
//             ));
//           },
//           style: ButtonStyle(
//               enableFeedback: false,
//               overlayColor: MaterialStateProperty.all<Color>(
//                   Colors.black.withOpacity(0.0)),
//               backgroundColor: MaterialStateProperty.all<Color>(
//                   Colors.black.withOpacity(0.7))),
//           child: Row(
//             children: [
//               Container(
//                 height: 70,
//                 width: 70,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   image: DecorationImage(
//                       image: NetworkImage(
//                           "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg")),
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.only(left: 8),
//                 height: 70,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Title",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 8.0,
//                     ),
//                     Text(
//                       "Artist",
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }
