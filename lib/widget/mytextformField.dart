import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testecommerce/screen/signup.dart';

class ChangeScreen extends StatelessWidget {
  final Function validator;
  final bool obscureText;
  final String name;
  final Function onTap;
  ChangeScreen(
      {required this.onTap,
      required this.name,
      required this.validator,
      required this.obscureText});
  @override
  Widget build(BuildContext context) {
    return Center();
  }
}
