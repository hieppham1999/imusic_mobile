import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:imusic_mobile/pages/add_song_to_playlist_dialog.dart';
import 'package:imusic_mobile/models/myAudioService.dart';
import '../AudioPlayerTask.dart';
import 'package:imusic_mobile/utils/MediaItemExtensions.dart';

class PlaylistSongTile extends StatelessWidget {
  const PlaylistSongTile({
    Key? key,
    required this.mediaItem,
    required this.playlistId,
    required this.reload,
  }) : super(key: key);

  final MediaItem mediaItem;
  final int playlistId;
  final Function() reload;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () async {
              if (!AudioService.running) {
                await AudioService.start(
                  backgroundTaskEntrypoint: audioPlayerTaskEntrypoint,
                  androidResumeOnClick: true,
                  androidEnableQueue: true,
                );
              }
              Navigator.of(context).pushNamed('/player');

              await AudioService.addQueueItem(mediaItem);
              await AudioService.skipToQueueItem(mediaItem.id);
            },
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.10,
              child: Row(
                children: [
                  Container(
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      image: DecorationImage(
                          image: (mediaItem.artUri != null
                                  ? NetworkImage(mediaItem.artUri.toString())
                                  : AssetImage('assets/images/no_artwork.png'))
                              as ImageProvider),
                    ),
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            mediaItem.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            mediaItem.artist!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  // Spacer(),
                  PopupMenuButton(
                    onSelected: (value) async {
                      switch (value) {
                        case 'addToQueue':
                          {
                            await AudioService.start(
                              backgroundTaskEntrypoint:
                                  audioPlayerTaskEntrypoint,
                              androidResumeOnClick: true,
                              androidEnableQueue: true,
                            );
                          }
                          AudioService.addQueueItem(mediaItem);
                          print('addToQueue');
                          break;
                        case 'addToPlaylist':
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AddSongToPlaylistDialog(
                                  mediaItem: mediaItem)));
                          break;
                        case 'removeFromPlaylist':
                          // await MyAudioService.removeSongFromPlaylist(
                          //     playlistId, mediaItem.getServerId());
                          reload();
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'addToQueue',
                        child: Text('Add to Queue'),
                        // enabled: (!isCurrentPlaying) ? true : false,
                      ),
                      PopupMenuItem<String>(
                        value: 'addToPlaylist',
                        child: Text('Add to Playlist...'),
                      ),
                      PopupMenuItem<String>(
                        value: 'removeFromPlaylist',
                        child: Text('Remove from playlist'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(
          thickness: 0.5,
          color: Colors.black45,
        ),
      ],
    );
  }

  // void onSelected(String value, BuildContext context) async {
  //   switch (value) {
  //     case 'addToQueue': {
  //       await AudioService.start(
  //         backgroundTaskEntrypoint: audioPlayerTaskEntrypoint,
  //         androidResumeOnClick: true,
  //         androidEnableQueue: true,
  //       );
  //     }
  //     AudioService.addQueueItem(mediaItem);
  //     print('addToQueue');
  //     break;
  //     case 'addToPlaylist':
  //       Navigator.of(context).push(MaterialPageRoute(
  //           builder: (context) => AddSongToPlaylistDialog(
  //             mediaItem: item,)));
  //       break;
  //   }
  // }
}
