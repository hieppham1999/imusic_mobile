import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:imusic_mobile/components/popup_menu_container.dart';
import 'package:imusic_mobile/pages/add_song_to_playlist_dialog.dart';
import '../AudioPlayerTask.dart';

Widget songCard(BuildContext context, MediaItem item) {
  return PopupMenuContainer(
    items: [
      PopupMenuItem(
        child: Text('Add to Now Playing'),
        value: 'addSongToQueue',
      ),
      PopupMenuItem(
        child: Text('Add to playlist...'),
        value: 'addToPlaylist',
      ),
    ],
    onTap: () async {
      if (!AudioService.running) {
        await AudioService.start(
          backgroundTaskEntrypoint: audioPlayerTaskEntrypoint,
          androidResumeOnClick: true,
          androidEnableQueue: true,
        );
      }
      Navigator.of(context).pushNamed('/player');

      await AudioService.addQueueItem(item);
      await AudioService.skipToQueueItem(item.id);
    },
    onItemSelected: (value) async {
      switch (value) {
        case 'addSongToQueue':
          {
            if (!AudioService.running) {
              await AudioService.start(
                backgroundTaskEntrypoint: audioPlayerTaskEntrypoint,
                androidResumeOnClick: true,
                androidEnableQueue: true,
              );
            }
            AudioService.addQueueItem(item);
            print('addSongToQueue');
          }
          break;
        case 'addToPlaylist':
          {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    AddSongToPlaylistDialog(mediaItem: item)));
          }
          break;
        case null:
          break;
        default:
          {
            print('null');
            return;
          }
      }
    },
    child: Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height*0.3,
          // TODO
          width: MediaQuery.of(context).size.width*0.4,
          child: Card(
            child: Wrap(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ResizeImage(
                          (item.artUri != null
                              ? NetworkImage(item.artUri.toString())
                              : AssetImage('assets/images/no_artwork.png'))
                          as ImageProvider, width: 200
                      )
                    )
                  ),
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                  ),
                ),
                ListTile(
                  title: Text(
                    item.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                  subtitle: Text(
                    item.artist!,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
