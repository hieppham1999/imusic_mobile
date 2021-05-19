import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';


class NowPlayingTile extends StatelessWidget {
  const NowPlayingTile({
    Key? key,
    required this.mediaItem,
    required this.isCurrentPlaying,
    onTap,
  }) : super(key: key);

  final MediaItem mediaItem;
  final bool isCurrentPlaying;

  @override
  Widget build(BuildContext context) {
    // if (mediaItem == null) {
    //   return SizedBox();
    // }
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery. of(context). size. width*0.1,
                child: (isCurrentPlaying)
                    ? Icon(Icons.music_note_outlined)
                    : Container(),
              ),
              InkWell(
                onTap: () async {
                  if (isCurrentPlaying) {
                    return;
                  } else {
                    await AudioService.skipToQueueItem(mediaItem.id);
                  }
                },
                child: Container(
                  width: MediaQuery. of(context). size. width*0.85,
                  child: Row(
                    children: [
                      Container(
                        height: 80.0,
                        width: 80.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          image: DecorationImage(
                              image: (mediaItem.artUri != null
                                      ? NetworkImage(mediaItem.artUri.toString())
                                      : AssetImage('assets/images/no_artwork.png'))
                                  as ImageProvider),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Container(
                        width: 190,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mediaItem.title,
                              overflow: TextOverflow.ellipsis,
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
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      PopupMenuButton(
                        onSelected: onSelected,
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'removeFromQueue',
                            child: Text('Remove From Queue'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'addToPlaylist',
                            child: Text('Add to Playlist'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Divider(
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