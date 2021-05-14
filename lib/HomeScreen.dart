import 'package:flutter/material.dart';
import 'package:imusic_mobile/pages/genre_tab.dart';
import 'package:imusic_mobile/pages/home_tab.dart';
import 'package:imusic_mobile/pages/new_songs_tab.dart';
import 'package:imusic_mobile/pages/search_page.dart';
import 'package:imusic_mobile/utils/user_secure_storage.dart';
import 'SideDrawer.dart';
import 'components/now_playing_bar.dart';
import 'package:provider/provider.dart';
import 'package:imusic_mobile/services/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Trang Chủ'),
    Tab(text: 'Thể loại'),
    Tab(text: 'Bài hát mới'),
  ];

  late TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: myTabs.length);
    readToken();
    super.initState();
  }

  void readToken() async {

    String? token = await UserSecureStorage.getToken();
    Provider.of<Auth>(context, listen: false).tryToken(token : token);
    print(token);
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
        titleSpacing: 0,
        backgroundColor: Theme.of(context).primaryColor,
        // leading: _isSearching ? const BackButton() : null,
        title: Text('iMusic'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SearchPage()));
                }
          )
        ],
        bottom: TabBar(
          tabs: myTabs,
          controller: _tabController,
        ),
      ),
      drawer: SideDrawer(),
      bottomNavigationBar: nowPlayingBar(context),
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
}
