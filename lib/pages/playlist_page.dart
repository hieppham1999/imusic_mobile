import 'package:audio_service/audio_service.dart';
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
        actions: [
          TextButton(
              onPressed: _showDialog,
              child: Text(
                'CREATE',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      bottomNavigationBar: NowPlayingBar(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 8 / 11,
                ),
                itemCount: _playlists.length,
                itemBuilder: (context, index) => PopupMenuContainer(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            PlaylistDetailPage(playlist: _playlists[index])));
                  },
                  onItemSelected: (value) async{
                    switch (value) {
                      // case 'addSongsToQueue':
                      //   print('addSongsToQueue');
                      //   break;
                      case 'deletePlaylist':
                        print('deletePlaylist');
                        final responseCode = await MyAudioService.deletePlaylist(_playlists[index].id);
                        if (responseCode == 200) {
                          final snackBar = SnackBar(content: Text('Delete successfully!'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          setState(() {
                            fetchData();
                          });
                        } else {
                          final snackBar = SnackBar(content: Text('Delete failed!'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                        break;
                    }

                  },
                  items: [
                    // PopupMenuItem(
                    //   child: Text('Add to Now Playing'),
                    //   value: 'addSongsToQueue',
                    // ),
                    PopupMenuItem(
                      child: Text('Delete playlist'),
                      value: 'deletePlaylist',
                    ),
                  ],
                  child: Container(
                    child: Card(
                      shadowColor: Colors.grey,
                      child: Wrap(
                        children: [
                          Container(
                            width: double.infinity,
                            color: Colors.lightBlueAccent,
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
                                  fontSize: 16, fontWeight: FontWeight.w600),
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
    var updatedList = (await (MyAudioService.getPlaylists()));

    setState(() {
      _playlists = updatedList;
      _isLoading = false;
    });
  }

  _showDialog() async {
    switch (await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          String typedValue = "";
          return _SystemPadding(
            child: AlertDialog(
              contentPadding: const EdgeInsets.all(16.0),
              content: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        typedValue = value;
                      },
                      autofocus: true,
                      decoration: InputDecoration(
                          labelStyle: TextStyle(fontSize: 16),
                          labelText: 'Playlist Name',
                          hintText: 'eg. Nhạc EDM cực chất'),
                    ),
                  )
                ],
              ),
              actions: <Widget>[
                TextButton(
                    child: const Text('CANCEL'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    }),
                TextButton(
                    child: const Text('OPEN'),
                    onPressed: () async {
                      print(typedValue);
                      MyAudioService.createPlaylist(typedValue)
                          .then((response) {
                        print('create successfully!');
                      });
                      Navigator.of(context).pop(true);
                    })
              ],
            ),
          );
        })) {
      case true:
        final snackBar = SnackBar(content: Text('Created successfully!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          fetchData();
        });
        break;
      case false:
        break;
      case null:
        break;
    }
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        // padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
