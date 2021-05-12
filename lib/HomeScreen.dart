import 'package:flutter/material.dart';
import 'package:imusic_mobile/pages/genre_tab.dart';
import 'package:imusic_mobile/pages/home_tab.dart';
import 'package:imusic_mobile/pages/new_songs_tab.dart';
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

  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";

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
        leading: _isSearching ? const BackButton() : null,
        title: _isSearching ? _buildSearchField() : Text('iMusic'),
        centerTitle: true,
        actions: _buildActions(),
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

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: "Search for song...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.black38),
      ),
      style: TextStyle(color: Colors.black, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }
}
