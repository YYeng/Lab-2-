import 'package:cv_battey/view/mainscreen.dart';
import 'package:flutter/material.dart';

class Booking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BookService();
  }
}

class BookService extends StatefulWidget {
  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<BookService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(
                context, MaterialPageRoute(builder: (content) => MainScreen()));
          },
        ),
      ),
      body: Center(
        child: Container(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
