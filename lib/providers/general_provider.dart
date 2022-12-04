import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testecommerce/models/contact_user.dart';
import 'package:testecommerce/models/usermodel.dart';
import 'package:testecommerce/screen/home_page.dart';
import 'package:testecommerce/screen/profile.dart';
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
            name: element["category"],
            repo: int.parse(element["repo"])));
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

  List<String> listNoti = [];
  addNotiList(String value) {
    listNoti.add(value);
    notifyListeners();
  }

  removeNotiList() {
    listNoti = [];
    notifyListeners();
  }

  List<String> get getNotiList => listNoti;

  List<String> notiList = [];

  void setNotiList(String value) {
    notiList.add(value);
    notifyListeners();
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
    List<Product> searchDrinkList = drinkList
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
    if (searchDrinkList.length > 0) {
      searchList.addAll(searchDrinkList);
    }
    // print("searchList length: ${searchList.length}");
    notifyListeners();
    return searchList;
  }

  List<Product> get getSearchList => searchList;

  late List<Product> searchListFromQuery = [];
  late Product productWithQuery;
  Future<int> searchProductListEqualQuery(String query) async {
    searchListFromQuery = [];
    List<Product> featureProductWithQuery =
        featureProductList.where((element) => element.name == query).toList();
    List<Product> waterProductWithQuery =
        waterList.where((element) => element.name == query).toList();
    List<Product> newProductWithQuery =
        newProductList.where((element) => element.name == query).toList();
    List<Product> snackProductWithQuery =
        snackList.where((element) => element.name == query).toList();
    List<Product> asiaProductWithQuery =
        asiaList.where((element) => element.name == query).toList();
    List<Product> eastProductWithQuery =
        eastList.where((element) => element.name == query).toList();
    List<Product> drinkProductWithQuery =
        drinkList.where((element) => element.name == query).toList();

    if (featureProductWithQuery.length > 0) {
      if (!checkHasData(searchListFromQuery, featureProductWithQuery)) {
        searchListFromQuery.addAll(featureProductWithQuery);
      }
    }
    if (newProductWithQuery.length > 0) {
      if (!checkHasData(searchListFromQuery, newProductWithQuery)) {
        searchListFromQuery.addAll(newProductWithQuery);
      }
    }
    if (asiaProductWithQuery.length > 0) {
      if (!checkHasData(searchListFromQuery, asiaProductWithQuery)) {
        searchListFromQuery.addAll(asiaProductWithQuery);
      }
    }
    if (eastProductWithQuery.length > 0) {
      if (!checkHasData(searchListFromQuery, eastProductWithQuery)) {
        searchListFromQuery.addAll(eastProductWithQuery);
      }
    }
    if (waterProductWithQuery.length > 0) {
      if (!checkHasData(searchListFromQuery, waterProductWithQuery)) {
        searchListFromQuery.addAll(waterProductWithQuery);
      }
    }
    if (snackProductWithQuery.length > 0) {
      if (!checkHasData(searchListFromQuery, snackProductWithQuery)) {
        searchListFromQuery.addAll(snackProductWithQuery);
      }
    }
    if (drinkProductWithQuery.length > 0) {
      if (!checkHasData(searchListFromQuery, drinkProductWithQuery)) {
        searchListFromQuery.addAll(drinkProductWithQuery);
      }
    }
    notifyListeners();
    return 1;
  }

  bool checkHasData(List<Product> list, List<Product> subList) {
    bool check = false;
    for (int i = 0; i < subList.length; i++) {
      if (list.contains(subList[i])) {
        check = true;
        return check;
      }
    }
    return check;
  }

  List<Product> get getSearchListFromQuery => searchListFromQuery;

  Product get getSearchProductFromQuery => productWithQuery;

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
            name: element["category"],
            repo: int.parse(element["repo"])));
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
  void setAddCartModel(
      String name, double price, int quantity, String img, int repo) {
    int? index;
    int? oldQuantity;
    int? newQuantity;
    for (int i = 0; i < getCartModelListLength; i++) {
      if (name == getCartModelList[i].name) {
        index = i;
        oldQuantity = getCartModelList[i].quantity;
      }
    }
    if (index == null) {
      cartModelList.add(CartModel(
          name: name, price: price, img: img, quantity: quantity, repo: repo));
    } else if ((index >= 0)) {
      cartModelList.remove(getCartModelList[index]);
      newQuantity = oldQuantity! + quantity;
      cartModelList.insert(
          index,
          CartModel(
              name: name,
              price: price,
              img: img,
              quantity: newQuantity,
              repo: repo));
    }

    notifyListeners();
  }

  void setCartModelList(List<CartModel> newList) {
    cartModelList = newList;
    // print(cartModelList);
    notifyListeners();
  }

  List<CartModel> get getCartModelList => List.from(cartModelList);
  int get getCartModelListLength => cartModelList.length;

  late List<String> cartModelListName;
  Future<int> setCartModelListName() async {
    List<String> list = [];
    for (int i = 0; i < getCartModelListLength; i++) {
      list.add(getCartModelList[i].name);
    }
    cartModelListName = list;
    notifyListeners();
    return 1;
  }

  List<String> get getCartModelListListName => cartModelListName;

  // total
  late double total = 0;
  void setTotal(double value) {
    total = 0;
    // total = double.parse((value * (1 - getPromo / 100)).toStringAsFixed(2));
    setPrice();
    total = double.parse(
        ((value + getShipping - getDiscount) * (1 - getPromo / 100))
            .toStringAsFixed(2));
    if (total == 0) resetPromo();
    notifyListeners();
  }

  double get getTotal => total;

