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

  bool _rememberMe = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                                keyboardType: TextInputType.emailAddress,
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
                                      icon: Icon(Icons.lock)),
                                  obscureText: true,
                                  validator: (String value) {
                                    if (value.length == 0)
                                      return "This field is required";
                                    if (!RegExp(
                                         r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{5,}$')
                                      .hasMatch(value)) {
                                    return "Password should contain atleast contain \ncapital letter, small letter and number ";
                                  }
                                      return null;
                                  }),
                              TextFormField(
                                controller: _confirmPassController,
                                decoration: InputDecoration(
                                    hintText: 'Confirm Password',
                                    icon: Icon(Icons.lock)),
                                obscureText: true,
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
                  Text("Adready have an account?",
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
    String _userName = _userNameController.text.toString();
    String _email = _emailController.text.toString();
    String _password = _passwordController.text.toString();
    String _confirmPass = _confirmPassController.text.toString();
    if (_userName.isEmpty ||
        _email.isEmpty ||
        _password.isEmpty ||
        _confirmPass.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please fill in all the infomation",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(191, 30, 46, 50),
          textColor: Colors.white,
          fontSize: 18.0);
      return;
    } //validate empty column

    setState(() {
      _rememberMe = value;
      savePref(value, _userName, _email, _password, _confirmPass);
    });
  }

  Future<void> savePref(bool value, String userName, String email,
      String password, String confirmPass) async {
    // obtain shared preferences
    preferences = await SharedPreferences.getInstance();
    if (value) {
      // set value
      await preferences.setString("userName", userName);
      await preferences.setString("email", email);
      await preferences.setString("password", password);
      await preferences.setString("confirmPass", confirmPass);
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
      await preferences.setString("userName", "");
      await preferences.setString("email", "");
      await preferences.setString("password", "");
      await preferences.setString("confirmPass", "");
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
        _userNameController.text ="";
        _emailController.text ="";
        _passwordController.text = "";
        _confirmPassController.text = "";
        _rememberMe = false;
      });
    }
  }

  Future<void> loadPreference() async {
    preferences = await SharedPreferences.getInstance();
    String _userName = preferences.getString("userName") ?? "";
    String _email = preferences.getString("email") ?? "";
    String _password = preferences.getString("password") ?? "";
    String _confirmPas = preferences.getString("confirm password") ?? "";
    _rememberMe = preferences.getBool("rememberMe") ?? false;

    setState(() {
      _userNameController.text = _userName;
      _emailController.text = _email;
      _passwordController.text = _password;
      _confirmPassController.text = _confirmPas;
    });
  }

  void _onSignUp() {
    String _userName = _userNameController.text.toString();
    String _email = _emailController.text.toString();
    String _password = _passwordController.text.toString();
    String _confirmPass = _confirmPassController.text.toString();

    if (_userName.isEmpty ||
        _email.isEmpty ||
        _password.isEmpty ||
        _confirmPass.isEmpty) {

      _formKey.currentState.validate();
     
    } else if (_formKey.currentState.validate() == true) {
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
  }

  void _userSignUp(String _userName, String _email, String _password) {
    http.post(
        Uri.parse(
           // 'https://crimsonwebs.com/s270737/cvbattery/php/signup_user.php'
           CONFIG.SERVER + "/cvbattery/php/signup_user.php"),
        body: {
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
}
