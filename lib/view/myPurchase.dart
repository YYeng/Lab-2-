import 'package:cv_battey/model/user.dart';
import 'package:flutter/material.dart';


class MyPurchases extends StatefulWidget {
  final User user;
  final DateTime date;
  final String time;
  final double total;

  const MyPurchases({Key key, this.user, this.date, this.time, this.total})
      : super(key: key);
  @override
  _MyPurchasesState createState() => _MyPurchasesState();
}

@override
void initState() {
  initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {});
}

class _MyPurchasesState extends State<MyPurchases> {
  String _titlecenter = "Purchase item(s) history";
  List _purchaseList = [];
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
          child: Column(children: [
            if (_purchaseList.isEmpty)
              Flexible(child: Center(child: Text(_titlecenter)))
          ]),
        ),
      ),
    );
  }
}
