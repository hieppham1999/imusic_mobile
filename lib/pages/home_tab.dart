import 'package:flutter/material.dart';

import '../music_player.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          height: 225.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Container(
                width: 160.0,
                child: Card(
                  child: Wrap(
                    children: <Widget>[
                      Image.network("https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg"),
                      ListTile(
                        title: Text("24H"),
                        subtitle: Text("Lyly; The Magazine"),
                        onTap: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => MusicPlayer(),
                            )
                          );
                        },
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
