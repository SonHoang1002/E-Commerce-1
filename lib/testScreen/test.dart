import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:provider/provider.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import 'package:talkjs_flutter/talkjs_flutter.dart';
import 'package:testecommerce/gradient/gradient.dart';
import 'package:testecommerce/providers/general_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../addition/pageRoute.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

late GeneralProvider generalProvider;

class _TestScreenState extends State<TestScreen> {
  bool chatBoxVisible = false;
  @override
  void initState() {
    super.initState();
    // generalProvider = Provider.of<GeneralProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TalkJS Demo',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('TalkJS Demo'),
          ),
          body: Container(
            child: Center(
              child: ElevatedButton(
                child: Text("Click"),
                onPressed: () {
                  setCustomerAndTotalRevenue();
                },
              ),
            ),
          )),
    );
  }

  Future<void> setCustomerAndTotalRevenue() async {
    await FirebaseFirestore.instance
        .collection("TotalRevenue")
        .doc("9EC0nIWg6Da6RaYG5cm8")
        .collection("bill")
        .add({
      "idUser": "123",
      "productList": ["a", "b", "c"],
      "money": "123"
    });
    print("add user to totalRevenue ok");
    String money = (double.parse("23.6") +
            45.76)
        .toString();

    await FirebaseFirestore.instance
        .collection("TotalRevenue")
        .doc("9EC0nIWg6Da6RaYG5cm8")
        .collection("tr")
        .doc("W5hd5BaRmYrhNAySeeq3")
        .update({"totalMoney": money});
    print("add bill to totalRevenue ok");
  }
}
