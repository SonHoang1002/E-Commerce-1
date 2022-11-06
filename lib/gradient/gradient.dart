import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DecorationBackGround {
  BoxDecoration buildDecoration() {
    return BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.greenAccent.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter));
  }
}
