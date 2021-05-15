import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:imusic_mobile/components/popup_menu_container.dart';
import '../AudioPlayerTask.dart';
import '../music_player.dart';

Widget songCard(BuildContext context, MediaItem item) {
  return PopupMenuContainer(
    items: [
      PopupMenuItem(child: Text('Add to Now Playing'), value: 'addSongToQueue',),
      PopupMenuItem(child: Text('Save To Playlist'), value: 'addSongToPlaylist',),
    ],
    onTap: () async {
      if (!AudioService.running) {
        await AudioService.start(
          backgroundTaskEntrypoint: audioPlayerTaskEntrypoint,
          androidResumeOnClick: true,
          androidEnableQueue: true,
        );
      }
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MusicPlayer(),
      ));

      await AudioService.addQueueItem(item);
      await AudioService.skipToQueueItem(item.id);

    },
    onItemSelected: (value) async {
      switch (value) {
        case 'addSongToQueue': {
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
        case 'addSongToPlaylist': {
          print('addSongToPlaylist');
        }
        break;
        default: {
          print('null');
          return;
        }
      }

    },
    child: Column(
      children: [
        Container(
          height: 225.0,
          width: 160.0,
          child: Card(
            child: Wrap(
              children: <Widget>[
                Container(
                  height: 150,
                  width: 150,
                  child: FadeInImage(image: NetworkImage(item.artUri.toString()), placeholder: AssetImage('assets/images/no_artwork.png')),

                  // Image.network(
                  //     item.artUri.toString(),
                  // ),
                ),
                ListTile(
                  title: Text(
                    item.title,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    item.artist!,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // onTap: () async {
                  //   if (!AudioService.running) {
                  //     await AudioService.start(
                  //       backgroundTaskEntrypoint: audioPlayerTaskEntrypoint,
                  //       androidResumeOnClick: true,
                  //       androidEnableQueue: true,
                  //     );
                  //   }
                  //   Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => MusicPlayer(),
                  //   ));
                  //
                  //   await AudioService.addQueueItem(item);
                  //   await AudioService.skipToQueueItem(item.id);
                  //
                  // },
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
