import 'package:antiquehut/register_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';


import 'mainScreen.dart';
import 'user.dart';






class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emcontroller = TextEditingController();
  String _email = "";
  final TextEditingController _pscontroller = TextEditingController();
  String _password = "";
  bool _rememberMe = false;
  SharedPreferences prefs;

  @override
  void initState() {
    loadpref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressAppBar,
        child: Scaffold(
            appBar: AppBar(
              title: Text('Login'),
            ),
            //resizeToAvoidBottomPadding: false,
            body: new Container(
              padding: EdgeInsets.all(30.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/sps.jpg',
                      scale: 1,
                    ),
                    TextField(
                        controller: _emcontroller,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                            icon: Icon(Icons.email))),
                    TextField(
                      controller: _pscontroller,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                          icon: Icon(Icons.lock)),
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      minWidth: 300,
                      height: 50,
                      child: Text('Login'),
                      color: Colors.black,
                      textColor: Colors.white,
                      elevation: 15,
                      onPressed: _onLogin,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (bool value) {
                            _onChange(value);
                          },
                        ),
                        Text(
                          'Remember Me',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    GestureDetector(
                        onTap: _onRegister,
                        child: Text('Register New Account',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold))),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                        onTap: _onForgot,
                        child: Text('Forgot Account',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
            )));
  }

  Future<void> _onLogin() async {
    _email = _emcontroller.text;
    _password = _pscontroller.text;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Login...");
    await pr.show();
    http.post("https://shabab-it.com/antiquehut/php/login_user.php", body: {
      "email": _email,
      "password": _password,
    }).then((res) {
      print(res.body);
      List userdata = res.body.split(",");
      if (userdata[0] == "success") {
        Toast.show(
          "Login Succes",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
            User user = new User(
            email: _email,
            name: userdata[1],
            
            phone: userdata[2],
            date: userdata[3]);
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => MainScreen(user: user,)));
      } else {
        Toast.show(
          "Login failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }

  void _onRegister() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => RegisterScreen()));
  }

  void _onForgot() {
   
  }

  void _onChange(bool value) {
    setState(() {
      _rememberMe = value;
      savepref(value);
    });
  }

  void loadpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = (prefs.getString('email')) ?? '';
    _password = (prefs.getString('password')) ?? '';
    _rememberMe = (prefs.getBool('rememberme')) ?? false;
    if (_email.isNotEmpty) {
      setState(() {
        _emcontroller.text = _email;
        _pscontroller.text = _password;
        _rememberMe = _rememberMe;
      });
    }
  }

  void savepref(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = _emcontroller.text;
    _password = _pscontroller.text;

    if (value) {
      if (_email.length < 5 && _password.length < 3) {
        print("EMAIL/PASSWORD EMPTY");
        _rememberMe = false;

        return;
      } else {
        await prefs.setString('email', _email);
        await prefs.setString('password', _password);
        await prefs.setBool('rememberme', value);

        print("SUCCESS");
      }
    } else {
      await prefs.setString('email', '');
      await prefs.setString('password', '');
      await prefs.setBool('rememberme', false);
      setState(() {
        _emcontroller.text = "";
        _pscontroller.text = "";
        _rememberMe = false;
      });
    }
  }

  Future<bool> _onBackPressAppBar() async {
    SystemNavigator.pop();
    print('Backpress');
    return Future.value(false);
  }
}
