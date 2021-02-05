import 'package:antiquehut/product.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'user.dart';



class DetailScreen extends StatefulWidget {
  final User user;
  final Product product;

  const DetailScreen({Key key, this.product, this.user}) : super(key: key);
  @override
  _DetailScreenState createState() => _DetailScreenState();
}


  


class _DetailScreenState extends State<DetailScreen> {
  double screenHeight, screenWidth;
   int selectediteam = 1;

  @override
  Widget build(BuildContext context) {
     var productQty =
        Iterable<int>.generate(int.parse(widget.product.quantity) + 1).toList();
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.product.productname),
        ),
        resizeToAvoidBottomPadding: false,
        body: Center(
            child: Container(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: screenHeight / 3,
                  width: screenWidth / 1,
                  child: CachedNetworkImage(
                    imageUrl:
                        "http://shabab-it.com/antiquehut/images/product_pic/${widget.product.image}.jpg",
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        new CircularProgressIndicator(),
                    errorWidget: (context, url, error) => new Icon(
                      Icons.broken_image,
                      size: screenWidth / 2,
                    ),
                  )),
                  SizedBox(height: 10),
                   Text(
                'Shop ID:' + widget.product.shopid,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Shop Name:' + widget.product.shopname,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Product ID:' + widget.product.productId,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Product Catagory:' + widget.product.catagory,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Product Name:' + widget.product.productname,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Shop Phone Number:' + widget.product.phone,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Quantity:' + widget.product.quantity,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Price:' + widget.product.price,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Shop Address:' + widget.product.location,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              SizedBox(width: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Icon(
                         Icons.category_sharp,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 15),
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 40,
                          width: screenWidth / 1.5,
                         child: DropdownButton(
                            
                            hint: Text(
                              'Quantity',
                             style: TextStyle(
                                color: Color.fromRGBO(101, 255, 218, 50),
                               
                                fontSize: 16,
                           ),
                           ), // Not necessary for Option 1
                            value: selectediteam,
                            onChanged: (newValue) {
                              setState(() {
                                selectediteam = newValue;
                               print(selectediteam);
                              });
                           },
                            items: productQty.map((selectedCata) {
                              return DropdownMenuItem(
                                child: new Text(selectedCata.toString(),
                                   style: TextStyle(color: Colors.black)),
                               value: selectedCata,
                              );
                           }).toList(),
                         ),
                        ),
                     ],
                    ),

              SizedBox(height: 10),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                minWidth: 300,
                height: 50,
                child: Text('Add/Update Cart'),
                color: Colors.black,
                textColor: Colors.white,
                elevation: 15,
                onPressed: _onOrderDialog,
              ),
              SizedBox(height: 10),
            ],
          ),
        )));
  }

   void _onOrderDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Order " + widget.product.productname + "?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Quantity " + selectediteam.toString(),
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
              onPressed: () {
                Navigator.of(context).pop();
                _orderProduct();
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

  void _orderProduct() {
    http.post("http://shabab-it.com/antiquehut/php/add_order.php", body: {
      "email": widget.user.email,
      "id": widget.product.productId,
      "qty": selectediteam.toString(),
      
      
      
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show(
          "Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        Navigator.pop(context);
      } else {
        Toast.show(
          "Failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }).catchError((err) {
      print(err);
    });
  }
}
