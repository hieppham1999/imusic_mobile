import 'package:flutter/material.dart';
import 'package:imusic_mobile/components/now_playing_bar.dart';
import 'package:imusic_mobile/components/popup_menu_container.dart';
import 'package:imusic_mobile/models/myAudioService.dart';
import 'package:imusic_mobile/models/playlist.dart';
import 'package:imusic_mobile/pages/playlist_detail_page.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({Key? key}) : super(key: key);

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  bool _isLoading = false;
  List<Playlist> _playlists = [];

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Playlist'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            },

        ),

      ),
      bottomNavigationBar: NowPlayingBar(),
      body:
      _isLoading ? Center(child: CircularProgressIndicator(),)
      : Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 8/11,

        ), itemCount: _playlists.length,
          itemBuilder: (context, index) =>
        PopupMenuContainer(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlaylistDetailPage(playlist: _playlists[index])));
          },
          onItemSelected: (value) { print('addSongToQueue'); },
          items: [
            PopupMenuItem(child: Text('Add to Now Playing'), value: 'addSongToQueue',),
          ],
          child: Container(

            child: Card(
              shadowColor: Colors.grey,
              child: Wrap(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.red,
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                    ),
                  ),
                  ListTile(
                    title: Text(
                        _playlists[index].name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    subtitle: Text(
                  _playlists[index].tracks.toString() + ' songs',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
            ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
    });
    var updatedList = (await (MyAudioService.getPlaylist()));

    setState(() {
      _playlists = updatedList;
      _isLoading = false;
    });
  }
}
