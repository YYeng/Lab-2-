import 'dart:convert';
import 'package:cv_battey/model/user.dart';
import 'package:cv_battey/view/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../config.dart';
import 'package:http/http.dart' as http;

class Booking extends StatefulWidget {
  final User user;

  const Booking({Key key, this.user}) : super(key: key);

  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  double screenHeight, screenWidth;
  TextEditingController _searchCtrl = new TextEditingController();
  List _productList = [];
  String _titlecenter = "Loading...";
  int cartItem = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _testasync();
      _loadCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Book Your Battery'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Colors.blue[300], Colors.blue[700]])),
        ),
        //go back to main screen
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton.icon(
              label: Text(cartItem.toString(),
                  style: TextStyle(color: Colors.white)),
              icon: Icon(Icons.shopping_cart_outlined, color: Colors.white),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => CartScreen(user: widget.user)));

                _loadProduct("all");
              })
        ],
      ),
      body: Center(
        child: Column(children: [
          //search section
          Container(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        child: TextFormField(
                          controller: _searchCtrl,
                          decoration: InputDecoration(
                            hintText: 'Search battery/vehicle model',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                          ),
                        ),
                      ),
                      Container(
                          width: screenWidth,
                          child: ElevatedButton(
                            onPressed: () => _loadProduct(
                              _searchCtrl.text,
                            ),
                            child:
                                Text("Search", style: TextStyle(fontSize: 18)),
                          ))
                    ],
                  ))),

          //display products list section
          if (_productList.isEmpty)
            Flexible(child: Center(child: Text(_titlecenter)))
          else
            Flexible(child: OrientationBuilder(builder: (context, orientation) {
              return StaggeredGridView.countBuilder(
                  padding: EdgeInsets.all(10),
                  crossAxisCount: orientation == Orientation.portrait ? 1 : 3,
                  itemCount: _productList.length,
                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Column(
                      children: [
                        Container(
                          child: Card(
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height:
                                          orientation == Orientation.portrait
                                              ? 100
                                              : 130,
                                      width: orientation == Orientation.portrait
                                          ? 100
                                          : 130,
                                      child: Image.network(
                                        CONFIG.SERVER +
                                            _productList[index]['picture'],
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Text(_productList[index]['name_battery'],
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        "Vehicle Model: " +
                                            _productList[index]['vehicle_type'],
                                        style: TextStyle(fontSize: 15)),
                                    Text(
                                        "Warranty months: " +
                                            _productList[index]
                                                ['warranty_months'],
                                        style: TextStyle(fontSize: 15)),
                                    Text(
                                      "RM " +
                                          double.parse(
                                                  _productList[index]['price'])
                                              .toStringAsFixed(2),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.redAccent),
                                    ),
                                    Container(
                                        child: ElevatedButton(
                                      onPressed: () => {addtocart(index)},
                                      child: Text("Add to Cart",
                                          style: TextStyle(fontSize: 18)),
                                    ))
                                  ],
                                ),
                              )),
                        ),
                      ],
                    );
                  });
            })),
        ]),
      ),
    );
  }

  Future _loadProduct(String searchValue) async {
    http.post(Uri.parse(CONFIG.SERVER + "/cvbattery/php/load_products.php"),
        body: {
          "searchValue": searchValue,
        }).then((response) {
      print(response.body);
      if (response.body == "nodata") {
        _titlecenter = "No product";
        _productList = [];
        return;
      } else {
        var jsondata = json.decode(response.body);
        print(jsondata);
        _productList = jsondata["products"];
        _titlecenter = "";
      }
      setState(() {});
    });
  }

  Future<void> _testasync() async {
    _loadProduct("all");
  }

  addtocart(int index) async {
    String batteryid = _productList[index]['battery_id'];

    http.post(Uri.parse(CONFIG.SERVER + "/cvbattery/php/insertcart.php"),
        body: {
          "email": widget.user.email,
          "batteryid": batteryid
        }).then((response) {
      print(response.body);
      if (response.body == "failed") {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        _loadCart();
      }
    });
  }

  void _loadCart() {
    http.post(Uri.parse(CONFIG.SERVER + "/cvbattery/php/loadcartitem.php"),
        body: {
          "email": widget.user.email,
        }).then((response) {
      setState(() {
        cartItem = int.tryParse(response.body);
        print(cartItem);
      });
    });
  }
}
