import 'dart:async';

import 'package:flutter/material.dart';

import 'loginscreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (content) => LoginScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[100],
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xA28ABBDB),
                    Color(0x8F5492AF),
                    Color(0xDC249ED6),
                    Color(0xFF009BE2),
                  ]),
                  
                ),
                child: Image.asset('asset/images/CVbattery.png'),
              ))
        ]));
  }
}
