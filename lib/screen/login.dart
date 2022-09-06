import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/providers/general_provider.dart';
import 'package:testecommerce/providers/product_provider.dart';
import 'package:testecommerce/screen/homepage.dart';
import 'package:testecommerce/screen/signup.dart';
import 'dart:isolate';

import '../models/usermodel.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

String p =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
RegExp regExp = RegExp(p);
late GeneralProvider generalProvider;
// void doTaskUserModel(SendPort sendPort) {
//   // productProvider.setEmailFromLogin(email!);
//   print("doTaskUserModel");
//   Future<int> g = productProvider.getUserModelData();
//   sendPort.send(productProvider.getUserModel);
//   // print(
//   //     "UserName:${productProvider.getUserModel.userName}, UserId:${productProvider.getUserModel.userId}, UserEmail:${productProvider.getUserModel.userEmail}, UserGender:${productProvider.getUserModel.userGender}, UserPhone:${productProvider.getUserModel.userPhone}");
// }

class _Login extends State<Login> {
  TextEditingController email = TextEditingController(text: "d@gmail.com");
  TextEditingController password = TextEditingController(text:"12345678");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;

  void submit(context) async {
    late UserCredential result;
    try {
      setState(() {
        isLoading = true;
      });
      if (_formKey.currentState!.validate()) {
        result = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.text.trim(), password: password.text.trim());
        print(result);
        if (result != null) {
          generalProvider.setEmailFromLogin(email.text.trim());
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (ctx) => HomePage()));
        }
      }
    } on PlatformException catch (error) {
      String? message = "Please Check Your Internet Connection ";
      if (error.message != null) {
        message = error.message;
      }
      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(message.toString()),
          duration: Duration(milliseconds: 800),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      _scaffoldKey.currentState!.showSnackBar(SnackBar(
        content: Text(error.toString()),
        duration: Duration(milliseconds: 800),
        backgroundColor: Theme.of(context).primaryColor,
      ));
    }
  }

  // void newIsolate() {
  //   ReceivePort receivePort = ReceivePort();
  //   Isolate.spawn(doTaskUserModel, receivePort.sendPort);
  //   receivePort.listen((message) {
  //     assert(message);
  //   });
  // }

  var obscureText = true;
  // String? email;
  // String? password;

  @override
  Widget build(BuildContext context) {
    generalProvider = Provider.of<GeneralProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              Container(
                height: 340,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Email",
                          labelText: "Email",
                          hintStyle: TextStyle(color: Colors.black)),
                    ),
                    TextFormField(
                      controller: password,
                      obscureText: obscureText,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Password",
                          labelText: "Password",
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                            child: obscureText
                                ? Icon(
                                    Icons.visibility,
                                    color: Colors.black,
                                  )
                                : Icon(
                                    Icons.visibility_off,
                                    color: Colors.black,
                                  ),
                          ),
                          hintStyle: TextStyle(color: Colors.black)),
                    ),
                    Container(
                        height: 45,
                        width: double.infinity,
                        child: RaisedButton(
                          onPressed: () {
                            // Future.delayed(Duration(seconds: 2), () {
                            validation();
                            // });
                          },
                          color: Colors.grey,
                          child: Text("Login"),
                        )),
                    Row(
                      children: [
                        Text(
                          "I have no account !!",
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                CupertinoPageRoute(
                                    builder: (context) => Signup()));
                          },
                          child: Text("Sign Up",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 15)),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void validation() async {
    if (email.text.isEmpty && password.text.isEmpty) {
      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text("Both Field Are Empty"),
        ),
      );
    } else if (email.text.isEmpty) {
      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text("Email Is Empty"),
        ),
      );
    } else if (!regExp.hasMatch(email.text)) {
      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text("Please Try Valid Email"),
        ),
      );
    } else if (password.text.isEmpty) {
      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text("Password Is Empty"),
        ),
      );
    } else if (password.text.length < 8) {
      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text("Password  Is Too Short"),
        ),
      );
    } else {
      submit(context);
    }
  }

}
