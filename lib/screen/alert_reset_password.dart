import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/addition/pageRoute.dart';
import 'package:testecommerce/gradient/gradient.dart';
import 'package:testecommerce/providers/general_provider.dart';
import 'package:http/http.dart' as http;
 
 

// ignore: must_be_immutable
class AlertResetPassword extends StatefulWidget { 
  AlertResetPassword({Key? key,  required this.email}): super(key: key);
  String email;
  @override
  State<AlertResetPassword> createState() => _AlertResetPasswordState();
}

late GeneralProvider generalProvider;

class _AlertResetPasswordState extends State<AlertResetPassword> {
  int minute = 1;
  String zero = "";
  int seconds = 59;
  late Timer timer;
  bool isErrorCode = false;
  bool isExpired = false;
  TextEditingController resetController = TextEditingController();
  bool isBegin = true;
  @override
  void initState() {
    super.initState();
    generalProvider = Provider.of<GeneralProvider>(context, listen: false);
    // buildTimeOutForResetPassword();
    send();
  }

  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.focusInDirection;
    if (isBegin) {
      buildTimeOutForResetPassword();
      // generalProvider.setEmailFromLogin(widget.email);
      setState(() {
        isBegin = false;
      });
    } else {}

    return Scaffold(
      appBar: AppBar(
          title: const Text("Reset Password"),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.push(context, PageRouteToScreen().pushToLoginScreen());
            },
          )),
      body: Container(
        decoration: DecorationBackGround().buildDecoration(),
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: Column(children: [
            const Text(
              "Please enter reset number from your email",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "${minute}:${zero}${seconds}",
              style: const TextStyle(fontSize: 25),
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
            //     child: const Text("Click")),
            Center(
              child: ElevatedButton(
                  onPressed: () async {
                    if (isExpired) {
                      generalProvider.setResetCode("");
                      send();
                      setState(() {
                        minute = 1;
                        seconds = 59;
                      });
                      setState(() {
                        isExpired = false;
                        isBegin = true;
                      });
                      buildTimeOutForResetPassword();
                    } else {
                      if (resetController.text.trim().length != 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Reset code must has 6 chracters")));
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
                            const SnackBar(
                                content: const Text("Invalid Code")));
                        return;
                      }
                    }
                  },
                  child: Text(isExpired ? "RESEND" : "CHECK")),
            )
          ]),
        ),
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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: const Text("the verification code has expired")));
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
                "to_email": "${widget.email}",
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
