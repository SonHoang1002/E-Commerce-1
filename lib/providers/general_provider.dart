import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testecommerce/models/usermodel.dart';
import '../models/cartmodels.dart';
import '../models/product.dart';

class GeneralProvider with ChangeNotifier {
  GeneralProvider() {
    _isDark = false;
  }

  final String key = "theme";
  late bool _isDark;
  late SharedPreferences _themePreferences;
  ThemeDarkProvider() {
    _isDark = false;
    _loadThemeFromPrefs();
  }

  get isDark => _isDark;
  setTheme() {
    _isDark = !_isDark;
    _saveThemeToPrefs();
    notifyListeners();
  }

  _initThemePrefs() async {
    if (_themePreferences == null)
      _themePreferences = await SharedPreferences.getInstance();
  }

  _loadThemeFromPrefs() async {
    await _initThemePrefs();
    _isDark = _themePreferences.getBool(key) ?? true;
    notifyListeners();
  }

  _saveThemeToPrefs() async {
    await _initThemePrefs();
    _themePreferences.setBool(key, _isDark);
  }

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

///////////////////////////////////////////////////////////////////////////////////////////////////////////
  List<Product> searchList = [];
  List<Product> searchProductList(String query) {
    searchList = [];
    List<Product> searchFeatureList = featureProductList
        .where((element) =>
            element.name.toUpperCase().contains(query) ||
            element.name.toLowerCase().contains(query))
        .toList();
    List<Product> searchNewList = newProductList
        .where((element) =>
            element.name.toUpperCase().contains(query) ||
            element.name.toLowerCase().contains(query))
        .toList();
    List<Product> searchSnackList = snackList
        .where((element) =>
            element.name.toUpperCase().contains(query) ||
            element.name.toLowerCase().contains(query))
        .toList();
    List<Product> searchAsiaList = asiaList
        .where((element) =>
            element.name.toUpperCase().contains(query) ||
            element.name.toLowerCase().contains(query))
        .toList();
    List<Product> searchEuropeList = eastList
        .where((element) =>
            element.name.toUpperCase().contains(query) ||
            element.name.toLowerCase().contains(query))
        .toList();
    List<Product> searchWaterList = waterList
        .where((element) =>
            element.name.toUpperCase().contains(query) ||
            element.name.toLowerCase().contains(query))
        .toList();
    if (searchFeatureList.length > 0) {
      searchList.addAll(searchFeatureList);
    }
    if (searchNewList.length > 0) {
      searchList.addAll(searchNewList);
    }
    if (searchAsiaList.length > 0) {
      searchList.addAll(searchAsiaList);
    }
    if (searchEuropeList.length > 0) {
      searchList.addAll(searchEuropeList);
    }
    if (searchWaterList.length > 0) {
      searchList.addAll(searchWaterList);
    }
    if (searchSnackList.length > 0) {
      searchList.addAll(searchSnackList);
    }
    return searchList;
  }

  List<Product> get getSearchList => searchList;

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
    } else if ((index >= 0)) {
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
    total = 0;
    // total = double.parse((value * (1 - getPromo / 100)).toStringAsFixed(2));
    setPrice();
    total = double.parse(
        ((value + getShipping - getDiscount) * (1 - getPromo / 100))
            .toStringAsFixed(2));

    notifyListeners();
  }

  double get getTotal => total;

// subtotal

  late double price = 0;
  void setPrice() {
    price = 0;
    for (int i = 0; i < getCartModelLength; i++) {
      price += (getCartModel[i].quantity * getCartModel[i].price);
    }
    notifyListeners();
  }

  double get getPrice => price;

  double get getShipping => double.parse((getPrice * 0.15).toStringAsFixed(2));
  double get getDiscount => double.parse((getPrice * 0.1).toStringAsFixed(2));

  // promo
  late double promo = 0;
  void setPromo(double value) {
    promo = 0;
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

  late String email;
  setEmailFromLogin(String value) {
    email = value;
  }

  get getEmailFromLogin => email;
  late String userAddress;
  late String userName;
  late String userEmail;
  late String userPhone;
  late String userGender;
  late String userImage;

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
        userAddress = element["UserAddress"];
        userImage = element["UserImage"];
      }
    });
    notifyListeners();
    return 0;
  }

  get getUserModelName => userName;
  get getUserModelPhone => userPhone;
  get getUserModelEmail => userEmail;
  get getUserModelGender => userGender;
  get getUserModelAddress => userAddress;
  get getUserModelImage => userImage;

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
            name: element["category"]);
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
            name: element["category"]));
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
            name: element["category"]));
      },
    );
    snackList = newList;
    notifyListeners();
    return 0;
  }

  List<Product> getSnack() {
    return snackList;
  }

//Drink
late Product drink;
  List<Product> drinkList = [];
  Future<int> setDrink() async {
   List<Product> newList = [];
    QuerySnapshot<Object?> snapshot = await FirebaseFirestore.instance
        .collection("category")
        .doc("2n0DMzp0z2in1eLYBXHG")
        .collection("Drink")
        .get();
    snapshot.docs.forEach(
      (element) {
        newList.add(Product(
            image: element["image"],
            price: double.parse(element["price"]),
            name: element["category"]));
      },
    );
    drinkList = newList;
    notifyListeners();
    return 0;
  }

  List<Product> getListDrink() {
    return drinkList;
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
            name: element["category"]));
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
