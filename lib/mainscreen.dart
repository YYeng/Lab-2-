import 'package:flutter/material.dart';
 
void main() => runApp(MainScreen());
 
class MainScreen extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('CV Battery'),
        ),
        body: Center(
          child: Container(
            child: Text('Book your baterry'),
          ),
        ),
      
    );
  }
}