import 'package:cv_battey/config.dart';
import 'package:cv_battey/view/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _confirmPassController = new TextEditingController();
  SharedPreferences preferences;
  double screenHeight, screenWidth;
  bool _isChecked = false;
  bool _obscureText = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      title: 'Sign up screen',
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
                              Text('Sign Up',
                                  style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold)),
                              TextFormField(
                                controller: _userNameController,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                    hintText: 'User name',
                                    icon: Icon(Icons.person)),
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'This field is required';
                                  }
                                  if (value.trim().length < 4) {
                                    return 'Username must be at least 4 characters in length';
                                  }
                                  // Return null if the entered username is valid
                                  return null;
                                },
                              ),
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
                              TextFormField(
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    icon: Icon(Icons.lock),
                                    suffix: InkWell(
                                      onTap: _togglePass,
                                      child: Icon(Icons.visibility),
                                    ),
                                  ),
                                  obscureText: _obscureText,
                                  validator: (String value) {
                                    if (value.length == 0)
                                      return "This field is required";
                                    if (!RegExp(
                                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{5,}$')
                                        .hasMatch(value)) {
                                      return "Password should contain at least contain \ncapital letter, small letter and number ";
                                    }
                                    return null;
                                  }),
                              TextFormField(
                                controller: _confirmPassController,
                                decoration: InputDecoration(
                                  hintText: 'Confirm Password',
                                  icon: Icon(Icons.lock),
                                  suffix: InkWell(
                                    onTap: _togglePass,
                                    child: Icon(Icons.visibility),
                                  ),
                                ),
                                obscureText: _obscureText,
                                validator: (String value) {
                                  if (value.length == 0)
                                    return "This field is required";
                                  if (_passwordController.text !=
                                      _confirmPassController.text) {
                                    return "Password do not match";
                                  }

                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Checkbox(
                                      value: _isChecked,
                                      onChanged: (bool value) {
                                        _onChange(value);
                                      }),
                                  GestureDetector(
                                    onTap: _showEULA,
                                    child: Text('I Agree with Terms  ',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ],
                              ),
                              MaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  minWidth: 200,
                                  child: Text('Sign Up',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                  color: Colors.blueAccent,
                                  onPressed: _onSignUp)
                            ],
                          ),
                        ))),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("Already have an account?",
                      style: TextStyle(fontSize: 16)),
                  GestureDetector(
                      child: Text(" Sign in ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      onTap: _loginScreenState)
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _loginScreenState() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => LoginScreen()));
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
    });
  }

  void _onSignUp() {
    String _userName = _userNameController.text.toString();
    String _email = _emailController.text.toString();
    String _password = _passwordController.text.toString();
    String _confirmPass = _confirmPassController.text.toString();
    bool _validate = _formKey.currentState.validate();

    if (_userName.isEmpty ||
        _email.isEmpty ||
        _password.isEmpty ||
        _confirmPass.isEmpty) {
      return;
    }

    if (_validate == false) {
      Fluttertoast.showToast(
          msg: "Please enter valid information",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    if (!_isChecked) {
      Fluttertoast.showToast(
          msg: "Please accept terms",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      return;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            title: Text("Sign up new account"),
            content: Text("Are your sure?"),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _userSignUp(_userName, _email, _password);
                },
              ),
              TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  void _userSignUp(String _userName, String _email, String _password) {
    http.post(Uri.parse(
        // 'https://crimsonwebs.com/s270737/cvbattery/php/signup_user.php'
        CONFIG.SERVER + "/cvbattery/php/signup_user.php"), body: {
      "userName": _userName,
      "user_email": _email,
      "password": _password
    }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg:
                "Registration Success. Please check your email for verification link",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        _confirmPassController.clear();
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (content) => LoginScreen()));
      } else {
        Fluttertoast.showToast(
            msg: "Registration Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  void _togglePass() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _showEULA() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("EULA"),
          content: new Container(
            height: screenHeight / 4,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              //fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                            text:
                                "End-User License Agreement (\"Agreement\")\nPlease read this End-User License Agreement carefully before clicking the \"I Agree\" button, downloading or using CV Battery.  This Agreement is a legal document between You and the Company and it governs your use of the Application made available to You by the Company.The Application is licensed, not sold, to You by the Company for use strictly in accordance with the terms of this Agreement. Contact Us If you have any questions about this Agreement, You can contact Us: \nBy email: cvbattery@crimsonwebs.com "
                            //children: getSpan(),
                            )),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new TextButton(
              child: new Text(
                "Close",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
