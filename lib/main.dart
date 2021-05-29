
import 'package:cv_battey/view/booking.dart';
import 'package:cv_battey/view/loginscreen.dart';
import 'package:cv_battey/view/mainscreen.dart';
import 'package:cv_battey/view/signupscreen.dart';
import 'package:cv_battey/view/splashscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';



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
        
      },
      builder: (BuildContext context, Widget widget) {
        Widget error = Text('...rendering error...');
        if (widget is Scaffold || widget is Navigator)
          error = Scaffold(body: Center(child: error));
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) => error;
        return widget;
      },
      title: 'CV Battery App',
      home: SplashScreen(),
    );
  }
}
