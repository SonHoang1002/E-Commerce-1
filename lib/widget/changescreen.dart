import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testecommerce/screen/signup.dart';

class ChangeScreen extends StatelessWidget {
  final Function onTap;
  final String account;
  final String name;
  ChangeScreen(
      {required this.name, required this.onTap, required this.account});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          account,
          style: TextStyle(color: Colors.black),
        ),
        SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: () {
            onTap;
          },
          child: Text(name, style: TextStyle(color: Colors.blue, fontSize: 15)),
        ),
      ],
    );
  }
}