// subtotal

  late double price = 0;
  void setPrice() {
    price = 0;
    for (int i = 0; i < getCartModelListLength; i++) {
      price += (getCartModelList[i].quantity * getCartModelList[i].price);
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

  void resetPromo() {
    promo = 0;
    notifyListeners();
  }

  double get getPromo => promo;

  late String email;
  setEmailFromLogin(String? value) {
    email = "";
    email = value!;
    notifyListeners();
  }

  get getEmailFromLogin => email;

  late String userAddress;
  late String userName;
  late String userEmail;
  late String userPhone;
  late String userGender;
  late String userImage;
  late String userIdMessenger;

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
        userIdMessenger = element["Id_messenger"];
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
  String get getUserModelIdMessenger => userIdMessenger;

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
            name: element["category"],
            repo: int.parse(element["repo"])));
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

////////////////////////////////////////////////////////ADMIN////////////////////////////////

  int numberOfAllProduct = 0;
  List<Product> allProduct = [];
  Future<int> setNumberOfAllProduct() async {
    await setAsiaDish();
    await setDrink();
    await setSnack();
    await setwaterDish();
    await setEastDish();
    await setFeatureProduct();
    await setNewProduct();
    allProduct = getAllProduct;

    numberOfAllProduct = getListAsia().length +
        getListDrink().length +
        getSnack().length +
        getWaterDish().length +
        getEastDish().length +
        getFeatureProduct().length +
        newProductList.length;
    notifyListeners();
    return 0;
  }

  List<Product> get getAllProduct => searchProductListForAdmin("");

  // Future<int> setAllProduct(String value) async {
  //   allProduct = searchProductList(value);
  //   notifyListeners();
  //   return 1;
  // }

  int get getAllNumberProduct => numberOfAllProduct;

  List<Product> searchProductListForAdmin(String query) {
    List<Product> list = [];
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
    List<Product> searchDrinkList = drinkList
        .where((element) =>
            element.name.toUpperCase().contains(query) ||
            element.name.toLowerCase().contains(query))
        .toList();
    if (searchFeatureList.length > 0) {
      list.addAll(searchFeatureList);
    }
    if (searchNewList.length > 0) {
      list.addAll(searchNewList);
    }
    if (searchAsiaList.length > 0) {
      list.addAll(searchAsiaList);
    }
    if (searchEuropeList.length > 0) {
      list.addAll(searchEuropeList);
    }
    if (searchWaterList.length > 0) {
      list.addAll(searchWaterList);
    }
    if (searchSnackList.length > 0) {
      list.addAll(searchSnackList);
    }
    if (searchDrinkList.length > 0) {
      list.addAll(searchDrinkList);
    }
    // print("list length: ${list.length}");
    // notifyListeners();
    return list;
  }

  // check admin or user
  bool isAdmin = false;
  setAdmin(bool value) {
    isAdmin = value;
    notifyListeners();
  }

  get getIsAdmin => isAdmin;

// save sharedpreferences
  List<String> listIdMessenger = [];

  late String idMessenger;
  setListId(String id) {
    idMessenger = id;
    listIdMessenger.add(idMessenger);
    notifyListeners();
  }

  get getIdMessenger => idMessenger;
  get getIdMessengerList => listIdMessenger;

