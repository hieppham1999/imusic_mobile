import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:imusic_mobile/components/horizon_music_list.dart';
import 'package:imusic_mobile/components/song_listview.dart';
import 'package:imusic_mobile/models/myMediaItem.dart';

import '../MediaLibrary.dart';

class GenreTab extends StatefulWidget {
  @override
  _GenreTabState createState() => _GenreTabState();
}

class _GenreTabState extends State<GenreTab> with AutomaticKeepAliveClientMixin<GenreTab> {

  @override
  bool get wantKeepAlive => true;

  MediaLibrary _songsByGenre = new MediaLibrary();
  List<MediaItem>? popGenreItems = [];
  List<MediaItem>? edmGenreItems = [];
  List<MediaItem>? rockGenreItems = [];
  var loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSongs();
  }

  void fetchSongs() async {
    setState(() {
      loading = true;
    });
    popGenreItems = (await (_songsByGenre.fetchItem('/songs/genre/10?lim=10')));
    edmGenreItems = (await (_songsByGenre.fetchItem('/songs/genre/3?lim=10')));
    rockGenreItems = (await (_songsByGenre.fetchItem('/songs/genre/13?lim=10')));
    setState(() {
      // popGenreItems = updatedItems;
      // edmGenreItems = updatedItems2;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // HorizonMusicList(name: "Pop", mediaItems: popGenreItems),
            // HorizonMusicList(name: "EDM", mediaItems: edmGenreItems),
            // HorizonMusicList(name: "Rock", mediaItems: rockGenreItems),
          ],
        ),
      ),
    );
  }
}
