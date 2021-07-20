import 'package:cv_battey/model/user.dart';
import 'package:flutter/material.dart';

class MyPurchases extends StatefulWidget {
  final User user;

  const MyPurchases({Key key, this.user}) : super(key: key);
  @override
  _MyPurchasesState createState() => _MyPurchasesState();
}

class _MyPurchasesState extends State<MyPurchases> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Purchase'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Colors.blue[300], Colors.blue[700]])),
        ),
      ),
      body: Center(
        child: Container(
          child: Text('Purchase history '),
        ),
      ),
    );
  }
}
