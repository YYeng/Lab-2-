import 'dart:convert';

import 'package:cv_battey/config.dart';
import 'package:cv_battey/model/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'checkoutscreen.dart';

class CartScreen extends StatefulWidget {
  final User user;

  const CartScreen({Key key, this.user}) : super(key: key);
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String _titlecenter = "Oops, Your Cart is Empty";
  List _cartList = [];
  double _total = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Colors.blue[300], Colors.blue[700]])),
        ),
      ),
      body: Center(
        child: Column(children: <Widget>[
          if (_cartList.isEmpty)
            Flexible(child: Center(child: Text(_titlecenter)))
          else
            Flexible(child: OrientationBuilder(builder: (context, orientation) {
              return GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: 3 / 1,
                  children: List.generate(_cartList.length, (index) {
                    return Padding(
                      padding: EdgeInsets.all(1),
                      child: Container(
                          child: Card(
                              child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              height: orientation == Orientation.portrait
                                  ? 100
                                  : 150,
                              width: orientation == Orientation.portrait
                                  ? 100
                                  : 150,
                              child: Image.network(
                                  CONFIG.SERVER + _cartList[index]['picture']),
                            ),
                          ),
                          Container(
                              height: 100,
                              child: VerticalDivider(color: Colors.grey)),
                          Expanded(
                              flex: 6,
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(_cartList[index]['name_battery'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(height: 5.0),
                                      Text(
                                          "RM" +
                                              (int.parse(_cartList[index]
                                                          ['cartqty']) *
                                                      double.parse(
                                                          _cartList[index]
                                                              ['price']))
                                                  .toStringAsFixed(2),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red)),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            IconButton(
                                                icon: Icon(Icons.remove),
                                                onPressed: () {
                                                  _updateQty(
                                                      index, "removecart");
                                                }),
                                            Text(_cartList[index]['cartqty']),
                                            IconButton(
                                                icon: Icon(Icons.add),
                                                onPressed: () {
                                                  _updateQty(index, "addcart");
                                                })
                                          ]),
                                    ],
                                  ))),
                          Expanded(
                              flex: 1,
                              child: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    _deleteCartDialog(index);
                                  }))
                        ],
                      ))),
                    );
                  }));
            })),
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
                          Text("RM" + _total.toStringAsFixed(2),
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
                      child:
                          Text("Place Order", style: TextStyle(fontSize: 20)),
                      onPressed: () {
                        _payDialog();
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.red[400],
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10))),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }

  _loadCart() {
    http.post(Uri.parse(CONFIG.SERVER + "/cvbattery/php/user_cart.php"), body: {
      "email": widget.user.email,
    }).then((response) {
      print(response.body);
      if (response.body == "nodata") {
        _titlecenter = "No item";
        _cartList = [];
        return;
      } else {
        var jsondata = json.decode(response.body);
        print(jsondata);
        _cartList = jsondata["cart"];

        _titlecenter = "";
        _total = 0.0;
        for (int i = 0; i < _cartList.length; i++) {
          _total = _total +
              double.parse(_cartList[i]['price']) *
                  int.parse(_cartList[i]['cartqty']);
        }
      }
      setState(() {});
    });
  }

  Future<void> _updateQty(int index, String s) async {
    http.post(Uri.parse(CONFIG.SERVER + "/cvbattery/php/update_cart.php"),
        body: {
          "email": widget.user.email,
          "op": s,
          "btryid": _cartList[index]['battery_id'],
          "qty": _cartList[index]['cartqty']
        }).then((response) {
      print(response.body);
      _loadCart();
    });
  }

  void _deleteCartDialog(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Do you want to delete this item from cart? "),
            actions: [
              TextButton(
                  child: Text("Yes"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _deleteCart(index);
                  }),
              TextButton(
                  child: Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  Future<void> _deleteCart(int index) async {
    http.post(Uri.parse(CONFIG.SERVER + "/cvbattery/php/deletecart.php"),
        body: {
          "email": widget.user.email,
          "btryid": _cartList[index]['battery_id']
        }).then((response) {
      print(response.body);
      _loadCart();
    });
  }

  void _payDialog() {
    if (_total == 0.0) {
      Fluttertoast.showToast(
          msg: "Amount not available",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text(
                  'Proceed with checkout?',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("Yes"),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CheckOutPage(
                            user: widget.user, total: _total),
                        ),
                      );
                    },
                  ),
                  TextButton(
                      child: Text("No"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ]);
          });
    }
  }
}
