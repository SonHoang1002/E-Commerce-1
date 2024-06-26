import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:testecommerce/addition/app_localization.dart';
import 'package:testecommerce/addition/pageRoute.dart';
import 'package:testecommerce/gradient/gradient.dart';
import 'package:testecommerce/main.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool show = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: () {
          MyApp.setLocale(context, Locale("vi", "VN"));
        }),
        body: Container(
          decoration: DecorationBackGround().buildDecoration(),
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 300,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("images/logo.png"),
                              fit: BoxFit.fill)),
                    ),
                    Container(
                      height: 220,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // TextLiquidFill(
                          //   waveDuration: Duration(seconds: 5),
                          //   text: 'H&H FOOD',
                          //   waveColor: Colors.black,
                          //   // boxBackgroundColor: Color(0xfff1f1f1),
                          //   boxBackgroundColor: Colors.lightBlueAccent.shade100,
                          //   textStyle: TextStyle(
                          //       color: Colors.black,
                          //       fontSize: 35,
                          //       fontWeight: FontWeight.bold,
                          //       fontFamily: "DynaPuff"),
                          //   boxHeight: 100.0,
                          // ),
                          // const Text("H&H FOOD ",
                          //     style: TextStyle(
                          //         color: Colors.black,
                          //         fontSize: 35,
                          //         fontWeight: FontWeight.bold,
                          //         fontFamily: "DynaPuff")),
                          // const SizedBox(
                          //   width: 10,
                          // ),
                          SizedBox(
                            width: double.infinity,
                            child: DefaultTextStyle(
                              style: const TextStyle(
                                  fontSize: 25.0,
                                  fontFamily: 'DynaPuff',
                                  color: Colors.black),
                              child: Center(
                                child: AnimatedTextKit(
                                  repeatForever: true,
                                  animatedTexts: [
                                    TypewriterAnimatedText(
                                        AppLocalizations.of(context)!
                                                .translate("welcome title") ??
                                            "Welcome to shopping !"),
                                  ],
                                  onTap: () {
                                    print("Tap Event");
                                  },
                                ),
                              ),
                            ),
                          ),
                          // Text("Ready to shopping",
                          //     style: TextStyle(
                          //         color: Colors.black,
                          //         fontSize: 25,
                          //         fontStyle: FontStyle.italic,
                          //         fontFamily: "DynaPuff")),
                          GestureDetector(
                            child:  Text(AppLocalizations.of(context)!
                                                .translate("getting_started") ??"Getting started",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic,
                                    fontFamily: "DynaPuff")),
                            onTap: () {
                              setState(() {
                                show = !show;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    show
                        ? Column(
                            children: [
                              Container(
                                height: 40,
                                width: 300,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigator.of(context).push(MaterialPageRoute(
                                    //     builder: (ctx) => Signup()));

                                    Navigator.of(context).push(
                                        PageRouteToScreen()
                                            .pushToSignupScreen());
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blue[400],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child:  Text(
                                    AppLocalizations.of(context)!
                                                .translate("sign_up") ??"Sign Up",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                   Text(AppLocalizations.of(context)!
                                                .translate("have_account") ??"I already have account."),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  GestureDetector(
                                    child:  Text(
                                      AppLocalizations.of(context)!
                                                .translate("login") ??"Login",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 15,
                                      ),
                                    ),
                                    onTap: () {
                                      // Navigator.of(context).push(MaterialPageRoute(
                                      //     builder: (ctx) => Login()));
                                      Navigator.of(context).push(
                                          PageRouteToScreen()
                                              .pushToLoginScreen());
                                    },
                                  )
                                ],
                              )
                            ],
                          )
                        : Container()
                  ])),
        ));
  }
}
