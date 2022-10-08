import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/providers/general_provider.dart';
import 'package:testecommerce/providers/product_provider.dart';
import 'package:testecommerce/screen/admin/homeadmin.dart';
import 'package:testecommerce/screen/homepage.dart';
import 'package:testecommerce/screen/signup.dart';
import 'dart:isolate';

import '../addition/timer.dart';
import '../models/product.dart';
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
  TextEditingController email = TextEditingController(text: "f@gmail.com");
  TextEditingController password = TextEditingController(text: "12345678");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;

  late List<Product> listFeature = [];
  late List<Product> listNew = [];

  late List<Product> listAsia = [];
  late List<Product> listEast = [];
  late List<Product> listSnack = [];
  late List<Product> listWater = [];
  late List<Product> listDrink = [];

  String? name = "";
  late List<String> nameList = [];
  void submit(context) async {
    late UserCredential result;
    try {
      // setState(() {
      //   isLoading = true;
      // });
      if (_formKey.currentState!.validate()) {
        result = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.text.trim(), password: password.text.trim());
        print(result);
        if (result != null) {
          generalProvider =
              Provider.of<GeneralProvider>(context, listen: false);
          generalProvider.setEmailFromLogin(email.text.trim());
          loadData();
          if (email.text.trim() == "admin@gmail.com") {
            generalProvider.setAdmin(true);
            generalProvider.removeNotiList();
            generalProvider.addNotiList(
                "${getTime()}: Welcome To Admin Screen Of H&H FOOD");
            setState(() {
              isLoading = false;
            });
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => HomeAdmin()));
          } else {
            generalProvider.setAdmin(false);
            setState(() {
              isLoading = false;
            });
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => HomePage(nameList:generalProvider.getNameProductList)));
          }
        }
      }
    } on PlatformException catch (error) {
      String? message = "Please Check Your Internet Connection ";
      if (error.message != null) {
        message = error.message;
      }
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(message.toString()),
      //     duration: Duration(milliseconds: 800),
      //     backgroundColor: Theme.of(context).primaryColor,
      //   ),
      // );
      print(message.toString());
    } catch (error) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(error.toString()),
      //   duration: Duration(milliseconds: 800),
      //   backgroundColor: Theme.of(context).primaryColor,
      // ));
      print(error.toString());
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
      body: Column(
        children: [
          isLoading
              ? Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(child: CircularProgressIndicator()))
              : Container(
                  height: 20,
                ),
          Form(
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
                          style: TextStyle(
                              fontSize: 50, fontWeight: FontWeight.bold),
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
                            child: ElevatedButton(
                              onPressed: () {
                                // Future.delayed(Duration(seconds: 2), () {
                                setState(() {
                                  isLoading = true;
                                });
                                validation();
                                // });
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                              ),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 30, color: Colors.black),
                              ),
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
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 15)),
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
        ],
      ),
    );
  }

  void validation() async {
    setState(() {
      isLoading = true;
    });
    if (email.text.isEmpty && password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Both Field Are Empty"),
        ),
      );
    } else if (email.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Email Is Empty"),
        ),
      );
    } else if (!regExp.hasMatch(email.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Try Valid Email"),
        ),
      );
    } else if (password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password Is Empty"),
        ),
      );
    } else if (password.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password  Is Too Short"),
        ),
      );
    } else {
      FocusManager.instance.primaryFocus?.unfocus();
      submit(context);
    }
  }

  void loadData() {
    // generalProvider = Provider.of<GeneralProvider>(context);
    // generalProvider.setEmailFromLogin(FirebaseAuth.instance.currentUser!.email);
    if (listAsia.length == 0) {
      Future<int> a = generalProvider.setAsiaDish();
      listAsia = generalProvider.getListAsia();
    }
    if (listEast.length == 0) {
      Future<int> b = generalProvider.setEastDish();
      listEast = generalProvider.getEastDish();
    }
    if (listSnack.length == 0) {
      Future<int> c = generalProvider.setSnack();
      listSnack = generalProvider.getSnack();
    }
    if (listWater.length == 0) {
      Future<int> d = generalProvider.setwaterDish();
      listWater = generalProvider.getWaterDish();
    }
    if (listFeature.length == 0) {
      Future<int> e = generalProvider.setFeatureProduct();
      listFeature = generalProvider.getFeatureProduct();
    }
    if (listNew.length == 0) {
      Future<int> f = generalProvider.setNewProduct();
      listNew = generalProvider.getNewProduct();
    }
    if (listDrink.length == 0) {
      Future<int> g = generalProvider.setDrink();
      listDrink = generalProvider.getListDrink();
    }
    if (name == "") {
      // generalProvider.setNumberOfAllProduct();
      Future<int> f = generalProvider.setUserModel();
      name = generalProvider.getUserModelName;
    }
     if (nameList == []) {
      Future<int> xxx = generalProvider.setNameProductList();
      nameList = generalProvider.getNameProductList;
    }

    if (generalProvider.getNotiList.length <= 0) {
      generalProvider
          .addNotiList("${getTime()}: Welcome To Home Screen Of H&H FOOD");
    }
   
  }
}
