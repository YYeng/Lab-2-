import 'dart:convert';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cv_battey/model/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../config.dart';
import 'MyDrawer.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';

class Profile extends StatefulWidget {
  final User user;

  const Profile({Key key, this.user}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File _image;
  ProgressDialog pr;
  String _name;
  String _phone = "Set Now";
  String _address = "Set Now";
  String pathAsset = 'asset/images/profilePic.png';
  SharedPreferences prefs;
  double screenHeight, screenWidth;
  List profile = [];

  TextEditingController phoneNumCtrl = new TextEditingController();
  TextEditingController addressCtrl = new TextEditingController();
  TextEditingController oldPwdCtrl = new TextEditingController();
  TextEditingController newPwdCtrl = new TextEditingController();
  TextEditingController confirmPwdCtrl = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUpdate();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    _name = widget.user.name;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
          ),
          elevation: 10,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[Colors.blue[300], Colors.blue[700]])),
          ),
        ),
        drawer: MyDrawer(user: widget.user),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: 150.0,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 20.0,
                        ),
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () => {_chooseImage()},
                              child: Container(
                                height: 120.0,
                                width: 120.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60.0),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 3.0,
                                        offset: Offset(0, 4.0),
                                        color: Colors.black38),
                                  ],
                                  image: DecorationImage(
                                    image: _image == null
                                        ? AssetImage(pathAsset)
                                        : FileImage(_image),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                left: 13,
                                child: Container(
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                        width: 1,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                      color: Colors.lightBlue,
                                    ),
                                    child: Text("Tap to change")))
                          ],
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 30.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.account_circle_sharp),
                              title: Text("Name"),
                              subtitle: Text(_name),
                            ),
                            Divider(
                              height: 10.0,
                              color: Colors.grey,
                            ),
                            ListTile(
                              leading: Icon(Icons.email),
                              title: Text("Email Address"),
                              subtitle: Text(widget.user.email),
                            ),
                            Divider(
                              height: 10.0,
                              color: Colors.grey,
                            ),
                            ListTile(
                              leading: Icon(Icons.phone),
                              title: Text("Phone Number"),
                              subtitle: Text(_phone),
                              trailing: IconButton(
                                icon: Icon(Icons.arrow_forward_ios_sharp),
                                onPressed: () async {
                                  updatePhoneDialog();
                                },
                              ),
                            ),
                            Divider(
                              height: 10.0,
                              color: Colors.grey,
                            ),
                            ListTile(
                              leading: Icon(Icons.location_on),
                              title: Text("Address"),
                              subtitle: Text(_address),
                              trailing: IconButton(
                                icon: Icon(Icons.arrow_forward_ios_sharp),
                                onPressed: () async {
                                  updateAddressDialog();
                                },
                              ),
                            ),
                            Divider(
                              height: 3.0,
                              color: Colors.grey,
                            ),
                          ],
                        ))),
                SizedBox(
                  height: 10.0,
                ),
                Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.edit_attributes),
                              title: Text("Change Password",
                                  style: TextStyle(fontSize: 18)),
                              trailing: IconButton(
                                  onPressed: () => {updatePwdDialog()},
                                  icon: Icon(Icons.edit)),
                            ),
                          ],
                        ))),
              ],
            ),
          ),
        ));
  }

  _chooseImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }

    String base64Image = base64Encode(_image.readAsBytesSync());
    http.post(Uri.parse(CONFIG.SERVER + '/cvbattery/php/insert_image.php'),
        body: {
          "email": widget.user.email,
          "encoded_string": base64Image
        }).then((response) {
      print(response.body);

      setState(() {});
    });
  }

  Future<void> updatePhoneDialog() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: new Text("Update Phone Number"),
              content: new Container(
                  child: Row(
                children: [
                  Flexible(
                      flex: 9,
                      child: TextField(
                        controller: phoneNumCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                          ),
                          labelText: 'Phone Number',
                        ),
                      )),
                  Flexible(
                    flex: 1,
                    child: IconButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          _phone = phoneNumCtrl.text;

                          prefs = await SharedPreferences.getInstance();
                          await prefs.setString("phone", _phone);

                          setState(() {
                            loadPhoneNo(_phone);
                          });
                        },
                        icon: Icon(Icons.check)),
                  )
                ],
              )));
        });
  }

  loadPhoneNo(String phoneNo) async {
    print(phoneNo);
    print(widget.user.email);

    http.post(Uri.parse(CONFIG.SERVER + '/cvbattery/php/update_profile.php'),
        body: {
          "phoneNo": phoneNo,
          "email": widget.user.email
        }).then((response) {
      print(response.body);
      if (response.body == "Failed") {
        Fluttertoast.showToast(
            msg: " Update Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Update Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  Future<void> updateAddressDialog() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: new Text("Update Address"),
              content: new Container(
                  height: screenHeight / 3.5,
                  child: Column(
                    children: [
                      TextField(
                        controller: addressCtrl,
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            labelText: 'Address'),
                        keyboardType: TextInputType.multiline,
                        minLines: 6,
                        maxLines: 6,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: ElevatedButton(
                              child: Text("Location"),
                              onPressed: () {
                                _getUserCurrentLoc();
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 4,
                            child: ElevatedButton(
                              child: Text("Confirm"),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                _address = addressCtrl.text;

                                prefs = await SharedPreferences.getInstance();
                                await prefs.setString("address", _address);

                                setState(() {
                                  loadAddress(_address);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  )));
        });
  }

  void loadAddress(String address) {
    print(widget.user.email);
    print(address);

    http.post(Uri.parse(CONFIG.SERVER + '/cvbattery/php/update_profile.php'),
        body: {
          "address": address,
          "email": widget.user.email
        }).then((response) {
      print(response.body);
      if (response.body == "Failed") {
        Fluttertoast.showToast(
            msg: "Update Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Update Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  updatePwdDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: new Text("Change Password"),
              content: Container(
                height: screenHeight / 2,
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.all(15),
                        alignment: Alignment.centerLeft,
                        child: Text("Old Password")),
                    Flexible(
                        flex: 9,
                        child: TextField(
                          controller: oldPwdCtrl,
                          decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              labelText: 'Old Password'),
                        )),
                    Container(
                        padding: EdgeInsets.all(15),
                        alignment: Alignment.centerLeft,
                        child: Text("New Password")),
                    Flexible(
                        flex: 9,
                        child: TextField(
                          controller: newPwdCtrl,
                          decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              labelText: 'New Password'),
                        )),
                    Container(
                        padding: EdgeInsets.all(15),
                        alignment: Alignment.centerLeft,
                        child: Text("Confirm Password")),
                    Flexible(
                        flex: 9,
                        child: TextField(
                          controller: confirmPwdCtrl,
                          decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              labelText: 'Confirm Password'),
                        )),
                    TextButton(
                        child: Text("Update", style: TextStyle(fontSize: 18)),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _changePwd();
                        }),
                  ],
                ),
              ));
        });
  }

  void _changePwd() async {
    String oldPwd = oldPwdCtrl.text.toString();
    String newPwd = newPwdCtrl.text.toString();
    String confirmPwd = confirmPwdCtrl.text.toString();

    if (newPwd != confirmPwd) {
      Fluttertoast.showToast(
          msg: "New Password and Confirm Password Does Not match",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      http.post(Uri.parse(CONFIG.SERVER + '/cvbattery/php/change_password.php'),
          body: {
            "email": widget.user.email,
            "oldPwd": oldPwd,
            "newPwd": newPwd,
          }).then((response) {
        print(response.body);
        if (response.body == "Success") {
          Fluttertoast.showToast(
              msg: "Update Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: "Update Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
    }
  }

  Future<void> _loadUpdate() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      _phone = prefs.getString("phone") ?? 'Set now';
      _address = prefs.getString("address") ?? 'Set now';
    });
  }

  Future<void> _getUserCurrentLoc() async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: Text("Searching address"), title: Text("Locating..."));
    progressDialog.show();
    await _determinePosition().then((value) => {_getPlace(value)});
    await Future.delayed(Duration(seconds: 5));
    setState(
      () {},
    );
    progressDialog.dismiss();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _getPlace(Position position) async {
    List<Placemark> newPlace =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark placeMark = newPlace[0];
    String name = placeMark.name.toString();
    String subLocality = placeMark.subLocality.toString();
    String locality = placeMark.locality.toString();
    String administrativeArea = placeMark.administrativeArea.toString();
    String postalCode = placeMark.postalCode.toString();
    String country = placeMark.country.toString();

    _address = name +
        "," +
        subLocality +
        ",\n" +
        locality +
        "," +
        postalCode +
        ",\n" +
        administrativeArea +
        "," +
        country;

    addressCtrl.text = _address;
  }
}
