import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:imusic_mobile/HomeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Service Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AudioServiceWidget(child: HomeScreen()),
    );
  }
}
