import 'package:cv_battey/model/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ContactUs extends StatefulWidget {
  final User user;

  const ContactUs({Key key, this.user}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController messagesController = new TextEditingController();

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
                        controller: nameController,
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
                        controller: emailController,
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
                          controller: messagesController,
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
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minWidth: 400,
                          child: Text('Submit',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          color: Colors.blueAccent,
                          onPressed: () {
                            _onSubmitMessages();
                          }),
                      Text(
                          "Customer Service will get back to you after you sent the message as soon as possible",
                          style: TextStyle(
                              fontSize: 15,
                             ))
                    ],
                  ),
                ))),
      ),
    );
  }

  void _onSubmitMessages() {
      String _name = nameController.text.toString();
      String _email = emailController.text.toString();
      String _messages = messagesController.text.toString();

   if(_name == ""|| _email == ""|| _messages == ""){
      Fluttertoast.showToast(
            msg: "Please fill in all the detail",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 4,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
   
   }else{

    setState(() {

      _sendMessages(_name, _email, _messages);

      return;
    });

   }
  }

  Future<void> _sendMessages(String name, String email, String messages) async {
    http.post(
        Uri.parse(
            'https://crimsonwebs.com/s270737/cvbattery/php/insert_messages.php'),
        body: {
          "name": name,
          "email": email,
          "messages": messages,
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Submit messages successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 4,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

       setState(() {
         nameController.text = "";
         emailController.text = ""; 
         messagesController.text = "";

       });

      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }
}
