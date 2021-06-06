import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imusic_mobile/pages/music_by_language.dart';
import 'package:imusic_mobile/services/auth.dart';
import 'package:provider/provider.dart';

class SideDrawer extends StatelessWidget {
  SideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(child: Consumer<Auth>(builder: (context, auth, child) {
      return ListView(
        children: [
          auth.authenticated ? _buildDrawerHeader() : SizedBox(),
          ListTile(
            title: Text(
              'Account',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          auth.authenticated
              ? Column(
                  children: [
                    ListTile(
                      title: Text('Playlists'),
                      leading: Icon(Icons.playlist_play),
                      onTap: () {
                        Navigator.of(context).pushNamed('/playlist');
                      },
                    ),
                    ListTile(
                      title: Text('Listen Histories'),
                      leading: Icon(Icons.history),
                      onTap: () {
                        Navigator.of(context).pushNamed('/histories');
                      },
                    ),
                    ListTile(
                      title: Text('Logout'),
                      leading: Icon(Icons.logout),
                      onTap: () {
                        Provider.of<Auth>(context, listen: false).logout();
                      },
                    ),
                  ],
                )
              : Column(
                  children: [
                    ListTile(
                      title: Text('Login'),
                      leading: Icon(Icons.login_rounded),
                      onTap: () async {
                        // await Navigator.push(
                        //   context,
                        //     MaterialPageRoute(builder: (context) => LoginScreen())
                        // );
                        Navigator.of(context).pushNamed('/login');
                      },
                    ),
                    ListTile(
                      title: Text('Register'),
                      leading: Icon(Icons.login_rounded),
                      onTap: () {
                        Navigator.of(context).pushNamed('/register');
                      },
                    ),
                  ],
                ),
          ListTile(
            title: Text(
              'Music Lists',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          ListTile(
              title: Text('Vietnamese'),
              leading: Icon(Icons.music_note),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MusicByLanguagePage(
                            languageName: 'Vietnamese', languageId: 1)));
              }),
          ListTile(
              title: Text('US - UK'),
              leading: Icon(Icons.music_note),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MusicByLanguagePage(
                            languageName: 'US-UK', languageId: 2)));
              }),
          ListTile(
              title: Text('Japanese'),
              leading: Icon(Icons.music_note),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MusicByLanguagePage(
                            languageName: 'Japanese', languageId: 4)));
              }),
          ListTile(
              title: Text('Chinese'),
              leading: Icon(Icons.music_note),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MusicByLanguagePage(
                            languageName: 'Chinese', languageId: 3)));
              }),
          ListTile(
              title: Text('Korean'),
              leading: Icon(Icons.music_note),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MusicByLanguagePage(
                            languageName: 'Korean', languageId: 6)));
              }),
          ListTile(
              title: Text('French'),
              leading: Icon(Icons.music_note),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MusicByLanguagePage(
                            languageName: 'French', languageId: 5)));
              }),
          ListTile(
              title: Text('Russian'),
              leading: Icon(Icons.music_note),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MusicByLanguagePage(
                            languageName: 'Russian', languageId: 7)));
              }),
          ListTile(
              title: Text('Others'),
              leading: Icon(Icons.music_note),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MusicByLanguagePage(
                            languageName: 'Others', languageId: 8)));
              }),
        ],
      );
    }));
  }
}

class _buildDrawerHeader extends StatelessWidget {
  const _buildDrawerHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(builder: (context, auth, child) {
      return DrawerHeader(
        child: Column(
          children: [
            CircleAvatar(
              // backgroundColor: Colors.white,
              backgroundImage: NetworkImage(auth.user!.avatar),
              radius: 30,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              ' ${auth.user!.name} (${auth.user!.role})',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              auth.user!.email,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
      );
    });
  }
}
