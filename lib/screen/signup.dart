import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testecommerce/screen/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class Signup extends StatefulWidget {
  @override
  _Signup createState() => _Signup();
}

String p =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
RegExp regExp = RegExp(p);

class _Signup extends State<Signup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _ScaffordState = GlobalKey<ScaffoldState>();
  void validation() async {
    if (_formKey.currentState!.validate()) {
      try {
        print("email: $email and password :$password");
        final result = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email!, password: password!);
        print("UID_____________");
        print(result.user!.uid);
      } on PlatformException catch (e) {
        print("error:" + e.message.toString());
        _ScaffordState.currentState!.showSnackBar(SnackBar(
          content: Text(e.message.toString()),
          duration: Duration(milliseconds: 600),
          backgroundColor: Theme.of(context).primaryColor,
        ));
      }
    } else {
      print("no");
    }
  }

  var obscureText = true;
  String? password;
  String? email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        key: _ScaffordState,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Container(
              child: Column(
                children: [
                  Container(
                    height: 220,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 400,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextFormField(
                          onChanged: (value) {},
                          validator: (value) {
                            if (value == "") {
                              return "Please fill Username";
                            } else if (value!.length <= 1) {
                              return "Username Is less 1";
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "UserName",
                            labelText: "Username",
                            hintStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              email = value;
                              print("email: $email");
                            });
                          },
                          validator: (value) {
                            if (value == "") {
                              return "Please fill email";
                            }
                            if (!regExp.hasMatch(value!)) {
                              return "Email invalid";
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Email",
                            labelText: "Email",
                            hintStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              password = value;
                              print("password: $password");
                            });
                          },
                          obscureText: obscureText,
                          validator: (value) {
                            if (value == "") {
                              return "Please fill password";
                            } else if (value!.length < 8) {
                              return "Password Is Short";
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Password",
                            labelText: "Password",
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                                FocusScope.of(context).unfocus();
                              },
                              child: (obscureText
                                  ? Icon(
                                      Icons.visibility,
                                      color: Colors.black,
                                    )
                                  : Icon(
                                      Icons.visibility_off,
                                      color: Colors.black,
                                    )),
                            ),
                            hintStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        TextFormField(
                          onChanged: (value) {},
                          validator: (value) {
                            if (value == "") {
                              return "Please fill Phone";
                            } else if (value!.length < 8) {
                              return "Phone Is less 8";
                            }
                          },
                          style: TextStyle(),
                          decoration: InputDecoration(
                            hintText: "Phone",
                            labelText: "Phone",
                            hintStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Container(
                          height: 45,
                          width: double.infinity,
                          child: RaisedButton(
                              child: Text("Register"),
                              color: Colors.blueGrey[400],
                              onPressed: () {
                                validation();
                              }),
                        ),
                        Row(
                          children: [
                            Text("I have account"),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                    CupertinoPageRoute(
                                        builder: (context) => Login()));
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.cyan,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
