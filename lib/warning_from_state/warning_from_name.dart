
import 'package:flutter/material.dart';

class WarningFromName extends StatelessWidget {
  final List<String> listOfName;

  WarningFromName({Key? key, required this.listOfName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Warning From Name")),
      body: Center(
        child: Text("${listOfName}"),
      ),
    );
  }
}
