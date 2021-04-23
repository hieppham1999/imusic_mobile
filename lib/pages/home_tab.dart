import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'package:imusic_mobile/MediaLibrary.dart';
import 'package:imusic_mobile/components/horizon_music_list.dart';
import 'package:imusic_mobile/components/song_listview.dart';
import 'package:imusic_mobile/models/myMediaItem.dart';
import '../AudioPlayerTask.dart';
import '../music_player.dart';

class HomeTab extends StatefulWidget {

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin<HomeTab> {

  @override
  bool get wantKeepAlive => true;

  MediaLibrary _mediaLibrary = new MediaLibrary();
  List<MyMediaItem>? latestSongs = [];
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
    var updatedList = (await (_mediaLibrary.fetchItem('/songs/recently?lim=10')));
    setState(() {
      latestSongs = updatedList;
      loading = false;
    });
  }


  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            HorizonMusicList(name: "Recently Upload", mediaItems: latestSongs),
            HorizonMusicList(name: "Hot Music", mediaItems: latestSongs),
          ],
        ),
      ),
    );
  }
}


