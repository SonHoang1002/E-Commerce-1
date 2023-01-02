import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/addition/app_localization.dart';
import 'package:testecommerce/addition/pageRoute.dart';
import 'package:testecommerce/gradient/gradient.dart';
import 'package:testecommerce/providers/general_provider.dart';
import 'package:testecommerce/providers/product_provider.dart';
import 'package:testecommerce/screen/admin/home_admin.dart';
// import 'package:testecommerce/screen/alertResetPassword.dart';
import 'package:testecommerce/screen/alert_reset_password.dart';
import 'package:testecommerce/screen/home_page.dart';
import 'package:testecommerce/screen/reset_password.dart';
import 'package:testecommerce/screen/sign_up.dart';
import 'package:testecommerce/screen/welcome_screen.dart';
import 'dart:isolate';
import "package:http/http.dart" as http;

import '../addition/ad_helper.dart';
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
  TextEditingController email = TextEditingController(text: "admin@gmail.com");
  TextEditingController password = TextEditingController(text: "12345678");
  TextEditingController resetController = TextEditingController(text: "");
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

  late GeneralProvider generalProvider;

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
        generalProvider.setEmailFromLogin(email.text.trim());
        if (result != null) {
          generalProvider =
              Provider.of<GeneralProvider>(context, listen: false);
          // generalProvider.setEmailFromLogin(email.text.trim());
          loadData();
          if (email.text.trim() == "admin@gmail.com") {
            generalProvider.setAdmin(true);
            generalProvider.removeNotiList();
            generalProvider.addNotiList(
                "${getTime()}: Welcome To Admin Screen Of H&H FOOD");
            setState(() {
              isLoading = false;
            });
            // Navigator.of(context).pushReplacement(
            //     MaterialPageRoute(builder: (ctx) => HomeAdmin()));
            Navigator.of(context)
                .pushReplacement(PageRouteToScreen().pushToHomeAdminScreen());
          } else {
            generalProvider.setAdmin(false);
            setState(() {
              isLoading = false;
            });
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (ctx) =>
                    HomePage(nameList: generalProvider.getNameProductList)));
            // Navigator.of(context).pushReplacement(PageRouteToScreen().pushToHomePageScreen(nameList:generalProvider.getNameProductList));
          }
        }
      }
    } on PlatformException catch (error) {
      String? message = "Please Check Your Internet Connection ";
      if (error.message != null) {
        message = error.message;
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print("----------------------${(error.toString())}");
      // showDialog(
      //     context: context,
      //     builder: (ctx) {
      //       return AlertDialog(
      //         title: Wrap(
      //           children: [
      //             Icon(Icons.error),
      //             SizedBox(width: 10),
      //             Text("Message"),
      //           ],
      //         ),
      //         content: Text("Login unsuccessfully !!"),
      //         actions: [
      //           ElevatedButton(
      //               onPressed: (() => Navigator.of(context).pop()),
      //               child: Text("OK"))
      //         ],
      //       );
      //     });
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

  bool isErrorCode = false;
  BannerAd? _ad;
  int minute = 1;
  String zero = "";
  int seconds = 10;
  late Timer timer;
  @override
  Widget build(BuildContext context) {
    generalProvider = Provider.of<GeneralProvider>(context);
    setAdvertisement();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.of(context)
            //     .push(MaterialPageRoute(builder: (_) => WelcomeScreen()));
            Navigator.of(context)
                .push(PageRouteToScreen().pushToWelcomeScreen());
          },
        ),
      ),
      body: Container(
        decoration: DecorationBackGround().buildDecoration(),
        child: Column(
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
                // decoration: DecorationBackGround().buildDecoraion(),
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    Container(
                      height: 400,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            AppLocalizations.of(context)!
                                                .translate("login") ??"Login",
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
                                hintText: AppLocalizations.of(context)!
                                                .translate("password") ??"Password",
                                labelText: AppLocalizations.of(context)!
                                                .translate("password") ??"Password",
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
                          Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                child: Text(
                                  AppLocalizations.of(context)!
                                                .translate("forgot_password") ??"Forgot my password !!",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 182, 67, 79)),
                                ),
                                onTap: () {
                                  // _buildResetDialog(context);
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (email.text.trim() == "admin@gmail.com") {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            content: Text(
                                      "Admin can not change password !!",
                                      style: TextStyle(color: Colors.red),
                                    )));
                                  } else {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => AlertResetPassword(
                                                email: email.text.trim())));
                                  }
                                },
                              ),
                            ],
                          ),
                          Container(
                              height: 45,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  validation();
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!
                                                .translate("login") ??"Login",
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.black),
                                ),
                              )),
                          Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                AppLocalizations.of(context)!
                                                .translate("have_no_account") ??"I have no account !!",
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Navigator.of(context).pushReplacement(
                                  //     CupertinoPageRoute(
                                  //         builder: (context) => Signup()));
                                  Navigator.of(context).pushReplacement(
                                      PageRouteToScreen().pushToSignupScreen());
                                },
                                child: Text(AppLocalizations.of(context)!
                                                .translate("sign_up") ??"Sign Up",
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
      ),
    );
  }

  Future<void> send() async {
    if (generalProvider.getResetCode == "") {
      final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
      String message = "";
      for (int i = 0; i < 6; i++) {
        message += Random().nextInt(9).toString();
      }
      if (message.split("")[0] == 0) {
        for (int i = 0; i < 6; i++) {
          message += Random().nextInt(9).toString();
        }
      }
      generalProvider.setResetCode(message);
      print(message);
      try {
        final response = await http.post(url,
            headers: {
              "Content-Type": "application/json",
              "origin": "http://localhost"
            },
            body: json.encode({
              "service_id": "service_epn6lva",
              "template_id": "template_m7c2jus",
              "user_id": "XODjifkQVe_sJaakG",
              "template_params": {
                // "to_email": "kingmountain117@gmail.com",
                "to_email": email.text.trim(),
                "from_email": "H&HFood@gmail.com",
                "from_name": "H&H FOOD",
                "to_name": "you",
                "message": message
              }
            }));
        print(response.body);
      } catch (error) {
        print("ERROR: ${error}");
      }
    }
  }

  void setAdvertisement() {
    if (_ad == null) {
      BannerAd(
        adUnitId: AdHelper.bannerAdUnitId,
        size: AdSize.banner,
        request: AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              _ad = ad as BannerAd;
            });
            generalProvider.setAds(_ad!);
            print("add ads to gene... ok");
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            print(
                'Ad load failed (code=${error.code} message=${error.message})');
          },
        ),
      ).load();
    }
  }

  void validation() async {
    setState(() {
      isLoading = true;
    });
    if (email.text.isEmpty && password.text.isEmpty) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Both Field Are Empty"),
        ),
      );
    } else if (email.text.isEmpty) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Email Is Empty"),
        ),
      );
    } else if (!regExp.hasMatch(email.text)) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Try Valid Email"),
        ),
      );
    } else if (password.text.isEmpty) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password Is Empty"),
        ),
      );
    } else if (password.text.length < 8) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password Is Too Short"),
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
    List<Product> asd = generalProvider.searchProductList("");
    Future<int> sdhf = generalProvider.setTotalRenenue();

    if (generalProvider.getNotiList.length <= 0) {
      generalProvider
          .addNotiList("${getTime()}: Welcome To Home Screen Of H&H FOOD");
    }
  }

  void _buildResetDialog(BuildContext context) async {
    buildTimeOutForResetPassword();
    return showDialog(
        context: context,
        builder: (ctx) {
          send();
          FocusManager.instance.primaryFocus?.unfocus();
          return AlertDialog(
            title: Text(
              "Please enter reset number from my email",
              textAlign: TextAlign.center,
            ),
            content: Container(
              height: 100,
              child: Column(
                children: [
                  Text(
                    "${minute}:${zero}${seconds}",
                    style: TextStyle(fontSize: 25),
                  ),
                  TextFormField(
                    controller: resetController,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 6,
                  ),
                  // isErrorCode
                  //     ? Container(
                  //         height: 30,
                  //         child: Row(
                  //           children: [
                  //             Text(
                  //               "Invalid code",
                  //               style: TextStyle(
                  //                   color:
                  //                       Colors.red),
                  //             )
                  //           ],
                  //         ),
                  //       )
                  //     : Container()
                ],
              ),
            ),
            actions: [
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      if (resetController.text.trim().length != 6) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Reset code must has 6 chracters")));
                        return;
                      }
                      if (resetController.text.trim() ==
                          generalProvider.getResetCode) {
                        setState(() {
                          isErrorCode = true;
                        });
                        FocusManager.instance.primaryFocus?.unfocus();
                        Navigator.of(context).pop();
                        // Navigator.of(context).push(
                        //     MaterialPageRoute(
                        //         builder: (_) =>
                        //             ResetPassword()));
                        Navigator.of(context).push(
                            PageRouteToScreen().pushToResetPasswordScreen());
                        return;
                      } else {
                        setState(() {
                          isErrorCode = true;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Invalid Code")));
                        return;
                      }
                    },
                    child: Text("CHECK")),
              )
            ],
          );
        });
  }

  void buildTimeOutForResetPassword() {
    const perSecond = Duration(seconds: 1);
    timer = Timer.periodic(perSecond, (timer) {
      if (minute == 0 && seconds == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        if (seconds == 0) {
          setState(() {
            minute--;
            seconds = 10;
          });
        } else {
          setState(() {
            // if (seconds<11) {
            //   setState(() {
            //     zero = "0";
            //   });
            // } else {
            //   setState(() {
            //     zero = "";
            //   });
            // }
            seconds--;
          });
        }
      }
    });
  }
}
