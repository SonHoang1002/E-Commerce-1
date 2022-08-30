import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testecommerce/screen/signup.dart';

class MyButton extends StatelessWidget {
  final Function function;
  final String name;
  MyButton({required this.name, required this.function});
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 45,
        width: double.infinity,
        child: RaisedButton(
          onPressed: ()=>function,
          color: Colors.grey,
          child: Text(name),
        ));
  }
}
