import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'loginscreen.dart';
import 'product.dart';


class AddProduct extends StatefulWidget {
  final Product product;

  const AddProduct({Key key, this.product}) : super(key: key);
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final TextEditingController _idcontroller = TextEditingController();
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _productcatacontroller = TextEditingController();
  final TextEditingController _productnamecontroller = TextEditingController();
  final TextEditingController _productphonecontroller = TextEditingController();
  final TextEditingController _productpricecontroller = TextEditingController();
  final TextEditingController _productqtycontroller = TextEditingController();
  final TextEditingController _productaddqtycontroller =TextEditingController();

  String _shopid = "";
  String _shopname = "";
  String _productName = "";
  String _phone = "";
  String _price = "";
  String _quantity = "";
  String _selectedCata = "";
  double screenHeight, screenWidth;
  File _image;
  String pathAsset = 'assets/images/camera.jpg';
 

  String _address = "";
 

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('New Product'),
      ),
      body: Container(
          child: Padding(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                        onTap: () => {_onPictureSelection()},
                        child: Container(
                          height: screenHeight / 3.2,
                          width: screenWidth / 1.8,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: _image == null
                                  ? AssetImage(pathAsset)
                                  : FileImage(_image),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(
                              width: 3.0,
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(
                                    5.0) //         <--- border radius here
                                ),
                          ),
                        )),
                    SizedBox(height: 5),
                    Text("Click image to take food picture",
                        style: TextStyle(fontSize: 10.0, color: Colors.black)),
                    SizedBox(height: 5),
                    TextField(
                        controller: _idcontroller,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            labelText: 'Shop Id',
                            icon: Icon(Icons.confirmation_number))),
                    TextField(
                        controller: _namecontroller,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            labelText: 'Shop Name', icon: Icon(Icons.shop))),

                    TextField(
                        controller: _productcatacontroller,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            labelText: 'Product Catagory',
                            icon: Icon(Icons.category_sharp))),
                    TextField(
                        controller: _productnamecontroller,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            labelText: 'Product Name',
                            icon: Icon(Icons.fastfood_outlined))),
                    TextField(
                        controller: _productphonecontroller,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            labelText: 'Shop Phone Number', icon: Icon(Icons.phone))),
                    TextField(
                        controller: _productpricecontroller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Product Price',
                            icon: Icon(Icons.money))),
                    TextField(
                        controller: _productqtycontroller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Quantity Available',
                            icon: Icon(MdiIcons.numeric))),
                    SizedBox(height: 10),
                    TextField(
                        controller: _productaddqtycontroller,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            labelText: 'Shop Address', icon: Icon(MdiIcons.map))),
                    SizedBox(height: 10),
                    
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      minWidth: 300,
                      height: 50,
                      child: Text('Add New Product'),
                      color: Colors.black,
                      textColor: Colors.white,
                      elevation: 15,
                      onPressed: newpeoductDialog,
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ))),
    );
  }

  _onPictureSelection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: new Container(
              
              height: screenHeight / 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Take picture from:",
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
                        child: Text('Camera',
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        
                        color: Colors.blueGrey,
                        textColor: Colors.black,
                        elevation: 10,
                        onPressed: () =>
                            {Navigator.pop(context), _chooseCamera()},
                      )),
                      SizedBox(width: 10),
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 100,
                        child: Text('Gallery',
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        
                        color: Colors.blueGrey,
                        textColor: Colors.black,
                        elevation: 10,
                        onPressed: () => {
                          Navigator.pop(context),
                          _chooseGallery(),
                        },
                      )),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }

  void _chooseCamera() async {
    // ignore: deprecated_member_use
    _image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 1080, maxWidth: 1080);
    _cropImage();
    setState(() {});
  }

  void _chooseGallery() async {
    //ignore: deprecated_member_use
    _image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 1080, maxWidth: 1080);
    _cropImage();
    setState(() {});
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
              ]
            : [
                CropAspectRatioPreset.square,
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Resize',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }

  void _onRegister() async {
    _shopid = _idcontroller.text;
    _shopname = _namecontroller.text;
    _selectedCata = _productcatacontroller.text;
    _productName = _productnamecontroller.text;
    _phone = _productphonecontroller.text;
    _price = _productpricecontroller.text;
    _quantity = _productqtycontroller.text;
    _address = _productaddqtycontroller.text;

    

    final dateTime = DateTime.now();
    String base64Image = base64Encode(_image.readAsBytesSync());
    print(base64Image);
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Registration...");
    await pr.show();
    http.post("http://shabab-it.com/antiquehut/php/add_product.php", body: {
      // "catagory":selectedCata,
      "shopid": _shopid,
      "shopname": _shopname,
      "catagory": _selectedCata,
      "productname": _productName,
      "phone": _phone,
      "price": _price,
      "quantity": _quantity,
      "location": _address,
      "encoded_string": base64Image,
      "image": _phone + "-${dateTime.microsecondsSinceEpoch}",
    }).then((res) {
      print(res.body);
      if (res.body == "succes") {
        Toast.show(
          "Registration success.",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      } else {
        Toast.show(
          "Registration failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }).catchError((err) {
      print(err);
    });
  }

  void newpeoductDialog() {
    _shopid = _idcontroller.text;
    _shopname = _namecontroller.text;
    _selectedCata = _productcatacontroller.text;
    _productName = _productnamecontroller.text;
    _phone = _productphonecontroller.text;
    _price = _productpricecontroller.text;
    _quantity = _productqtycontroller.text;
    _address = _productaddqtycontroller.text;

    if (_image == null) {
      Toast.show("Product picture empty!.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Register new Product? ",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are you sure?",
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
                print("upload data");
                Navigator.of(context).pop();
                _onRegister();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen()));
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
}
