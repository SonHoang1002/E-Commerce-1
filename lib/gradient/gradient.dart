import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DecorationBackGround {
  BoxDecoration buildDecoraion() {
    return BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.red, Colors.blue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter));
  }
}
