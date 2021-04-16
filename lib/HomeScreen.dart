import 'package:flutter/material.dart';
import 'package:imusic_mobile/pages/genre_tab.dart';
import 'package:imusic_mobile/pages/home_tab.dart';
import 'package:imusic_mobile/pages/new_songs_tab.dart';
import 'SideDrawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Trang Chủ'),
    Tab(text: 'Thể loại'),
    Tab(text: 'Bài hát mới'),
  ];

  late TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: myTabs.length);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        // leading: IconButton(
        //   icon: Icon(Icons.menu),
        //   onPressed: ,
        // ),
        title: Text("iMusic"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          tabs: myTabs,
          controller: _tabController,
        ),
      ),
      key: scaffoldKey,
      drawer: SideDrawer(),
      body:
          SafeArea(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                HomeTab(),
                GenreTab(),
                NewSongsTab(),
        ]
      ),
          ),
    );
  }

  onPressed() {}
}
