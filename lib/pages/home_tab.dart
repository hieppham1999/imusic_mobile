import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'package:imusic_mobile/MediaLibrary.dart';
import 'package:imusic_mobile/components/song_listview.dart';
import 'package:imusic_mobile/models/myMediaItem.dart';
import '../AudioPlayerTask.dart';
import '../music_player.dart';

class HomeTab extends StatefulWidget {

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  MediaLibrary _newSong = new MediaLibrary();
  List<MyMediaItem>? items = [];
  var loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSongs();
  }

  void fetchSongs() async {
    setState(() {
      loading = true;
    });
    var updatedList = (await (_newSong.fetchItem('/songs')));
    setState(() {
      items = updatedList;
      loading = false;
    });
  }


  @override
  Widget build(BuildContext context) {


    // final items = <MediaItem>[
    //   MediaItem(
    //     id: "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3",
    //     album: "Science Friday",
    //     title: "A Salute To Head-Scratching Science",
    //     artist: "Science Friday and WNYC Studios",
    //     duration: Duration(milliseconds: 5739820),
    //     artUri: Uri.parse(
    //         "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg"),
    //   ),
    //   MediaItem(
    //     id: "http://192.168.0.150:8000/storage/media/songs/24H---LyLy;-Magazine.mp3",
    //     album: "24H (Single)",
    //     title: "24H",
    //     artist: "Lyly; The Magazine",
    //     duration: Duration(milliseconds: 257000),
    //     artUri: Uri.parse(
    //         "http://192.168.0.150:8000/storage/media/album_arts/24H---LyLy;-Magazine.jpg"),
    //   ),
    //   MediaItem(
    //     id: "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3",
    //     album: "Ninja Tuna",
    //     title: "Kalimba",
    //     artist: "Mr. Scruff",
    //     duration: Duration(milliseconds: 348000),
    //     artUri: Uri.parse(
    //         "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg"),
    //   ),
    // ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "New Music",
            style: TextStyle(
              color: Colors.red,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: items!.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => songListView(
                      context,
                      items![index],
                    )),
          ),

        ],
      ),
    );
  }
}
