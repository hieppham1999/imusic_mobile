import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:imusic_mobile/HomeScreen.dart';
import 'package:imusic_mobile/music_player.dart';
import 'package:imusic_mobile/services/auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => Auth()),
            ],
            child: MyApp(),
          )
      );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'iMusic',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AudioServiceWidget(child: HomeScreen()),
    );
  }
}
