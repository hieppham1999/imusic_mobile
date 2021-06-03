import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:imusic_mobile/components/playlist_song_tile.dart';
import 'package:imusic_mobile/models/myAudioService.dart';
import 'package:imusic_mobile/models/playlist.dart';

import '../AudioPlayerTask.dart';
import '../music_player.dart';

class PlaylistDetailPage extends StatefulWidget {
  const PlaylistDetailPage({Key? key, required this.playlistId})
      : super(key: key);

  final int playlistId;

  @override
  _PlaylistDetailPageState createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage> {
  bool _isLoading = false;
  Playlist _playlist = Playlist(id: 0, name: '', tracks: 0, lastUpdated: '');
  String appBarTile = 'Playlist';

  List<MediaItem> _songs = [];

  @override
  void initState() {
    getData(widget.playlistId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTile),
      ),
      body: (_isLoading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 8, left: 8),
                    color: Colors.grey.shade200,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/no_artwork.png'),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 7,
                                offset: Offset(0, 6),
                              )
                            ],
                          ),
                          height: double.infinity,
                          child: AspectRatio(
                            aspectRatio: 1 / 1,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      _playlist.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    InkWell(
                                      child: Icon(
                                        Icons.edit_rounded,
                                        size: 20,
                                      ),
                                      onTap: _showDialog,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                _playlist.tracks.toString() + ' songs',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                '(Last updated: ' + _playlist.lastUpdated + ')',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400),
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (_songs.isEmpty) {
                                          return;
                                        } else {
                                          if (!AudioService.running) {
                                            await AudioService.start(
                                              backgroundTaskEntrypoint:
                                                  audioPlayerTaskEntrypoint,
                                              androidResumeOnClick: true,
                                              androidEnableQueue: true,
                                            );
                                          }
                                          await AudioService.updateQueue(
                                              _songs);
                                          await AudioService.setShuffleMode(AudioServiceShuffleMode.all);

                                          await AudioService.skipToQueueItem(
                                              _songs.first.id);
                                          await Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MusicPlayer()));
                                        }
                                      },
                                      child: Text(
                                        'Shuffle play',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.lightBlue),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                                side: BorderSide(
                                                    color:
                                                        Colors.transparent))),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: Container(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  buildItems(),
                ],
              ),
            ),
    );
  }

  Expanded buildItems() {
    if (_songs.isEmpty) return Expanded(child: Center(child: Text('No Items'),));
    else {
      return Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _songs.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) => PlaylistSongTile(
            mediaItem: _songs[index],
            playlistId: _playlist.id,
            reload: () => getData(_playlist.id),
          ),
        ),
      );
    }
  }

  void getData(int playlistId) async {
    setState(() {
      _isLoading = true;
    });

    var updatedPlaylistInfo = await MyAudioService.getPlaylistInfo(playlistId);
    var updatedPlaylistSongs =
        await MyAudioService.getSongsFromPlaylist(playlistId);

    setState(() {
      _isLoading = false;
      _playlist = updatedPlaylistInfo!;
      appBarTile = _playlist.name;
      _songs = updatedPlaylistSongs;
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
                    child: const Text('CHANGE'),
                    onPressed: () async {
                      print(typedValue);
                      MyAudioService.editPlaylistName(
                              typedValue, widget.playlistId)
                          .then((response) {
                        print('changed successfully!');
                        Navigator.of(context).pop(true);
                      });
                    })
              ],
            ),
          );
        })) {
      case true:
        final snackBar = SnackBar(content: Text('Changed successfully!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          getData(widget.playlistId);
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
    // var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        // padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
