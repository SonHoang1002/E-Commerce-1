
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/addition/pageRoute.dart';
import 'package:testecommerce/gradient/gradient.dart';
import 'package:testecommerce/providers/general_provider.dart';


class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
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
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.of(context)
            //     .push(MaterialPageRoute(builder: (_) => Login()));
            Navigator.of(context).push(PageRouteToScreen().pushToLoginScreen());
          },
        ),
      ),
      body: Container(
        decoration: DecorationBackGround().buildDecoration(),
        child: Column(
          children: [
            isLoading
                ? Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: const Center(child: CircularProgressIndicator()))
                : Container(
                    height: 10,
                  ),
            Form(
              key: _formKey,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    Container(
                      height: 300,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            "Enter New Password",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                            controller: password,
                            obscureText: obscureText,
                            decoration: const InputDecoration(
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
                            decoration: const InputDecoration(
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
                                  backgroundColor: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: const Text(
                                  "SEND",
                                  style:  TextStyle(
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
              title: const Wrap(
                children: [
                  Icon(
                    Icons.warning,
                    color: Colors.yellow,
                  ),
                  SizedBox(width: 10),
                  Text("Warning"),
                ],
              ),
              content: const Text("Password has least 8 characters !!"),
              actions: [
                ElevatedButton(
                    onPressed: (() => Navigator.of(context).pop()),
                    child: const Text("OK"))
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
      // ignore: use_build_context_synchronously
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
              title: const Wrap(
                children: [
                  Icon(Icons.error),
                  SizedBox(width: 10),
                  Text("Message"),
                ],
              ),
              content: const Text("Unsuccessfull Confirm!!"),
              actions: [
                ElevatedButton(
                    onPressed: (() => Navigator.of(context).pop()),
                    child: const Text("OK"))
              ],
            );
          });
      return;
    }
  }
}
