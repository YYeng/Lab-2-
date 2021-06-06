import 'package:cv_battey/model/user.dart';
import 'package:cv_battey/view/booking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'MyDrawer.dart';

//import 'package:cv_battey/view/add_newproduct.dart';
class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainSrceenState createState() => _MainSrceenState();
}

class _MainSrceenState extends State<MainScreen> {


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Dashboard'),
            elevation: 20,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[Colors.blue[300], Colors.blue[700]])),
            ),
          ),
          drawer: MyDrawer(user: widget.user),
          body: Center(
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 400),
                  childAnimationBuilder: (widget) => SlideAnimation(
                        horizontalOffset: 50.0,
                        child: FadeInAnimation(
                          child: widget,
                        ),
                      ),
                  children: [
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: Row(children: [
                        Text("Welcome, " + widget.user.name + " !",
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.bold)),
                      ]),
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(10, 18, 10, 10),
                        height: 220,
                        width: double.maxFinite,
                        child: Card(
                          elevation: 8,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Ink.image(
                                  image: AssetImage(
                                    'asset/images/battery.png',
                                  ),
                                  fit: BoxFit.contain,
                                  child: InkWell(
                                    splashColor: Colors.blue.withAlpha(30),
                                    onTap: () async {
                                      //go to another screen
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (content) => Booking()
                                              ));
                                    },
                                  ),
                                ),
                                Text("Book Your Battery",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ],
                            ),
                          ),
                        )),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 18, 10, 10),
                          height: 300,
                          width: 195,
                          child: Card(
                            elevation: 8,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Stack(
                              children: [
                                Ink.image(
                                  image: AssetImage(
                                    'asset/images/purchase-order.png',
                                  ),
                                  fit: BoxFit.contain,
                                  child: InkWell(
                                    splashColor: Colors.blue.withAlpha(30),
                                    onTap: () {
                                      // print('Card tapped.');
                                      //go to another screen
                                    },
                                  ),
                                ),
                                Positioned(
                                  bottom: 16,
                                  right: 16,
                                  left: 16,
                                  child: Text("My Purchase",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(5, 18, 10, 10),
                          height: 300,
                          width: 195,
                          child: Card(
                            elevation: 8,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Stack(
                              children: [
                                Ink.image(
                                  image: AssetImage(
                                    'asset/images/contact-us.png',
                                  ),
                                  fit: BoxFit.contain,
                                  child: InkWell(
                                    splashColor: Colors.blue.withAlpha(30),
                                    onTap: () {
                                      // print('Card tapped.');
                                      //go to another screen
                                    },
                                  ),
                                ),
                                Positioned(
                                  bottom: 16,
                                  right: 20,
                                  left: 16,
                                  child: Text("Contact Us",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
          ),
        ));
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Do you want to exit this app?"),
              actions: <Widget>[
                TextButton(
                    child: Text("Yes"),
                    onPressed: () => Navigator.pop(context, true)),
                TextButton(
                  child: Text("No"),
                  onPressed: () => Navigator.pop(context, false),
                ),
              ],
            ));
  }
}
