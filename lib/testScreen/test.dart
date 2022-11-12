import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:provider/provider.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import 'package:talkjs_flutter/talkjs_flutter.dart';
import 'package:testecommerce/gradient/gradient.dart';
import 'package:testecommerce/models/cartmodels.dart';
import 'package:testecommerce/providers/general_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../addition/pageRoute.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

List<CartModel> list = [
  CartModel(
      name: "a11",
      price: 23.4,
      img:
          "https://upload.jpg",
      quantity: 65,
      repo: 98),
  CartModel(name: "a111", price: 23.4, img: "abc.jpg", quantity: 6, repo: 98)
];

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
                  // setCustomerAndTotalRevenue();
                  updateRepo(list);
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
    String money = (double.parse("23.6") + 45.76).toString();

    await FirebaseFirestore.instance
        .collection("TotalRevenue")
        .doc("9EC0nIWg6Da6RaYG5cm8")
        .collection("tr")
        .doc("W5hd5BaRmYrhNAySeeq3")
        .update({"totalMoney": money});
    print("add bill to totalRevenue ok");
  }

  Future<void> updateRepo(List<CartModel> cartModelListToUpdateRepo) async {
    for (int i = 0; i < cartModelListToUpdateRepo.length; i++) {
      _ConnectAndUpdateCategoryCollection(
          "Drink", cartModelListToUpdateRepo[i]);
      _ConnectAndUpdateCategoryCollection(
          "AsiaDish", cartModelListToUpdateRepo[i]);
      _ConnectAndUpdateCategoryCollection(
          "Snack", cartModelListToUpdateRepo[i]);
      _ConnectAndUpdateCategoryCollection(
          "EastDish", cartModelListToUpdateRepo[i]);
      _ConnectAndUpdateCategoryCollection(
          "WaterDish", cartModelListToUpdateRepo[i]);
      _ConnectAndUpdateProductsCollection(
          "newachives", cartModelListToUpdateRepo[i]);
      _ConnectAndUpdateProductsCollection(
          "featuredproduct", cartModelListToUpdateRepo[i]);
    }
  }

  Future<void> _ConnectAndUpdateCategoryCollection(
      String collectionCategory, CartModel cartModel) async {
    QuerySnapshot<Object?> snapshot = await FirebaseFirestore.instance
        .collection("category")
        .doc("2n0DMzp0z2in1eLYBXHG")
        .collection(collectionCategory)
        .get();
    snapshot.docs.forEach((element) {
      if (element["category"] == cartModel.name) {
        FirebaseFirestore.instance
            .collection("category")
            .doc("2n0DMzp0z2in1eLYBXHG")
            .collection(collectionCategory)
            .doc(element.id)
            .update({
          "category": "${cartModel.name}",
          "image": "${cartModel.img}",
          "price": "${cartModel.price}",
          "repo": "${cartModel.repo - cartModel.quantity}"
        });
        print("${collectionCategory} update ${cartModel.name}");
      }
    });
  }

  Future<void> _ConnectAndUpdateProductsCollection(
      String collectionProducts, CartModel cartModel) async {
    QuerySnapshot<Object?> snapshot = await FirebaseFirestore.instance
        .collection("products")
        .doc("Yr4cg3K870i11VWoxx5q")
        .collection(collectionProducts)
        .get();
    snapshot.docs.forEach((element) {
      if (element["category"] == cartModel.name) {
        FirebaseFirestore.instance
            .collection("products")
            .doc("Yr4cg3K870i11VWoxx5q")
            .collection(collectionProducts)
            .doc(element.id)
            .update({
          "category": "${cartModel.name}",
          "image": "${cartModel.img}",
          "price": "${cartModel.price}",
          "repo": "${cartModel.repo - cartModel.quantity}"
        });
        print("${collectionProducts} update ${cartModel.name}");
      }
    });
  }
}
