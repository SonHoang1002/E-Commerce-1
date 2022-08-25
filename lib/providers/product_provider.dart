import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/cartmodels.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  late Product featureProduct;
  List<Product> featureProductList = [];
  Future<int> setFeatureProduct() async {
    List<Product> newList = [];
    QuerySnapshot<Object?> snapshot = await FirebaseFirestore.instance
        .collection("products")
        .doc("Yr4cg3K870i11VWoxx5q")
        .collection("featuredproduct")
        .get();
    snapshot.docs.forEach(
      (element) {
        newList.add(Product(
            image: element["image"],
            price: double.parse(element["price"]),
            name: element["category"]));
      },
    );
    featureProductList = newList;
    notifyListeners();
    return 0;
  }

  List<Product> getFeatureProduct() {
    return featureProductList;
  }

  //new product

  late Product newProduct;
  List<Product> newProductList = [];
  Future<int> setNewProduct() async {
    List<Product> newList = [];
    QuerySnapshot<Object?> snapshot = await FirebaseFirestore.instance
        .collection("products")
        .doc("Yr4cg3K870i11VWoxx5q")
        .collection("newachives")
        .get();
    snapshot.docs.forEach(
      (element) {
        newList.add(Product(
            image: element["image"],
            price: double.parse(element["price"]),
            name: element["category"]));
      },
    );
    newProductList = newList;
    notifyListeners();
    return 0;
  }

  List<Product> getNewProduct() {
    return newProductList;
  }

  //cart
  late CartModel cartModel;
  List<CartModel> cartModelList = [];
  void setCartModel(String name, double price, int quantity, String img) {
    cartModelList
        .add(CartModel(name: name, price: price, img: img, quantity: quantity));

    notifyListeners();
  }

  void setCartModelList(List<CartModel> newList) {
    cartModelList = newList;
    notifyListeners();
  }

  List<CartModel> get getCartmodel => List.from(cartModelList);
  int get getCartmodelLength => cartModelList.length;

  // total
  late double total;
  void setTotal(double value) {
    total = double.parse(value.toStringAsFixed(2));
    notifyListeners();
  }

  double get getTotal => total;

  // notification
  List<String> notiList = [];

  void setNotiList(String value) {
    notiList.add(value);
  }

  int get getNotiListlength => notiList.length;
}
