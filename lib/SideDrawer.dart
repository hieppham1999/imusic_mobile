import 'package:flutter/material.dart';
import 'package:imusic_mobile/services/auth.dart';
import 'package:provider/provider.dart';

import 'Auth/login_screen.dart';

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(child: Consumer<Auth>(builder: (context, auth, child) {
      return ListView(
        children: [
          auth.authenticated ? _buildDrawerHeader() : SizedBox(),
          auth.authenticated
              ? Column(
                  children: [
                    ListTile(
                      title: Text('Tài Khoản'),
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
                      title: Text('Tài Khoản'),
                    ),
                    ListTile(
                      title: Text('Đăng nhập'),
                      leading: Icon(Icons.login),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                      },
                    ),
                  ],
                ),
          ListTile(
            title: Text('Danh sách nhạc'),
          ),
          ListTile(
            title: Text('Nhạc Việt Nam'),
            leading: Icon(Icons.music_note),
          ),
          ListTile(
            title: Text('Nhạc US - UK'),
            leading: Icon(Icons.music_note),
          ),
          ListTile(
            title: Text('Nhạc Nhật Bản'),
            leading: Icon(Icons.music_note),
          ),
          ListTile(
            title: Text('Nhạc Trung Quốc'),
            leading: Icon(Icons.music_note),
          ),
          ListTile(
            title: Text('Nhạc Hàn Quốc'),
            leading: Icon(Icons.music_note),
          ),
          ListTile(
            title: Text('Nhạc Pháp'),
            leading: Icon(Icons.music_note),
          ),
          ListTile(
            title: Text('Nhạc Nga'),
            leading: Icon(Icons.music_note),
          ),
          ListTile(
            title: Text('Nhạc các nước khác'),
            leading: Icon(Icons.music_note),
          ),
        ],
      );
    })
    );
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
    }

    );
  }
}
