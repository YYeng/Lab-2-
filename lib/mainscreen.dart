import 'package:cv_battey/user.dart';
import 'package:flutter/material.dart';

void main() => runApp(MainScreen());

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainSrceenState createState() => _MainSrceenState();
}

class _MainSrceenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CV Battery'),
      ),
      body: Center(
        child: Column(children: [
          Text('Hello,' + widget.user.name),
        ]),
      ),
    );
  }
}
