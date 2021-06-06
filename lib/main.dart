import 'package:flutter/material.dart';
import 'package:imusic_mobile/Auth/login_screen.dart';
import 'package:imusic_mobile/Auth/register_screen.dart';
import 'package:imusic_mobile/HomeScreen.dart';
import 'package:imusic_mobile/pages/listen_histories_page.dart';
import 'package:imusic_mobile/pages/playlist_page.dart';
import 'package:imusic_mobile/pages/search_page.dart';
import 'package:imusic_mobile/services/auth.dart';
import 'package:provider/provider.dart';

import 'music_player.dart';

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
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      // home: AudioServiceWidget(child: HomeScreen()),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/playlist': (context) => PlaylistPage(),
        '/histories': (context) => ListenHistoriesPage(),
        '/player': (context) => MusicPlayer(),
        '/search': (context) => SearchPage(),
      },
    );
  }
}
