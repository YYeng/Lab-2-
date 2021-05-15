import 'package:cv_battey/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'MyDrawer.dart';

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
                                    fit: BoxFit.cover,
                                    child: InkWell(
                                      splashColor: Colors.blue.withAlpha(30),
                                      onTap: () {
                                        // print('Card tapped.');
                                        //go to another screen
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
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 18, 10, 10),
                              height: 300,
                              width: 200,
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
                                      fit: BoxFit.cover,
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
                              padding: EdgeInsets.fromLTRB(10, 18, 10, 10),
                              height: 300,
                              width: 200,
                              child: Card(
                                elevation: 8,
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Stack(
                                  children: [
                                    // Ink.image(
                                    //   image: AssetImage(
                                    //     '',
                                    //   ),
                                    //   fit: BoxFit.cover,
                                    //  child:
                                    InkWell(
                                      splashColor: Colors.blue.withAlpha(30),
                                      onTap: () {
                                        // print('Card tapped.');
                                        //go to another screen
                                      },
                                    ),
                                    //  ),
                                    Positioned(
                                      bottom: 16,
                                      right: 16,
                                      left: 16,
                                      child: Text("Rating",
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
                      ),
                    ]),
              ),
            )));
  }

  Future<bool> _onBackPressed() {
    Navigator.pop(context, true);
    return Future.value(false);
  }
}
