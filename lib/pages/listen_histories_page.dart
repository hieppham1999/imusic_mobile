import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:imusic_mobile/components/playlist_song_tile.dart';
import 'package:imusic_mobile/components/song_list_tile.dart';
import 'package:imusic_mobile/models/myAudioService.dart';

import '../AudioPlayerTask.dart';
import '../music_player.dart';

class ListenHistoriesPage extends StatefulWidget {
  const ListenHistoriesPage({Key? key}) : super(key: key);

  @override
  _ListenHistoriesPageState createState() => _ListenHistoriesPageState();
}

class _ListenHistoriesPageState extends State<ListenHistoriesPage> {

  bool _isLoading = false;

  List<MediaItem> _items = [];

  @override
  void initState() {
    fetchHistories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Histories'),
      ),
      body: (_isLoading) ?
      Center(child: CircularProgressIndicator(),) :
      Container(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _items.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) => PlaylistSongTile(
              mediaItem: _items[index],
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

                await AudioService.addQueueItem(_items[index]);
                await AudioService.skipToQueueItem(_items[index].id);

              }),

        ),
      ),
    );
  }

  fetchHistories() async{
    setState(() {
      _isLoading = true;
    });

    var updatedPlaylistSongs = await MyAudioService.getUserListenHistories();

    setState(() {
      _isLoading = false;
      _items = updatedPlaylistSongs;
    });
  }
}
