import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:imusic_mobile/models/myAudioService.dart';
import 'package:imusic_mobile/components/song_list_tile.dart';

import '../AudioPlayerTask.dart';
import '../music_player.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchQueryController = TextEditingController();

  String _searchQuery = "";

  List<MediaItem> _mediaItems = [];

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: BackButton(
          onPressed: () {
            _clearSearchQuery();
            Navigator.pop(context);
          },
        ),
        title: _buildSearchField(),
        centerTitle: true,
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _clearSearchQuery();
            }
          )
        ],

      ),
      body: _isLoading ?
      Center(child: CircularProgressIndicator(),) :
      Container(
        child: ListView.builder(
          shrinkWrap: true,
            itemCount: _mediaItems.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) => SongListTile(
              context: context,
                mediaItem: _mediaItems[index],
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

                  await AudioService.addQueueItem(_mediaItems[index]);
                  await AudioService.skipToQueueItem(_mediaItems[index].id);

                }),

              )
        ),

      );

  }

  Widget _buildSearchField() {
    return Container(
      height: 38,
      child: TextField(
        controller: _searchQueryController,
        autofocus: true,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: "Search for song...",
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.black38),
        ),
        style: TextStyle(color: Colors.black, fontSize: 16.0),
        onChanged: (query) => updateSearchQuery(query),
        onSubmitted: (query) => _submit(query)

        ,
      ),
    );
  }

  void _submit(String searchQuery) async {
    setState(() {
      _isLoading = true;
      _searchQuery = searchQuery;
    });

    var updatedSearchResponse = (await (MyAudioService.searchByKeyword(_searchQuery)));

    setState(() {
      _isLoading = false;
      _mediaItems = updatedSearchResponse;
    });

  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      _searchQuery = newQuery;
    });
  }

  // void _stopSearching() {
  //   _clearSearchQuery();
  //   //
  //   // setState(() {
  //   //   _isSearching = false;
  //   // });
  // }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }

}
