
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class WarningFromName extends StatelessWidget {
  final List<String> listOfName;

  WarningFromName({super.key, required this.listOfName});
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
