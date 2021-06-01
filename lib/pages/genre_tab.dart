import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:imusic_mobile/components/horizon_music_list.dart';

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
    fetchSongs();
    super.initState();

  }

  Future<void> fetchSongs() async {
    setState(() {
      loading = true;
    });
    var popList = (await (_songsByGenre.fetchItem('/songs/genre/10?lim=10')));
    var edmList = (await (_songsByGenre.fetchItem('/songs/genre/3?lim=10')));
    var rockList = (await (_songsByGenre.fetchItem('/songs/genre/13?lim=10')));
    setState(() {
      popGenreItems = popList;
      edmGenreItems = edmList;
      rockGenreItems = rockList;
      loading = false;
    });
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    if (loading) return Center(child: CircularProgressIndicator(),);
    return RefreshIndicator(
      onRefresh: _pullRefresh,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              HorizonMusicList(name: "Pop", mediaItems: popGenreItems),
              HorizonMusicList(name: "EDM", mediaItems: edmGenreItems),
              HorizonMusicList(name: "Rock", mediaItems: rockGenreItems),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    await fetchSongs();
  }
}
