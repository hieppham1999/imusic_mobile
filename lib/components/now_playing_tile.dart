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
                  width: MediaQuery.of(context).size.width*0.85,
                  height: MediaQuery.of(context).size.height*0.1,
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
                                  color: Colors.white,
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
                            enabled: (!isCurrentPlaying) ? true : false,
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