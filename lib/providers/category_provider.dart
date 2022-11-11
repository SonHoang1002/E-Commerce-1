import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testecommerce/models/product.dart';

class CategoryProvider with ChangeNotifier {
  late Product asiaDish;
  List<Product> asiaList = [];
  Future<int> setAsiaDish() async {
    List<Product> newList = [];
    QuerySnapshot<Object?> snapshot = await FirebaseFirestore.instance
        .collection("category")
        .doc("2n0DMzp0z2in1eLYBXHG")
        .collection("AsiaDish")
        .get();
    snapshot.docs.forEach(
      (element) {
        asiaDish = Product(
            image: element["image"],
            price: double.parse(element["price"]),
            name: element["category"],
            repo: int.parse(element["repo"]));
        newList.add(asiaDish);
      },
    );
    asiaList = newList;
    notifyListeners();
    return 1;
  }

  List<Product> getListAsia() {
    return asiaList;
  }

//East
  late Product eastDish;
  List<Product> eastList = [];
  Future<int> setEastDish() async {
    List<Product> newList = [];
    QuerySnapshot<Object?> snapshot = await FirebaseFirestore.instance
        .collection("category")
        .doc("2n0DMzp0z2in1eLYBXHG")
        .collection("EastDish")
        .get();
    snapshot.docs.forEach(
      (element) {
        // asiaDish = Product(
        //     image: element["image"],
        //     price: double.parse(element["price"]),
        //     name: element["category"]);
        newList.add(Product(
            image: element["image"],
            price: double.parse(element["price"]),
            name: element["category"],
            repo: int.parse(element["repo"])));
      },
    );
    eastList = newList;
    notifyListeners();
    return 0;
  }

  List<Product> getEastDish() {
    return eastList;
  }

//Snack
  late Product snack;
  List<Product> snackList = [];
  Future<int> setSnack() async {
    List<Product> newList = [];
    QuerySnapshot<Object?> snapshot = await FirebaseFirestore.instance
        .collection("category")
        .doc("2n0DMzp0z2in1eLYBXHG")
        .collection("Snack")
        .get();
    snapshot.docs.forEach(
      (element) {
        newList.add(Product(
            image: element["image"],
            price: double.parse(element["price"]),
            name: element["category"],
            repo: int.parse(element["repo"])));
      },
    );
    snackList = newList;
    notifyListeners();
    return 0;
  }

  List<Product> getSnack() {
    return snackList;
  }

//WaterDish

  late Product waterDish;
  List<Product> waterList = [];
  Future<int> setwaterDish() async {
    List<Product> newList = [];
    QuerySnapshot<Object?> snapshot = await FirebaseFirestore.instance
        .collection("category")
        .doc("2n0DMzp0z2in1eLYBXHG")
        .collection("WaterDish")
        .get();
    snapshot.docs.forEach(
      (element) {
        // asiaDish = Product(
        //     image: element["image"],
        //     price: double.parse(element["price"]),
        //     name: element["category"]);
        newList.add(Product(
            image: element["image"],
            price: double.parse(element["price"]),
            name: element["category"],
            repo: int.parse(element["repo"])));
      },
    );
    waterList = newList;
    notifyListeners();
    return 0;
  }

  List<Product> getWaterDish() {
    return waterList;
  }
}
