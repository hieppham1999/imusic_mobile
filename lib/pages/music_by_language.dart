import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'package:imusic_mobile/components/now_playing_bar.dart';
import 'package:imusic_mobile/components/song_list_tile.dart';
import 'package:imusic_mobile/models/myAudioService.dart';

class MusicByLanguagePage extends StatefulWidget {
  const MusicByLanguagePage({Key? key,required this.languageName, required this.languageId}) : super(key: key);

  final int languageId;
  final String languageName;

  @override
  _MusicByLanguagePageState createState() => _MusicByLanguagePageState();
}

class _MusicByLanguagePageState extends State<MusicByLanguagePage> {

  bool _isLoading = false;

  List<MediaItem> _items = [];

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.languageName),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      bottomNavigationBar: NowPlayingBar(),
      body: (_isLoading) ?
      Center(child: CircularProgressIndicator(),) :
      Container(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _items.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) => SongListTile(
            mediaItem: _items[index],
          ),

        ),
      ),
    );
  }

  fetchData() async{
    setState(() {
      _isLoading = true;
    });

    var updatedItems = await MyAudioService.getSongByLanguage(languageId: widget.languageId, limit: 10);

    setState(() {
      _isLoading = false;
      _items = updatedItems;
    });
  }

}
