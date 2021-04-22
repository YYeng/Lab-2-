import 'package:cv_battey/signupscreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'mainscreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  SharedPreferences preferences;
  double screenHeight, screenWidth;
  bool _rememberMe = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    loadPreference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color(0xA28ABBDB),
                          Color(0x8F5492AF),
                          Color(0xDC249ED6),
                          Color(0xFF009BE2),
                        ]),
                        borderRadius: BorderRadius.only(
                          bottomLeft: const Radius.circular(70),
                          bottomRight: const Radius.circular(70),
                        ),
                      ),
                      child: Image.asset('asset/images/CVbattery.png')),
                ),
                Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    elevation: 20,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text('Login',
                                style: TextStyle(
                                    fontSize: 26, fontWeight: FontWeight.bold)),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  hintText: 'Email', icon: Icon(Icons.email)),
                              validator: (String value) {
                                if (!RegExp(
                                        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$")
                                    .hasMatch(value)) {
                                  return "Please enter a valid email address";
                                }

                                return null;
                              },
                            ),
                            TextField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                  hintText: 'Password', icon: Icon(Icons.lock)),
                              obscureText: true,
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Checkbox(
                                    value: _rememberMe,
                                    onChanged: (bool value) {
                                      _onChange(value);
                                    }),
                                Text("Remember Me",
                                    style: TextStyle(fontSize: 18))
                              ],
                            ),
                            MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                minWidth: 200,
                                child: Text('Login',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                color: Colors.blueAccent,
                                onPressed: _onLogin)
                          ],
                        ),
                      ),
                    )),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("Don't have an account?",
                      style: TextStyle(fontSize: 16)),
                  GestureDetector(
                      child: Text("  Sign up ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      onTap: _signUpNewUser)
                ]),
                TextButton(
                    child: Text("\nForgot Password",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    onPressed: _forgotPassword)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onLogin() {
    String email = _emailController.text.toString();
    String password = _passwordController.text.toString();

    http.post(
        Uri.parse(
            'https://crimsonwebs.com/s270737/cvbattery/php/login_user.php'),
        body: {"email": email, "password": password}).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: " Login Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        FocusScope.of(context).unfocus();

        Navigator.push(
            context, MaterialPageRoute(builder: (content) => MainScreen()));
      } else {
        Fluttertoast.showToast(
            msg: "Login Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  void _signUpNewUser() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => SignUpScreen()));
  }

  void _forgotPassword() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Forgot Password?"),
              content: new Container(
                  height: 100,
                  child: Column(
                    children: [
                      Text("Enter your recovery email"),
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'Email', icon: Icon(Icons.email)),
                      ),
                    ],
                  )),
              actions: [
                TextButton(
                    onPressed: () {
                      print(_emailController.text);
                      _resetPassword(_emailController.text.toString());
                      Navigator.of(context).pop();
                    },
                    child: Text("Submit", style: TextStyle(fontSize: 18)))
              ]);
        });
  }

  void _onChange(bool value) {
    String _email = _emailController.text.toString();
    String _password = _passwordController.text.toString();

    if (_email.isEmpty || _password.isEmpty) {
      Fluttertoast.showToast(
          msg: "Email/Password is empty",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(160, 20, 46, 50),
          textColor: Colors.white,
          fontSize: 18.0);
      return;
    }
    setState(() {
      _rememberMe = value;
      savePref(value, _email, _password);
    });
  }

  Future<void> savePref(bool value, String email, String password) async {
    // obtain shared preferences
    preferences = await SharedPreferences.getInstance();
    if (value) {
      // set value
      await preferences.setString("email", email);
      await preferences.setString("password", password);
      await preferences.setBool("rememberMe", value);

      Fluttertoast.showToast(
          msg: "Preference saved",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(160, 20, 46, 50),
          textColor: Colors.white,
          fontSize: 18.0);
      return;
    } //if
    else {
      await preferences.setString("email", "");
      await preferences.setString("password", "");
      await preferences.setBool("rememberMe", false);

      Fluttertoast.showToast(
          msg: "Preference removed",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(160, 20, 46, 50),
          textColor: Colors.white,
          fontSize: 18.0);

      setState(() {
        _passwordController.text = "";
        _rememberMe = false;
      });
    }
  }

  Future<void> loadPreference() async {
    preferences = await SharedPreferences.getInstance();

    String _email = preferences.getString("email") ?? "";
    String _password = preferences.getString("password") ?? "";
    _rememberMe = preferences.getBool("rememberMe") ?? false;

    setState(() {
      _emailController.text = _email;
      _passwordController.text = _password;
    });
  }
}

void _resetPassword(String email) {
  http.post(
      Uri.parse(
          "https://crimsonwebs.com/s270737/cvbattery/php/reset_password.php"),
      body: {"email": email}).then((response) {
    print(response.body);
    if (response.body == "success") {
      Fluttertoast.showToast(
          msg:
              "Password reset completed. Please check your email for further instruction",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(191, 30, 46, 50),
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Email doesn't exist. Please enter your register email",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(191, 30, 46, 50),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  });
}
