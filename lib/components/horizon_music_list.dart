import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:imusic_mobile/components/song_card.dart';

class HorizonMusicList extends StatelessWidget {
  const HorizonMusicList({
    Key? key,
    required this.name,
    required this.mediaItems,
  }) : super(key: key);

  final String name;
  final List<MediaItem>? mediaItems;

  @override
  Widget build(BuildContext context) {
    return
      Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            color: Colors.red,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          height: 250,
          child: ListView.builder(
            shrinkWrap: true,
              itemCount: mediaItems!.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => songCard(
                context,
                mediaItems![index],
              )),
        ),

      ],
    );
  }
}