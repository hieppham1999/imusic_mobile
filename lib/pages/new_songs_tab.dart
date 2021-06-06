import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:imusic_mobile/components/song_list_tile.dart';
import 'package:imusic_mobile/models/myAudioService.dart';

class NewSongsTab extends StatefulWidget {
  @override
  _NewSongsTabState createState() => _NewSongsTabState();
}

class _NewSongsTabState extends State<NewSongsTab> with AutomaticKeepAliveClientMixin<NewSongsTab> {

  @override
  bool get wantKeepAlive => true;

  List<MediaItem>? _items = [];
  var _isLoading = false;

  @override
  void initState() {
    fetchSongs();
    super.initState();
  }

  Future<void> fetchSongs() async {
    setState(() {
      _isLoading = true;
    });
    var updatedList = (await (MyAudioService.getNewSongs(limit: 10)));

    setState(() {
      _items = updatedList;
      _isLoading = false;
    });
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    if (_isLoading) return Center(child: CircularProgressIndicator(),);
    return RefreshIndicator(
      onRefresh: _pullRefresh,
      child: Container(
        padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _items!.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) => SongListTile(
            mediaItem: _items![index],
          ),

        ),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    await fetchSongs();
  }
}
