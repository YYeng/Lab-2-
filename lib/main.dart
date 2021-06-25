import 'package:cv_battey/view/booking.dart';
import 'package:cv_battey/view/cart.dart';
import 'package:cv_battey/view/loginscreen.dart';
import 'package:cv_battey/view/mainscreen.dart';
import 'package:cv_battey/view/profile.dart';
import 'package:cv_battey/view/signupscreen.dart';
import 'package:cv_battey/view/splashscreen.dart';

import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       routes: <String, WidgetBuilder>{
        '/loginscreen': (BuildContext context) => new LoginScreen(),
        '/signupscreen': (BuildContext context) => new SignUpScreen(),
        '/mainscreen': (BuildContext context) => new MainScreen(),
        '/booking': (BuildContext context) => new Booking(),
        '/profile':(BuildContext context) => new Profile(),
        '/cart': (BuildContext context) => new CartScreen()
      },
     
      title: 'CV Battery App',
      home: SplashScreen(),

    );
  }
}
