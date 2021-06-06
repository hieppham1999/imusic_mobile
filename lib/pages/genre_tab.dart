import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:imusic_mobile/components/horizon_music_list.dart';
import 'package:imusic_mobile/models/myAudioService.dart';


class GenreTab extends StatefulWidget {
  @override
  _GenreTabState createState() => _GenreTabState();
}

class _GenreTabState extends State<GenreTab> with AutomaticKeepAliveClientMixin<GenreTab> {

  @override
  bool get wantKeepAlive => true;

  List<MediaItem>? popItems = [];
  List<MediaItem>? edmItems = [];
  List<MediaItem>? rockItems = [];
  List<MediaItem>? hipHopItems = [];
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
    var popList = (await (MyAudioService.getSongByGenre(genreId: 10, limit: 10)));
    var edmList = (await (MyAudioService.getSongByGenre(genreId: 3, limit: 10)));
    var rockList = (await (MyAudioService.getSongByGenre(genreId: 13, limit: 10)));
    var hipHopList = (await (MyAudioService.getSongByGenre(genreId: 4, limit: 10)));
    setState(() {
      popItems = popList;
      edmItems = edmList;
      rockItems = rockList;
      hipHopItems = hipHopList;
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
        padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HorizonMusicList(name: "POP", mediaItems: popItems),
              HorizonMusicList(name: "EDM", mediaItems: edmItems),
              HorizonMusicList(name: "ROCK", mediaItems: rockItems),
              HorizonMusicList(name: "HIP-HOP", mediaItems: hipHopItems),
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
