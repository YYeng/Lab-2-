import 'package:cv_battey/model/user.dart';
import 'package:flutter/material.dart';

class ContactUs extends StatefulWidget {
  final User user;

  const ContactUs({Key key, this.user}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController message = new TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
          flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Colors.blue[300], Colors.blue[700]])),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text('Contact Us',
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold)),
                      Container(
                          padding: EdgeInsets.only(top: 15),
                          alignment: Alignment.centerLeft,
                          child: Text("Name",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold))),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: name,
                         decoration: InputDecoration(
                            hintText: 'Enter Name',
                            border: OutlineInputBorder(),
                          ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'This field is required';
                          }
                          // Return null if the entered username is valid
                          return null;
                        },
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 15),
                          alignment: Alignment.centerLeft,
                          child: Text("Email",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold))),
                      SizedBox(height: 10),
                      TextFormField(
                        
                        controller: email,
                         decoration: InputDecoration(
                            hintText: 'Enter Email',
                            border: OutlineInputBorder(),
                          ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (String value) {
                          if (value.isEmpty) return "This field is required";
                          return null;
                        },
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 15),
                          alignment: Alignment.centerLeft,
                          child: Text("Messages",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold))),
                       SizedBox(height: 10),
                      TextFormField(
                          controller: message,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: 'Enter Messages',
                            border: OutlineInputBorder(),
                          ),
                          style: TextStyle(fontSize: 16),
                          minLines: 6, //Normal textInputField will be displayed
                          maxLines: 6, // when user presses enter
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (String value) {
                            if (value.isEmpty) return "This field is required";
                            return null;
                          }),
                      SizedBox(height: 20),
                      MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minWidth: 200,
                          child: Text('Submit',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          color: Colors.blueAccent,
                          onPressed: () {})
                    ],
                  ),
                ))),
      ),
    );
  }
}
