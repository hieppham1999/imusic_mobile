import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import 'AudioPlayerTask.dart';

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
        child: StreamBuilder<PlaybackState>(
            stream: AudioService.playbackStateStream,
            builder: (context, snapshot) {
              final playing = snapshot.data?.playing ?? false;
              final processingState = snapshot.data?.processingState
                  ?? AudioProcessingState.stopped;
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  if (playing)
                    ElevatedButton(child: Text("Pause"), onPressed: pause)
                  else
                    ElevatedButton(child: Text("Play"), onPressed: play),
                  if (processingState != AudioProcessingState.stopped)
                    ElevatedButton(child: Text("Stop"), onPressed: stop),
                  ],
              );
            },
        ),
      ),
    );
  }
  start() =>
      AudioService.start(backgroundTaskEntrypoint: backgroundTaskEntrypoint);
  stop() => AudioService.stop();

  play() async {
    if (await AudioService.running) {
      AudioService.play();
    } else {
      AudioService.start(backgroundTaskEntrypoint: backgroundTaskEntrypoint);
    }
  }

  pause() => AudioService.pause();


}