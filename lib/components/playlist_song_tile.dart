import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';


class PlaylistSongTile extends StatelessWidget {
  const PlaylistSongTile({
    Key? key,
    required this.mediaItem,
    required this.onTap,

  }) : super(key: key);

  final MediaItem mediaItem;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onTap,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height*0.13,
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
                    onSelected: onSelected,
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'removeFromQueue',
                        child: Text('Remove From Queue'),
                        // enabled: (!isCurrentPlaying) ? true : false,
                      ),
                      PopupMenuItem<String>(
                        value: 'addToPlaylist',
                        child: Text('Add to Playlist'),
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


  void onSelected(String value) {
    switch (value) {
      case 'removeFromQueue': {
        AudioService.removeQueueItem(mediaItem);
        print('removeFromQueue');
      }
      break;
      case 'Settings':
        break;
    }
  }
}