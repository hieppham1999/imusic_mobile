import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../music_player.dart';

Widget nowPlayingBar(BuildContext context) {
  return TextButton(
    onPressed: () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MusicPlayer(),));
    },
    style: ButtonStyle(
        enableFeedback: false,
        overlayColor:
            MaterialStateProperty.all<Color>(Colors.black.withOpacity(0.0)),
        backgroundColor:
            MaterialStateProperty.all<Color>(Colors.black.withOpacity(0.7))),
    child: Row(
      children: [
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
                image: NetworkImage(
                    "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg")),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 8),
          height: 70,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Title",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                "Artist",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
