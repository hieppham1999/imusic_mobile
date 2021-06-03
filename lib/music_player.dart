import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imusic_mobile/pages/now_playing_tab.dart';
import 'package:imusic_mobile/pages/player_tab.dart';


class MusicPlayer extends StatefulWidget {
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> with SingleTickerProviderStateMixin{
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

@override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: PreferredSize(
        
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.grey,
          shadowColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_drop_down_circle),
            onPressed: () {
              Navigator.pop(context);
            },

          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.label,
            isScrollable: true,
            labelColor: Colors.red,
            unselectedLabelColor: Colors.white,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.circle,
                  size: 12),
              ),
              Tab(icon: Icon(Icons.circle,
                size: 12),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            PlayerTab(),
            NowPlayingTab(),
          ]
      ),
    );
  }



}
