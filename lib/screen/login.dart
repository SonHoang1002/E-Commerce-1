import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testecommerce/screen/homepage.dart';
import 'package:testecommerce/screen/signup.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

String p =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
RegExp regExp = RegExp(p);

class _Login extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void validation() {
    if (_formKey.currentState!.validate()) {
      print("email: $email and password: $password");
      try {
        final result = FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email!, password: password!);
            Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (ctx) => HomePage()));
      } on PlatformException catch (e) {
        print(e.message.toString());
      }
    } else {
      print("login no");
    }
  }

  var obscureText = true;
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back),onPressed:(){
           Navigator.of(context).pop();
        },),
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
                    SizedBox(height: 40,),
                    Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                      validator: ((value) {
                        if (value == "") {
                          return "Email is empty";
                        } else if (!regExp.hasMatch(value!)) {
                          return "invalide format";
                        }
                      }),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Email",
                          labelText: "Email",
                          hintStyle: TextStyle(color: Colors.black)),
                    ),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      validator: ((value) {
                        if (value == "") {
                          return "Password is empty";
                        } else if (value!.length < 8) {
                          return "Password short less 8";
                        }
                      }),
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
                            validation();
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
}
