import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/addition/pageRoute.dart';
import 'package:testecommerce/providers/general_provider.dart';
import 'package:testecommerce/providers/product_provider.dart';
import 'package:testecommerce/screen/admin/homeadmin.dart';
import 'package:testecommerce/screen/homepage.dart';
import 'package:testecommerce/screen/signup.dart';
import 'package:testecommerce/screen/welcomescreen.dart';
import 'dart:isolate';
import "package:http/http.dart" as http;

import '../addition/ad_helper.dart';
import '../addition/timer.dart';
import '../models/product.dart';
import '../models/usermodel.dart';
import 'login.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPassword createState() => _ResetPassword();
}

class _ResetPassword extends State<ResetPassword> {
  TextEditingController password = TextEditingController(text: "");
  TextEditingController rpassword = TextEditingController(text: "");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;

  late GeneralProvider generalProvider;

  String? name = "";
  late List<String> nameList = [];

  var obscureText = true;
  bool isCheckPass = false;
  BannerAd? _ad;

  @override
  Widget build(BuildContext context) {
    generalProvider = Provider.of<GeneralProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.of(context)
            //     .push(MaterialPageRoute(builder: (_) => Login()));
                Navigator.of(context).push(PageRouteToScreen().pushToLoginScreen());
          },
        ),
      ),
      body: Column(
        children: [
          isLoading
              ? Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(child: CircularProgressIndicator()))
              : Container(
                  height: 10,
                ),
          Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  Container(
                    height: 300,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Enter New Password",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          controller: password,
                          obscureText: obscureText,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Password",
                              labelText: "Password",
                              // suffixIcon: GestureDetector(
                              //   onTap: () {
                              //     setState(() {
                              //       obscureText = !obscureText;
                              //     });
                              //   },
                              //   child: obscureText
                              //       ? Icon(
                              //           Icons.visibility,
                              //           color: Colors.black,
                              //         )
                              //       : Icon(
                              //           Icons.visibility_off,
                              //           color: Colors.black,
                              //         ),
                              // ),
                              hintStyle: TextStyle(color: Colors.black)),
                        ),
                        TextFormField(
                          controller: rpassword,
                          obscureText: obscureText,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Confirm",
                              labelText: " Confirm password",
                              // suffixIcon: GestureDetector(
                              //   onTap: () {
                              //     setState(() {
                              //       obscureText = !obscureText;
                              //     });
                              //   },
                              //   child: obscureText
                              //       ? Icon(
                              //           Icons.visibility,
                              //           color: Colors.black,
                              //         )
                              //       : Icon(
                              //           Icons.visibility_off,
                              //           color: Colors.black,
                              //         ),
                              // ),
                              hintStyle: TextStyle(color: Colors.black)),
                        ),
                        Container(
                            height: 45,
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                checkValue();
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: Text(
                                "SEND",
                                style: TextStyle(
                                    fontSize: 30, color: Colors.black),
                              ),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void checkValue() async {
    String pass = password.text.trim();
    String rpass = rpassword.text.trim();
    setState(() {
      isLoading = true;
    });
    if (pass.length < 8) {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Wrap(
                children: [
                  Icon(
                    Icons.warning,
                    color: Colors.yellow,
                  ),
                  SizedBox(width: 10),
                  Text("Warning"),
                ],
              ),
              content: Text("Password has least 8 characters !!"),
              actions: [
                ElevatedButton(
                    onPressed: (() => Navigator.of(context).pop()),
                    child: Text("OK"))
              ],
            );
          });
      setState(() {
        isLoading = false;
      });
      return;
    }
    if (pass == rpass) {
      //// update password;
      print("Firebase password before ${FirebaseAuth.instance.currentUser}");

      ///
      await FirebaseAuth.instance.currentUser!.updatePassword(rpass);
      print("Firebase password after ${FirebaseAuth.instance.currentUser}");
      // Navigator.of(context).push(MaterialPageRoute(builder: (_) => Login()));
      Navigator.of(context).push(PageRouteToScreen().pushToLoginScreen());
      generalProvider.setResetCode("");
      setState(() {
        isLoading = false;
      });
      return;
    } else {
      setState(() {
        isLoading = false;
      });
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Wrap(
                children: [
                  Icon(Icons.error),
                  SizedBox(width: 10),
                  Text("Message"),
                ],
              ),
              content: Text("Unsuccessfull Confirm!!"),
              actions: [
                ElevatedButton(
                    onPressed: (() => Navigator.of(context).pop()),
                    child: Text("OK"))
              ],
            );
          });
      return;
    }
  }
}