// get Contact User
  late ContactMessengerModel contactUser;
  setContactUser(String id, String name, String email) async {
    contactUser = ContactMessengerModel(id: id, name: name, email: email);
    notifyListeners();
  }

  ContactMessengerModel get getContactUser => contactUser;

  List<ContactMessengerModel> listContactMessengerModel = [];
  setNameAndEmailFromId(i) async {
    QuerySnapshot<Object?> snapshot =
        await FirebaseFirestore.instance.collection("Model").get();
    listIdMessenger.forEach((id) {
      snapshot.docs.forEach((element) {
        if (element["Id_messenger"] == id) {
          listContactMessengerModel.add(ContactMessengerModel(
              id: id, name: element["UserName"], email: element["UserEmail"]));
        }
      });
    });
  }

  List<String> nameProductList = [];
  Future<int> setNameProductList() async {
    for (int i = 0; i < asiaList.length; i++) {
      nameProductList.add(asiaList[i].name);
    }
    for (int i = 0; i < eastList.length; i++) {
      nameProductList.add(eastList[i].name);
    }
    for (int i = 0; i < drinkList.length; i++) {
      nameProductList.add(drinkList[i].name);
    }
    for (int i = 0; i < snackList.length; i++) {
      nameProductList.add(snackList[i].name);
    }
    for (int i = 0; i < newProductList.length; i++) {
      nameProductList.add(newProductList[i].name);
    }
    for (int i = 0; i < featureProductList.length; i++) {
      nameProductList.add(featureProductList[i].name);
    }
    for (int i = 0; i < waterList.length; i++) {
      nameProductList.add(waterList[i].name);
    }
    notifyListeners();
    return 1;
  }

  get getNameProductList => nameProductList;

// set and get Ads

  late BannerAd ad;
  Future<int> setAds(BannerAd ads) async {
    ad = ads;
    notifyListeners();
    return 1;
  }

  get getAds => ad;

// set and get reset code
  String resetCode = "";
  Future<int> setResetCode(String value) async {
    resetCode = value;
    notifyListeners();
    return 0;
  }

  get getResetCode => resetCode;

  String verifyCode = "";
  Future<int> setVerifyCode(String value) async {
    if (verifyCode == "") {
      verifyCode = value;
    }
    notifyListeners();
    return 1;
  }

  void reSetVerifyCode() {
    verifyCode = "";
    notifyListeners();
  }

  get getVerifyCode => verifyCode;

  // fix bug pop to home page from notification page
  bool fromHomePage = false;
  Future<int> setFromHomePage(bool value) async {
    fromHomePage = true;
    notifyListeners();
    return 1;
  }

  bool get getFromHomePage => fromHomePage;

// total revenue
  late String totalRevenue;
  Future<int> setTotalRenenue() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("TotalRevenue")
        .doc("9EC0nIWg6Da6RaYG5cm8")
        .collection("tr")
        .doc("W5hd5BaRmYrhNAySeeq3")
        .get();
    snapshot.data()!.forEach((key, value) {
      totalRevenue = value;
    });
    print("totalRevenue in generalProvider: ${totalRevenue}");
    notifyListeners();
    return 0;
  }

  // Future<int> setTotalRenenueWith(String value) async {
  //   totalRevenue = value;
  //   notifyListeners();
  //   return 0;
  // }

  String get getTotalRenenue => totalRevenue;

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

  late double totalCost;
  Future<int> setTotalCost() async {
    totalCost = 0;
    List<Product> list = searchProductList("");
    list.forEach((element) {
      totalCost += (element.price * double.parse(element.repo.toString()));
    });
    notifyListeners();
    return 0;
  }

  double get getTotalCost => double.parse(totalCost.toStringAsFixed(3));

  late bool isCartProductNumberUpdate = false;
  setIsUpdateForCartProduct(bool value) {
    isCartProductNumberUpdate = true;
    notifyListeners();
  }

  get getIsUpdateForCartProduct => isCartProductNumberUpdate;

  List<String> listMoneyIcon = ["₫", "\$", "₤"];
  String moneyIconName = "\$";
  void setMoneyIcon(int index) {
    if (index > 4 && index < 0) {
      moneyIconName = "\$";
    }
    moneyIconName = listMoneyIcon[index - 1];
    notifyListeners();
  }

  String get getMoneyIconName => moneyIconName;
}


// QuerySnapshot<Object?> snapshot = await FirebaseFirestore.instance
//           .collection("products")
//           .doc("Yr4cg3K870i11VWoxx5q")
//           .collection("featuredproduct")
//           .get();
//       snapshot.docs.forEach((element) {
//         if (element["category"] == widget.name) {
//           FirebaseFirestore.instance
//               .collection("products")
//               .doc("Yr4cg3K870i11VWoxx5q")
//               .collection("featuredproduct")
//               .doc(element.id)
//               .update({
//             "category": nameController.text.trim(),
//             "image": widget.img,
//             "price": priceController.text.trim()
//           });
//           print("featuredproduct update succesfully");
//         }
//       });