import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:imusic_mobile/models/myAudioService.dart';
import 'package:imusic_mobile/models/myMediaItem.dart';

import '../AudioPlayerTask.dart';
import '../music_player.dart';

Widget songListView(BuildContext context, MyMediaItem item) {
  return Column(
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
                onTap: () async {
                  await AudioService.start(
                    backgroundTaskEntrypoint: audioPlayerTaskEntrypoint,
                    androidResumeOnClick: true,
                    androidEnableQueue: true,
                  );
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MusicPlayer(),
                  ));

                  await AudioService.addQueueItem(item);
                  await MyAudioService.skipToQueueItemWithServerId(item.id, item.serverId);
                  // AudioService.skipToQueueItem(item.id, item.serverId);
                },
              )
            ],
          ),
        ),
      ),
    ],
  );
}
