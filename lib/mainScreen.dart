import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

import 'addProduct.dart';
import 'detailScreen.dart';
import 'product.dart';

import 'shoppingcartScreen.dart';
import 'user.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
 
 
  
  List productList;
  double screenHeight, screenWidth;
  String titlecenter = "Loading Product...";

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: mainDrawer(context),
      appBar: AppBar(
        title: Text('List of Product'),
       actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
           color: Colors.black,
           onPressed: () {
              _shoppingCart();
            },
          ),
        ],
      ),

     resizeToAvoidBottomPadding: false,
     body: Column(
        children: [
         productList == null
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
                  crossAxisCount: 2,
                 childAspectRatio: (screenWidth / screenHeight) / 1.2,
                  children: List.generate(productList.length, (index) {
                    return Padding(
                        padding: EdgeInsets.all(1),
                       child: Card(
                           child: InkWell(
                          onTap: () => _loadproductDetail(index),
                          child: SingleChildScrollView(
                            child: Column(
                              
                              children: [
                                Container(
                                    height: screenHeight / 3,
                                   width: screenWidth / 1,
                                    child: CachedNetworkImage(
                                     imageUrl:
                                         "http://shabab-it.com/antiquehut/images/product_pic/${productList[index]['image']}.jpg",
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          new CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          new Icon(
                                        Icons.broken_image,
                                        size: screenWidth / 2,
                                      ),
                                    )),
                                SizedBox(height: 5),
                                SizedBox(height: 5),
                                Text(
                                  'Product ID:  ' + productList[index]['id'],
                                  style: TextStyle(fontSize: 14),
                               ),
                                Text(
                                  'Product Name:   ' +
                                      productList[index]['name'],
                                  style: TextStyle(fontSize: 14),
                                ),
                               Text(
                                  'Shop ID:   ' + productList[index]['shopid'],
                                  style: TextStyle(fontSize: 14),
                                ),
                               Text(
                                  'Shop Name:   ' +
                                     productList[index]['shopname'],
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                           ),
                         ),
                        )));
                 }),
                ))
        ],
     ),
     
   );
  }

  Widget mainDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(widget.user.name),
            accountEmail: Text(widget.user.email),
            otherAccountsPictures: <Widget>[
            ],
            currentAccountPicture: CircleAvatar(
              backgroundColor:
                  Theme.of(context).platform == TargetPlatform.android
                      ? Colors.white
                      : Colors.white,
              child: Text(
                widget.user.name.toString().substring(0, 1).toUpperCase(),
                style: TextStyle(fontSize: 40.0),
              ),
              
            ),
            
          ),
          ListTile(
              title: Text(
                "Add Product",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                    Navigator.pop(context),
                   _incrementCounter()
                  }),
        ],
      ),
    );
  }

  void _incrementCounter() {
    setState(() {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => AddProduct()));
    });
  }

 // void _loadProduct() {
   Future<void> _loadProduct() async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading...");
    await pr.show();
    http.post("http://shabab-it.com/antiquehut/php/load_product.php",
        body: {}).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        productList = null;
        setState(() {
          titlecenter = "No Product Found";
        });
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          productList = jsondata["rest"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _loadproductDetail(int index) {
    Product product1 = new Product(
      shopid: productList[index]['shopid'],
      shopname: productList[index]['shopname'],
      productId: productList[index]['id'],
      catagory: productList[index]['catagory'],
      productname: productList[index]['name'],
      phone: productList[index]['phone'],
      quantity: productList[index]['quantity'],
      price: productList[index]['price'],
      location: productList[index]['location'],
      image: productList[index]['image'],
    );
    
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                DetailScreen(product: product1, user: widget.user)));
  }

  void _shoppingCart() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                ShoppingCartScreen(user: widget.user)));
  }
}
