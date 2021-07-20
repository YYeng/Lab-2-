import 'package:cv_battey/model/user.dart';
import 'package:cv_battey/view/profile.dart';
import 'package:flutter/material.dart';
import 'mainscreen.dart';
import 'myPurchase.dart';

class MyDrawer extends StatefulWidget {
  final User user;

  const MyDrawer({Key key, this.user}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
String pathAsset = 'asset/images/profilePic.png';

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(children: [
      UserAccountsDrawerHeader(
        accountName: Text(widget.user.name, style: TextStyle(fontSize: 20)),
        accountEmail: Text(widget.user.email),
        currentAccountPicture: CircleAvatar(
          backgroundImage: AssetImage(pathAsset),
        ),
      ),
      ListTile(
        title: Text('Dashboard'),
        onTap: () {
          // Update the state of the app.
          Navigator.pop(context);
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
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (content) => Profile(
                        user: widget.user,
                      )));
          // Update the state of the app.
          // ...
        },
      ),
      ListTile(
        title: Text('My Purchase'),
        onTap: () {
          Navigator.pop(context);
          // Update the state of the app.
           Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MyPurchases(user: widget.user), //pass user info
                            ));
        },
      ),
     
      ListTile(
        title: Text('Logout'),
        onTap: () {
          Navigator.pop(context);
          // Update the state of the app.
         
        },
      ),
    ]));
  }
}
