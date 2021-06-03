import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:imusic_mobile/components/popup_menu_container.dart';

import '../AudioPlayerTask.dart';

Widget SearchSongResult(
    {MediaItem? mediaItem, onTap, required BuildContext context}) {
  if (mediaItem == null) {
    return SizedBox();
  }
  return PopupMenuContainer(
    items: [
      PopupMenuItem(
        child: Text('Add to Now Playing'),
        value: 'addToQueue',
      ),
      PopupMenuItem(
        child: Text('Save To Playlist'),
        value: 'addToPlaylist',
      ),
    ],
    onTap: onTap,
    onItemSelected: (value) async {
      switch (value) {
        case 'addToQueue':
          {
            if (!AudioService.running) {
              await AudioService.start(
                backgroundTaskEntrypoint: audioPlayerTaskEntrypoint,
                androidResumeOnClick: true,
                androidEnableQueue: true,
              );
            }
            AudioService.addQueueItem(mediaItem);
            print('addToQueue');
          }
          break;
        case 'addToPlaylist':
          {
            print('addToPlaylist');
          }
          break;
        default:
          {
            print('null');
            return;
          }
      }
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.13,
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
                )
              ],
            ),
          ),
        ),
        Divider(
          color: Colors.black45,
        ),
      ],
    ),
  );
}
