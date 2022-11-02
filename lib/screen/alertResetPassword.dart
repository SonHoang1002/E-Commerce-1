import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/addition/pageRoute.dart';
import 'package:testecommerce/providers/general_provider.dart';
import 'package:http/http.dart' as http;

class AlertResetPassword extends StatefulWidget {
  const AlertResetPassword({super.key});

  @override
  State<AlertResetPassword> createState() => _AlertResetPasswordState();
}

late GeneralProvider generalProvider;

class _AlertResetPasswordState extends State<AlertResetPassword> {
  int minute = 1;
  String zero = "";
  int seconds = 10;
  late Timer timer;
  bool isErrorCode = false;
  bool isExpired = false;
  TextEditingController resetController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buildTimeOutForResetPassword();
  }

  @override
  Widget build(BuildContext context) {
    generalProvider = Provider.of<GeneralProvider>(context, listen: false);
    FocusManager.instance.primaryFocus?.focusInDirection;
    send();

    return Scaffold(
      appBar: AppBar(
          title: Text("Reset Password"),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.push(context, PageRouteToScreen().pushToLoginScreen());
            },
          )),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
        child: Column(children: [
          Text(
            "Please enter reset number from your email",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "${minute}:${zero}${seconds}",
            style: TextStyle(fontSize: 25),
          ),
          TextFormField(
            controller: resetController,
            autofocus: true,
            readOnly: isExpired,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 6,
          ),
          // ElevatedButton(
          //     onPressed: () {
          //       buildTimeOutForResetPassword();
          //     },
          //     child: Text("Click")),
          Center(
            child: ElevatedButton(
                onPressed: () {
                  if (isExpired) {
                    setState(() {
                      minute = 1;
                      seconds = 10;
                    });
                    send();
                    setState(() {
                      isExpired = false;
                    });
                    buildTimeOutForResetPassword();
                  } else {
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
                  }
                },
                child: Text(isExpired ? "RESEND" : "CHECK")),
          )
        ]),
      ),
    );
  }

  void buildTimeOutForResetPassword() {
    const perSecond = Duration(seconds: 1);
    timer = Timer.periodic(perSecond, (timer) {
      if (minute == 0 && seconds == 0) {
        setState(() {
          timer.cancel();
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("the verification code has expired")));
        setState(() {
          isExpired = true;
        });
        generalProvider.setResetCode("");
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
                "to_email": "kingmountain117@gmail.com",
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
}
