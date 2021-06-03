import 'package:flutter/material.dart';
import 'package:imusic_mobile/MediaLibrary.dart';
import 'package:imusic_mobile/components/horizon_music_list.dart';
import 'package:imusic_mobile/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:audio_service/audio_service.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab>
    with AutomaticKeepAliveClientMixin<HomeTab> {
  @override
  bool get wantKeepAlive => true;

  MediaLibrary _mediaLibrary = new MediaLibrary();
  List<MediaItem>? latestSongs = [];
  List<MediaItem>? hotSongs = [];
  List<MediaItem>? recommendSongs = [];
  var loading = false;

  @override
  void initState() {
    // TODO: implement initState
    fetchSongs();
    super.initState();
  }

  Future<void> fetchSongs() async {
    setState(() {
      loading = true;
    });
    var updatedList =
        (await (_mediaLibrary.fetchItem('/songs/recently?lim=10')));
    var updatedHotList = (await (_mediaLibrary.fetchItem('/songs/hot?t=m')));
    var updatedRecommendList =
        Provider.of<Auth>(context, listen: false).authenticated
            ? await (_mediaLibrary.fetchUserSongData('/me/recommend'))
            : null;
    setState(() {
      latestSongs = updatedList;
      hotSongs = updatedHotList;
      recommendSongs = updatedRecommendList;
      loading = false;
    });
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    if (loading)
      return Center(
        child: CircularProgressIndicator(),
      );
    return RefreshIndicator(
      onRefresh: _pullRefresh,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<Auth>(builder: (context, auth, child) {
                if (auth.authenticated) {
                  // fetchSongs();
                  return HorizonMusicList(
                      name: "Recommend Music", mediaItems: recommendSongs);
                } else {
                  return SizedBox();
                }
              }),
              HorizonMusicList(
                  name: "Recently Upload", mediaItems: latestSongs),
              HorizonMusicList(name: "Hot Music", mediaItems: hotSongs),
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
