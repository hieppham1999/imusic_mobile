import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('iMusic'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: start, child: Text("Start")),
            ElevatedButton(onPressed: stop, child: Text("Stop")),
          ],
        ),
      ),
    );
  }
  start() =>
      AudioService.start(backgroundTaskEntrypoint: _backgroundTaskEntrypoint);
  stop() => AudioService.stop();
}
