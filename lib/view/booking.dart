import 'dart:convert';
import 'package:cv_battey/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../config.dart';
import 'package:http/http.dart' as http;

class Booking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BookService();
  }
}

class BookService extends StatefulWidget {
  final User user;

  const BookService({Key key, this.user}) : super(key: key);
  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<BookService> {
  double screenHeight, screenWidth;
  TextEditingController _searchCtrl = new TextEditingController();
  List _productList = [];
  String _titlecenter = "Loading...";
  GlobalKey<NavigatorState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _testasync();
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        if (_key.currentState.canPop()) {
          _key.currentState.pop();
          return false;
        }
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Book Your Battery'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: Column(children: [
            Container(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _searchCtrl,
                      decoration: InputDecoration(
                        hintText: 'Search battery/vehicle model',
                        suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () => _loadProduct(_searchCtrl.text)),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                      ),
                    ),
                  ],
                )),
            if (_productList.isEmpty)
              Flexible(child: Center(child: Text(_titlecenter)))
            else
              Flexible(
                  child: OrientationBuilder(builder: (context, orientation) {
                return StaggeredGridView.countBuilder(
                    padding: EdgeInsets.all(10),
                    crossAxisCount: 2,
                    itemCount: _productList.length,
                    staggeredTileBuilder: (int index) =>
                        new StaggeredTile.fit(1),
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
                                                : 150,
                                        width:
                                            orientation == Orientation.portrait
                                                ? 100
                                                : 150,
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
                                          "Vehicle Type: " +
                                              _productList[index]
                                                  ['vehicle_type'],
                                          style: TextStyle(fontSize: 15)),
                                      Text(
                                          "Warranty months: " +
                                              _productList[index]
                                                  ['warranty_months'],
                                          style: TextStyle(fontSize: 15)),
                                      Text(
                                          "RM " +
                                              double.parse(_productList[index]
                                                      ['price'])
                                                  .toStringAsFixed(2),
                                          style: TextStyle(fontSize: 15)),
                                      Container(
                                          child: ElevatedButton(
                                        onPressed: () => {},
                                        child: Text("Add to Cart"),
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
      ),
    );
  }

  _loadProduct(String namebattery) {
    http.post(Uri.parse(CONFIG.SERVER + "/cvbattery/php/load_products.php"),
        body: {"namebattery": namebattery}).then((response) {
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
}
