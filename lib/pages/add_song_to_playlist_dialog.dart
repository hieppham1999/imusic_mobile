import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imusic_mobile/models/myAudioService.dart';
import 'package:imusic_mobile/models/playlist.dart';
import 'package:imusic_mobile/utils/MediaItemExtensions.dart';

class AddSongToPlaylistDialog extends StatefulWidget {

  final MediaItem mediaItem;

  const AddSongToPlaylistDialog({Key? key, required this.mediaItem}) : super(key: key);

  @override
  _AddSongToPlaylistDialogState createState() => _AddSongToPlaylistDialogState();
}

class _AddSongToPlaylistDialogState extends State<AddSongToPlaylistDialog> {
  List<Playlist> _playlists = [];
  bool _isLoading = false;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Add song to playlist'),
      ),
      body: (_isLoading) ? Center(child: CircularProgressIndicator(),) : ListView.builder(
        itemCount: _playlists.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) =>
              Column(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                  onTap: () {
                      MyAudioService.addSongToPlaylist(_playlists[index].id, widget.mediaItem.getServerId());
                    Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.13,
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            height: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              image: DecorationImage(
                                  image: ResizeImage(AssetImage('assets/images/no_artwork.png'), width: 200
                                  )),
                            ),
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                            ),
                          ),
                          SizedBox(width: 10.0,),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _playlists[index].name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 10.0,),
                                  Text(
                                    _playlists[index].tracks.toString() + ' songs',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                    ),

                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Divider(color: Colors.black45,),
                ],
              )


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

}
