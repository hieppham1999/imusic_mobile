import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:imusic_mobile/components/playlist_song_tile.dart';
import 'package:imusic_mobile/models/myAudioService.dart';
import 'package:imusic_mobile/models/playlist.dart';


class PlaylistDetailPage extends StatefulWidget {
  const PlaylistDetailPage({
    Key? key,
    required this.playlist}) : super(key: key);

  final Playlist playlist;

  @override
  _PlaylistDetailPageState createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage> {

  bool _isloading = false;
  Playlist _playlist = Playlist(id: 0, name: '', tracks: 0, lastUpdated: '');

  List<MediaItem> _songs = [];

  @override
  void initState() {
    getData(widget.playlist.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(_playlist.name),
      ),
      body: (_isloading)? Center(child: CircularProgressIndicator(),) :
      Container(
        padding: EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width,
        // height: double.infinity,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 8, left: 8),
              color: Colors.grey.shade200,
              height: MediaQuery.of(context).size.height*0.2,
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
                  SizedBox(width: 10,),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _playlist.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        Text(
                          _playlist.tracks.toString() + ' songs',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                        Text(
                          '(Last updated: ' + _playlist.lastUpdated + ')',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400
                          ),
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
            Expanded(
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
            ),
          ],
        ),
      ),
    );
  }

  void getData(int playlistId) async {
    setState(() {
      _isloading = true;
    });

    var updatedPlaylistInfo = await MyAudioService.getPlaylistInfo(playlistId);
    var updatedPlaylistSongs = await MyAudioService.getSongsFromPlaylist(playlistId);

    setState(() {
      _isloading = false;
      _playlist = updatedPlaylistInfo!;
      _songs = updatedPlaylistSongs;
    });
  }

}
