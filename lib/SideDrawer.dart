import 'package:flutter/material.dart';
import 'package:imusic_mobile/services/auth.dart';
import 'package:provider/provider.dart';

import 'Auth/login_screen.dart';

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(child: Consumer<Auth>(builder: (context, auth, child) {
      if (!auth.authenticated) {
        return ListView(
          children: [
            ListTile(
              title: Text('Login'),
              leading: Icon(Icons.login),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
          ],
        );
      } else {
        return ListView(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  CircleAvatar(
                    // backgroundColor: Colors.white,
                    backgroundImage:  NetworkImage(auth.user!.avatar),
                    radius: 30,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    ' ${auth.user!.name} (${auth.user!.role})' ,
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
            ),
            ListTile(
              title: Text('Logout'),
              leading: Icon(Icons.logout),
              onTap: () {
                Provider.of<Auth>(context, listen: false)
                    .logout();
              },
            ),
          ],
        );
      }
    }));
  }
}
