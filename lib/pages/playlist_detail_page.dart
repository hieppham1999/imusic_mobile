import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart' hide ReorderableList;
import 'package:flutter/cupertino.dart' hide ReorderableList;
import 'package:imusic_mobile/components/marque_text.dart';
import 'package:imusic_mobile/components/playlist_song_tile.dart';
import 'package:imusic_mobile/models/myAudioService.dart';
import 'package:imusic_mobile/models/playlist.dart';
import '../AudioPlayerTask.dart';
import 'package:imusic_mobile/utils/MediaItemExtensions.dart';

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
  bool _isListChanged = false;

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
        actions: [
          (_isListChanged)
              ? TextButton(
                  onPressed: () async {
                    // [{ for(var item in _songs) "song_id": item.getServerId(), "order": _songs.indexOf(item) }]
                    final songOrder = _songs.map((item) {
                      return {
                        "song_id": item.getServerId(),
                        "order": _songs.indexOf(item)
                      };
                    }).toList();

                    var responseCode = await (MyAudioService.modifyPlaylist(
                        playlistId: widget.playlistId, order: songOrder));
                    if (responseCode == 200) {
                      setState(() {
                        _isListChanged = false;
                      });
                      final snackBar = SnackBar(
                          content: Text('Playlist updated successfully!'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      return;
                    }
                  },
                  child: Text(
                    'SAVE',
                    style: TextStyle(color: Colors.white),
                  ))
              : Container(),
        ],
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
                          width: MediaQuery.of(context).size.width * 0.5,
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
                                    Container(
                                      child: MarqueeText(
                                          text: _playlist.name, fontSize: 24),
                                      constraints:
                                          BoxConstraints(maxWidth: 150),
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
                                          // await AudioService.skipToQueueItem(_songs.first.id);
                                          await AudioService.setShuffleMode(
                                              AudioServiceShuffleMode.all);
                                          await AudioService.play();
                                          Navigator.of(context)
                                              .pushNamed('/player');
                                        }
                                      },
                                      // Shuffle play Button
                                      child: Text(
                                        'SHUFFLE PLAY',
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
                    height: 15,
                    child: Container(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  _buildPlaylistItems(),
                ],
              ),
            ),
    );
  }

  Expanded _buildPlaylistItems() {
    if (_songs.isEmpty) {
      return Expanded(
          child: Center(
              child: Text('No Items'),
      ));
    } else
      return Expanded(
        child: ReorderableListView.builder(
          // padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              _isListChanged = true;
              final MediaItem item = _songs.removeAt(oldIndex);
              _songs.insert(newIndex, item);
            });
          },
          itemCount: _songs.length,
          itemBuilder: (BuildContext context, int index) {
            return PlaylistSongTile(
              key: Key('$index'),
              mediaItem: _songs[index],
              playlistId: _playlist.id,
              reload: () {
                setState(() {
                  _isListChanged = true;
                  _songs.removeAt(index);
                });
              },
            );
          },
        ),
      );
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
