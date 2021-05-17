import 'package:cv_battey/user.dart';
import 'package:flutter/material.dart';

import 'mainscreen.dart';

class MyDrawer extends StatefulWidget {
  final User user;

  const MyDrawer({Key key, this.user}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(children: [
      UserAccountsDrawerHeader(
        accountName: Text(widget.user.name, style: TextStyle(fontSize: 20)),
        accountEmail: Text(widget.user.email),
        currentAccountPicture: CircleAvatar(
          backgroundImage: AssetImage('asset/images/profilePic.png'),
        ),
      ),
      ListTile(
        title: Text('Dashboard'),
        onTap: () {
          // Update the state of the app.
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (content) => MainScreen(
                        user: widget.user,
                      )));
        },
      ),
      ListTile(
        title: Text('My Profile'),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      ),
      ListTile(
        title: Text('My Purchase'),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      ),
      ListTile(
        title: Text('Rate Us'),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      ),
      ListTile(
        title: Text('Logout'),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      ),
    ]));
  }
}
