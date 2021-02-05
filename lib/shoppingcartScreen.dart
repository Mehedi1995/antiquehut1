import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toast/toast.dart';
import 'bill.dart';

import 'user.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:intl/intl.dart';

class ShoppingCartScreen extends StatefulWidget {
  final User user;

  const ShoppingCartScreen({Key key, this.user}) : super(key: key);
  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  final TextEditingController _deladdcontroller = TextEditingController();
  List cartList;
  double screenHeight, screenWidth;
  String titlecenter = "Loading cart...";

  String id = "";
  String catagory = "";
  String qty = "";
  String name = "";
  String price = "";
  String shopid = "";
  double totalPrice = 0.0;
  double sizing = 11.5;
  int numcart = 0;
  double payable = 0.0;

  final formatter = new NumberFormat("#,##");

  String restName = "";

  bool _visible = false;

  double distance = 0.0;
  double restdel = 0.0;
  double delcharge = 5.0;

  @override
  void initState() {
    super.initState();
    _loadcart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: [
          cartList == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(
                  titlecenter,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ))))
              : Flexible(
                  child: GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: (screenWidth / screenHeight) / 0.2,
                  children: List.generate(cartList.length, (index) {
                    return Padding(
                        padding: EdgeInsets.all(1),
                        child: Card(
                            child: InkWell(
                          // onTap: () => _loadFoodDetails(index),
                          onLongPress: () => _deleteOrderDialog(index),
                          child: SingleChildScrollView(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    height: screenHeight / 6,
                                    width: screenWidth / 4,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "http://shabab-it.com/antiquehut/images/product_pic/${cartList[index]['image']}.jpg",
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          new CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          new Icon(
                                        Icons.broken_image,
                                        size: screenWidth / 2,
                                      ),
                                    )),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cartList[index]['name'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("RM " +
                                        cartList[index]['price'] +
                                        " x " +
                                        cartList[index]['qty'] +
                                        " set"),
                                    Text("Total RM " +
                                        (double.parse(
                                                    cartList[index]['price']) *
                                                int.parse(
                                                    cartList[index]['qty']))
                                            .toStringAsFixed(2))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )));
                  }),
                )),
          Container(
              decoration: new BoxDecoration(
                color: Colors.black,
              ),
              height: screenHeight / sizing,
              width: screenWidth / 0.4,
              child: Card(
                  elevation: 15,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          child: IconButton(
                            icon: _visible
                                ? new Icon(Icons.expand_more)
                                : new Icon(Icons.attach_money),
                            onPressed: () {
                              setState(() {
                                if (_visible) {
                                  _visible = false;
                                  sizing = 11.5;
                                } else {
                                  _visible = true;
                                  sizing = 2;
                                }
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "TOTAL ITEM/S",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("Delivery Address :  " + _deladdcontroller.text),

                        SizedBox(height: 5),
                        Text(widget.user.name +
                            ", there are " +
                            numcart.toString() +
                            " item/s in your cart"),
                        // Text("Total amount is RM " +
                        //     totalPrice.toStringAsFixed(2)),

                        SizedBox(height: 10),
                        Text(
                          "PAYMENT ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        Text("Delivery Charge RM 5 "),
                        Text("Product/s price RM:" +
                            totalPrice.toStringAsFixed(2)),
                        Text("Total amount payable RM " +
                            payable.toStringAsFixed(2)),
                        //SizedBox(height: 5),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          height: 30,
                          child: Text('Make Payment'),
                          color: Colors.black,
                          textColor: Colors.white,
                          elevation: 10,
                          onPressed: () => {
                            _makePaymentDialog(),
                          },
                        ),
                      ],
                    ),
                  ))),
        ],
      ),
    );
  }

  void _loadcart() {
    http.post("http://shabab-it.com/antiquehut/php/load_cart.php", body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        cartList = null;
        setState(() {
          titlecenter = "No Item Found";
        });
      } else {
        totalPrice = 0;
        numcart = 0;
        setState(() {
          var jsondata = json.decode(res.body);
          cartList = jsondata["cart"];
          for (int i = 0; i < cartList.length; i++) {
            totalPrice = totalPrice +
                double.parse(cartList[i]['price']) *
                    int.parse(cartList[i]['qty']);
            numcart = numcart + int.parse(cartList[i]['qty']);
            payable = totalPrice + delcharge;
          }

          id = cartList[0]['id'];
          catagory = (cartList[0]['catagory']);
          name = (cartList[0]['name']);
          qty = (cartList[0]['qty']);
         
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _deleteOrderDialog(int index) {
    print("Delete " + cartList[index]['name']);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Delete order " + cartList[index]['name'] + "?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are your sure? ",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                _deleteCart(index);
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteCart(int index) {
    http.post("http://shabab-it.com/antiquehut/php/deletechart.php", body: {
      "email": widget.user.email,
      "id": cartList[index]['id'],
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        _loadcart();
        Toast.show(
          "Delete Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      } else {
        Toast.show(
          "Delete failed!!!",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }).catchError((err) {
      print(err);
    });
  }

  _makePaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Proceed with payment?',
          style: TextStyle(
              //color: Colors.white,
              ),
        ),
        content: new Text(
          'Are you sure to pay RM ' + payable.toStringAsFixed(2) + "?",
          style: TextStyle(
              //color: Colors.white,
              ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                _makePayment();
              },
              child: Text(
                "Ok",
                style: TextStyle(
                    //color: Color.fromRGBO(101, 255, 218, 50),
                    ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                    //color: Color.fromRGBO(101, 255, 218, 50),
                    ),
              )),
        ],
      ),
    );
  }

  Future<void> _makePayment() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => BillScreen(
                  user: widget.user,
                  val: payable.toStringAsFixed(2),
                )));
    _loadcart();
  }
}
