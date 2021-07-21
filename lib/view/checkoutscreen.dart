import 'package:cv_battey/model/delivery.dart';
import 'package:cv_battey/model/user.dart';
import 'package:cv_battey/view/payment.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'package:http/http.dart' as http;
import '../config.dart';
import 'mappage.dart';
import 'myPurchase.dart';

class CheckOutPage extends StatefulWidget {
  final double total;
  final User user;

  const CheckOutPage({Key key, this.user, this.total}) : super(key: key);

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  String _curtime = "";
  String _name = "Click to set";
  String _phone = "Click to set";
  String address = "";
  String _selectedtime = "09:00 A.M";

  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController userlocctrl = new TextEditingController();

  double screenHeight, screenWidth;
  DateTime selectedDate;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    final now = new DateTime.now();
    _curtime = DateFormat("Hm").format(now);
    int cm = _convMin(_curtime);
    _selectedtime = _minToTime(cm);
    _loadPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Check Out'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Colors.blue[300], Colors.blue[700]])),
        ),
      ),
      body: Column(children: [
        Expanded(
            child: ListView(
          children: [
            Container(
                margin: EdgeInsets.all(2),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text(
                        "CUSTOMER DETAILS",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(flex: 1, child: Icon(Icons.email)),
                          Expanded(
                              flex: 3,
                              child: Text(
                                "Email:",
                                style: TextStyle(fontSize: 14),
                              )),
                          Container(
                              height: 20,
                              child: VerticalDivider(color: Colors.grey)),
                          Expanded(
                            flex: 6,
                            child: Text(widget.user.email,
                                style: TextStyle(fontSize: 15)),
                          )
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                              flex: 1, child: Icon(Icons.account_circle_sharp)),
                          Expanded(
                              flex: 3,
                              child: Text("Name:",
                                  style: TextStyle(fontSize: 14))),
                          Container(
                              height: 20,
                              child: VerticalDivider(color: Colors.grey)),
                          Expanded(
                            flex: 6,
                            child: GestureDetector(
                                child:
                                    Text(_name, style: TextStyle(fontSize: 14)),
                                onTap: () {
                                  nameDialog();
                                }),
                          )
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(flex: 1, child: Icon(Icons.phone)),
                          Expanded(
                              flex: 3,
                              child: Text("Phone Number:",
                                  style: TextStyle(fontSize: 14))),
                          Container(
                              height: 20,
                              child: VerticalDivider(color: Colors.grey)),
                          Expanded(
                              flex: 6,
                              child: GestureDetector(
                                  child: Text(_phone,
                                      style: TextStyle(fontSize: 14)),
                                  onTap: () {
                                    phoneDialog();
                                  }))
                        ],
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      Container(
                          child: Text("Delivery Address",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold))),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                              flex: 6,
                              child: TextField(
                                controller: userlocctrl,
                                style: TextStyle(fontSize: 14),
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Search/Enter address'),
                                keyboardType: TextInputType.multiline,
                                minLines:
                                    4, //Normal textInputField will be displayed
                                maxLines: 4, // when user presses enter it will
                              )),
                          Expanded(
                            flex: 4,
                            child: Column(children: [
                              Container(
                                width: 100,
                                child: ElevatedButton(
                                    child: Text("Location"),
                                    onPressed: () => {_getUserCurrentLoc()}),
                              ),
                              Container(
                                width: 100,
                                child: ElevatedButton(
                                  child: Text("Map"),
                                  onPressed: () async {
                                    Delivery _del =
                                        await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => MapPage(),
                                      ),
                                    );
                                    print(address);
                                    setState(() {
                                      userlocctrl.text = _del.address;
                                    });
                                  },
                                ),
                              )
                            ]),
                          )
                        ],
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      Container(
                        child: Text(
                          "Set Preference Delivery Date and Time",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        child: Text(
                          "Delivery time from  9.00 A.M to\n 9.00 P.M from our store",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child: Text("Date:",
                                  style: TextStyle(fontSize: 14))),
                          Container(
                              height: 20,
                              child: VerticalDivider(color: Colors.grey)),
                          Expanded(
                            flex: 7,
                            child: Row(children: [
                              Text(
                                getText(),
                              ),
                              Container(
                                  child: IconButton(
                                      iconSize: 30,
                                      icon: Icon(Icons.calendar_today),
                                      onPressed: () => pickDate(context)))
                            ]),
                          )
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child: Text("Delivery Time:",
                                  style: TextStyle(fontSize: 14))),
                          Container(
                              height: 20,
                              child: VerticalDivider(color: Colors.grey)),
                          Expanded(
                            flex: 7,
                            child: Row(children: [
                              Text(_selectedtime,
                                  style: TextStyle(fontSize: 14)),
                              Container(
                                  child: IconButton(
                                      iconSize: 30,
                                      icon: Icon(Icons.timer),
                                      onPressed: () => {_selecttime(context)}))
                            ]),
                          ),
                        ],
                      ),
                    ],
                  ), //Column
                )),
          ],
        ) //ListView
            ),
        Container(
          child: Row(
            children: [
              Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text("Total Payment:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("RM" + widget.total.toStringAsFixed(2),
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red)),
                      ],
                    ),
                  )),
              Expanded(
                flex: 4,
                child: ElevatedButton(
                    child: Text("Process with Payment",
                        style: TextStyle(fontSize: 20)),
                    onPressed: () {
                      payNowDialog();
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red[400],
                        padding: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10))),
              )
            ],
          ),
        ),
      ]),
    );
  }

  int _convMin(String c) {
    var val = c.split(":");
    int h = int.parse(val[0]);
    int m = int.parse(val[1]);
    int tmin = (h * 60) + m;
    return tmin;
  }

  String _minToTime(int min) {
    var m = min + 30;
    var d = Duration(minutes: m);
    List<String> parts = d.toString().split(':');
    String tm = '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    return DateFormat.jm().format(DateFormat("hh:mm").parse(tm));
  }

  _selecttime(BuildContext context) async {
    TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
    final now = new DateTime.now();
    print("NOW: " + now.toString());
    String year = DateFormat('y').format(now);
    String month = DateFormat('M').format(now);
    String day = DateFormat('d').format(now);
    String _hour, _minute, _time = "";

    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ':' + _minute;
        _selectedtime = _time;
        _curtime = DateFormat("Hm").format(now);

        _selectedtime = formatDate(
            DateTime(int.parse(year), int.parse(month), int.parse(day),
                selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
        int ct = _convMin(_curtime);
        int st = _convMin(_time);
        int diff = st - ct;
        if (diff < 30) {
          Fluttertoast.showToast(
              msg: "Invalid time selection",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          _selectedtime = _minToTime(ct);
          setState(() {});
          return;
        }
      });
  }

  void nameDialog() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: new Text(
          'Name',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        content: new Container(
            child: Row(
          children: [
            Flexible(
                flex: 9,
                child: TextField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                      ),
                      hintText: 'Enter Name'),
                )),
            TextButton(
              child: Text("Ok"),
              onPressed: () async {
                Navigator.of(context).pop();
                _name = nameController.text;

                prefs = await SharedPreferences.getInstance();
                await prefs.setString("name", _name);

                setState(() {});
              },
            ),
          ],
        )),
      ),
    );
  }

  void phoneDialog() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: new Text(
          'Phone Number',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        content: new Container(
            child: Row(
          children: [
            Flexible(
                flex: 9,
                child: TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                      ),
                      hintText: 'Enter Phone Number'),
                )),
            TextButton(
              child: Text("Ok"),
              onPressed: () async {
                Navigator.of(context).pop();
                _phone = phoneController.text;

                prefs = await SharedPreferences.getInstance();
                await prefs.setString("phone", _phone);

                setState(() {
                  http.post(
                      Uri.parse(
                          CONFIG.SERVER + '/cvbattery/php/update_profile.php'),
                      body: {
                        "phoneNo": _phone,
                        "email": widget.user.email
                      });
                });
              },
            ),
          ],
        )),
      ),
    );
  }

  Future<void> _loadPref() async {
    prefs = await SharedPreferences.getInstance();
    _name = prefs.getString("name") ?? widget.user.name;
    _phone = prefs.getString("phone") ?? widget.user.phone;
    setState(() {});
  }

  _getUserCurrentLoc() async {
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

    address = name +
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

    userlocctrl.text = address;
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

  String getText() {
    if (selectedDate == null) {
      return 'Select Date';
    } else {
      return DateFormat('dd/MM/yyyy').format(selectedDate);
    }
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? initialDate,
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year + 3));

    if (newDate == null) return;

    setState(() => selectedDate = newDate);
  }

  void payNowDialog() {
    showDialog(
        builder: (context) => new AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: new Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Payment Option",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        )),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                            child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          minWidth: 100,
                          height: 100,
                          child: Text('Cash on Delivery',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                          color: Theme.of(context).accentColor,
                          elevation: 10,
                          onPressed: () => {
                            Navigator.pop(context),
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MyPurchases(
                                  // user: widget.user,
                                  // total: widget.total,
                                  // time: _selectedtime,
                                  // date: selectedDate
                                  ), //pass user info
                            ))
                          },
                        )),
                        SizedBox(width: 10),
                        Flexible(
                            child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          minWidth: 100,
                          height: 100,
                          child: Text('Online Banking',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                          color: Theme.of(context).accentColor,
                          elevation: 10,
                          onPressed: () async => {
                            Navigator.pop(context),
                            await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PayScreen(
                                  user: widget.user,
                                  total: widget.total,
                                  time: _selectedtime,
                                  date: selectedDate),
                            ))
                          },
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        context: context);
  }
}
