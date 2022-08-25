import 'package:flutter/material.dart';
import 'package:testecommerce/screen/login.dart';
import 'package:testecommerce/screen/signup.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool show = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                height: 320,
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/userlogo.jpg"),
                        fit: BoxFit.fill)),
              ),
              Container(
                height: 220,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text("Welcome ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            fontFamily: "DynaPuff")),
                    Text("Ready to shopping",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontStyle: FontStyle.italic,
                            fontFamily: "DynaPuff")),
                    GestureDetector(
                      child: Text("Getting started",
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
                          height: 45,
                          width: 300,
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (ctx) => Signup()));
                            },
                            color: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("I already have account."),
                            SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => Login()));
                              },
                            )
                          ],
                        )
                      ],
                    )
                  : Container()
            ])));
  }
}
