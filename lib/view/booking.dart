import 'package:cv_battey/view/mainscreen.dart';
import 'package:flutter/material.dart';

class Booking extends StatefulWidget {
  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacement(
            context, new MaterialPageRoute(builder: (context) => MainScreen()));
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Select Model'),
        ),
        body: Center(
          child: Container(
            child: Text('Select your vehicle model'),
          ),
        ),
      ),
    );
  }
}
