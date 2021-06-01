import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:imusic_mobile/components/playlist_song_tile.dart';
import 'package:imusic_mobile/models/myAudioService.dart';
import 'package:imusic_mobile/models/playlist.dart';

import '../AudioPlayerTask.dart';
import '../music_player.dart';

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

  List<MediaItem> _songs = [];

  @override
  void initState() {
    getSongs(widget.playlist.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlist.name),
      ),
      body: Container(
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
                          widget.playlist.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        Text(
                          widget.playlist.tracks.toString() + ' songs',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                        Text(
                          '(Last updated: ' + widget.playlist.lastUpdated + ')',
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
            (_isloading)? Center(child: CircularProgressIndicator(),heightFactor: 0,) : Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _songs.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) => PlaylistSongTile(
                    mediaItem: _songs[index],
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

                      await AudioService.addQueueItem(_songs[index]);
                      await AudioService.skipToQueueItem(_songs[index].id);

                    }
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getSongs(int playlistId) async {
    setState(() {
      _isloading = true;
    });

    var updatedPlaylistSongs = await MyAudioService.getSongsFromPlaylist(playlistId);

    setState(() {
      _isloading = false;
      _songs = updatedPlaylistSongs;
    });
  }

}
