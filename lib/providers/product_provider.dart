import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/models/usermodel.dart';

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
    int? index;
    int? oldQuantity;
    int? newQuantity;
    for (int i = 0; i < getCartModelLength; i++) {
      if (name == getCartModel[i].name) {
        index = i;
        oldQuantity = getCartModel[i].quantity;
      }
    }
    if (index == null) {
      cartModelList.add(
          CartModel(name: name, price: price, img: img, quantity: quantity));
    }else if ((index >= 0)) {
      cartModelList.remove(getCartModel[index]);
      newQuantity = oldQuantity! + quantity;
      cartModelList.insert(index,
          CartModel(name: name, price: price, img: img, quantity: newQuantity));
    }

    notifyListeners();
  }

  void setCartModelList(List<CartModel> newList) {
    cartModelList = newList;
    notifyListeners();
  }

  List<CartModel> get getCartModel => List.from(cartModelList);
  int get getCartModelLength => cartModelList.length;

  // total
  late double total = 0;
  void setTotal(double value) {
    total = double.parse((value * (1 - getPromo / 100)).toStringAsFixed(2));
    notifyListeners();
  }

  double get getTotal => total;

  // promo
  late double promo = 0;
  void setPromo(double value) {
    promo = value;
    notifyListeners();
  }

  double get getPromo => promo;
  // notification
  List<String> notiList = [];

  void setNotiList(String value) {
    notiList.add(value);
  }

  void removeList(value) {
    for (int i = 0; i < notiList.length; i++) {
      if (notiList[i] == value) {
        notiList.remove(value);
        print("remove item in NotiList succesfully");
      }
    }
  }

  int get getNotiListlength => notiList.length;

  //data form login screen
  late String email;
  setEmailFromLogin(String value) {
    email = value;
  }

  get getEmailFromLogin => email;

  late String userName;
  late String userEmail;
  late String userPhone;
  late String userGender;

  // late List<UserModel> listUserModel;
  Future<int> setUserModel() async {
    String email = getEmailFromLogin;
    QuerySnapshot<Object?> snapshot =
        await FirebaseFirestore.instance.collection("User").get();
    snapshot.docs.forEach((element) {
      if (element["UserEmail"] == email) {
        userName = element["UserName"];
        userEmail = email;
        userPhone = element["UserPhone"];
        userGender = element["UserGender"];
      }
    });
    notifyListeners();
    return 0;
  }

  get getUserModelName => userName;
  get getUserModelPhone => userPhone;
  get getUserModelEmail => userEmail;
  get getUserModelGender => userGender;

  // late UserModel userModel;
  // late List<UserModel> listUserModel;
  // Future<int> setUserModel() async {
  //   // String email = getEmailFromLogin;
  //    QuerySnapshot<Object?> snapshot = await FirebaseFirestore.instance
  //       .collection("products")
  //       .doc("Yr4cg3K870i11VWoxx5q")
  //       .collection("DemoUser")
  //       .get();
  //   snapshot.docs.forEach((element) {
  //     if (element["UserEmail"] == "a@gmail.com") {
  //       userModel = UserModel(
  //           userName: element["UserName"],
  //           userId: element["UserId"],
  //           userEmail: email,
  //           userGender: element["UserGender"],
  //           userPhone: element["UserPhone"]);
  //     }
  //     listUserModel.add(userModel);
  //   });
  //   notifyListeners();
  //   return 0;
  //
  // get getUserModel => userModel;
  // get getUserModelName => userModel.userName;
  // get getListUserModel => listUserModel;
}
