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
                width: 40,
                child: (isCurrentPlaying)
                    ? Icon(Icons.music_note_outlined)
                    : Container(),
              ),
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
                width: 210,
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
              IconButton(icon: Icon(Icons.queue), onPressed: () {})
            ],
          ),
        ),
        Divider(
          color: Colors.black45,
        ),
      ],
    );
  }
}