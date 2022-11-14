import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/addition/pageRoute.dart';
import 'package:testecommerce/models/contact_user.dart';
import 'package:testecommerce/models/usermodel.dart';
import 'package:testecommerce/providers/category_provider.dart';
import 'package:testecommerce/providers/product_provider.dart';
import 'package:testecommerce/providers/theme_provider.dart';
import 'package:testecommerce/screen/about.dart';
import 'package:testecommerce/screen/admin/singleProductAdmin.dart';
import 'package:testecommerce/screen/cartscreen.dart';
import 'package:testecommerce/screen/detailscreen.dart';
import 'package:testecommerce/testScreen/test.dart';
import 'package:testecommerce/widget/notificationButton.dart';
import '../../addition/timer.dart';
import '../../widget/listproduct.dart';
import 'package:testecommerce/screen/login.dart';
import '../../widget/listproduct.dart';
import 'package:testecommerce/screen/profile.dart';
import '../../addition/search.dart';
import '../../widget/cartsingleproduct.dart';

import '../../providers/general_provider.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:badges/badges.dart';
import '../../models/product.dart';
import '../../widget/singleproduct.dart';
import 'package:intl/intl.dart';

import '../contact_messenger.dart';

class HomeAdmin extends StatefulWidget {
  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

// var asiaDish;
// var eastDish;
// var Snack;
// var waterDish;

class _HomeAdminState extends State<HomeAdmin> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final GlobalKey<State<Tooltip>> keyTooltip = GlobalKey<State<Tooltip>>();
  late GeneralProvider generalProvider;

  TextEditingController nameController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController repoController = TextEditingController();

  late List<Product> listFeature = [];
  late List<Product> listNew = [];

  late List<Product> listAsia = [];
  late List<Product> listEast = [];
  late List<Product> listSnack = [];
  late List<Product> listWater = [];
  late List<Product> listDrink = [];

  // String? name = "";
  // bool isLoaded = false;

  // bool hasSearchWord = false;
  // bool showResultWord = false;
  String category = "";

  List<String> list = [
    'Eastern Food',
    'Asia Food',
    'Water Food',
    'Drink',
    'Snack Food',
    'Feature Food'
  ];
  String dropdownValue = 'Eastern Food';
  bool hasSearchWord = false;

  @override
  Widget build(BuildContext context) {
    generalProvider = Provider.of<GeneralProvider>(context, listen: false);
    generalProvider.setEmailFromLogin(FirebaseAuth.instance.currentUser!.email);
    generalProvider.setNumberOfAllProduct();
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text(
          "Admin Screen",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: generalProvider.isDark ? null : Colors.grey[100],
        leading: IconButton(
            onPressed: () {
              _key.currentState!.openDrawer();
              // setState(() {
              //   homeColor = true;
              // });
            },
            icon: Icon(
              Icons.menu,
              color: Colors.black,
            )),
        actions: [
          NotificationButton(
              // fromHomePage: false,
              ),
        ],
      ),
      drawer: buildDrawer(),
      body: Container(
        // height: 1100,
        child: ListView(
          children: [
            StreamBuilder<Object>(
                stream: null,
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      Form(
                        child: Column(
                          children: [
                            // title add product
                            Container(
                              padding: EdgeInsets.all(20),
                              child: Center(
                                child: Text(
                                  "Add New Product",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            // choose collection
                            Container(
                              padding: EdgeInsets.fromLTRB(30, 20, 30, 10),
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2),
                                  ),
                                  // filled: true,
                                  // fillColor: Colors.greenAccent,
                                ),
                                // dropdownColor: Colors.greenAccent,
                                value: dropdownValue,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
                                    print(dropdownValue);
                                  });
                                },
                                items: list.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            //name
                            Container(
                              padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                              child: TextFormField(
                                controller: nameController,
                                style: TextStyle(),
                                decoration: InputDecoration(
                                  hintText: "Name",
                                  labelText: "Name",
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      borderSide:
                                          BorderSide(color: Colors.green),
                                      gapPadding: 10.0),
                                ),
                              ),
                            ),
                            //image
                            Container(
                              padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                              child: TextFormField(
                                controller: imageController,
                                style: TextStyle(),
                                decoration: InputDecoration(
                                  hintText: "Image",
                                  labelText: "Image",
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      borderSide:
                                          BorderSide(color: Colors.green),
                                      gapPadding: 10.0),
                                ),
                              ),
                            ),
                            //price and repo
                            Container(
                              padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 160,
                                    child: TextFormField(
                                      controller: priceController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: "Price",
                                          labelText: "Price",
                                          hintStyle:
                                              TextStyle(color: Colors.black)),
                                    ),
                                  ),
                                  Container(
                                    width: 160,
                                    child: TextFormField(
                                      controller: repoController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: "Repository",
                                          labelText: "Repository",
                                          hintStyle:
                                              TextStyle(color: Colors.black)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //add
                            Container(
                              padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                              height: 60,
                              width: double.infinity,
                              child: ElevatedButton(
                                  child: Text(
                                    "ADD",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blue[400],
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    validation();

                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  }),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                        child: Center(
                            child: Text(
                          "Product Number: ${generalProvider.getAllNumberProduct} ",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        )),
                      ),
                      Container(
                        // height: 60,
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                        child: TextFormField(
                          controller: searchController,
                          style: TextStyle(),
                          decoration: InputDecoration(
                            suffixIcon: Container(
                              margin: EdgeInsets.fromLTRB(0, 20, 10, 0),
                              child: Wrap(
                                children: [
                                  GestureDetector(
                                    child: Icon(Icons.close),
                                    onTap: () {
                                      // generalProvider.setNumberOfAllProduct();
                                      generalProvider
                                          .searchProductListForAdmin("");
                                      setState(() {
                                        searchController.text = "";
                                        hasSearchWord = false;
                                      });
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  GestureDetector(
                                    child: Icon(Icons.send),
                                    onTap: () {
                                      print(searchController.text.trim());
                                      if (searchController.text.trim().length >
                                          0) {
                                        generalProvider.searchProductList(
                                            searchController.text);
                                        hasSearchWord = true;
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                            hintText: "Search",
                            labelText: "Search",
                            hintStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      hasSearchWord
                          ? generalProvider.getSearchList.length == 0
                              ? Container(
                                  height: 300,
                                  child: Center(
                                      child: Text(
                                    "No Result",
                                    style: TextStyle(fontSize: 30),
                                  )),
                                )
                              : Container(
                                  height: 300,
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  width: double.infinity,
                                  child: ListView.builder(
                                      itemCount:
                                          generalProvider.getSearchList.length,
                                      itemBuilder: ((context, index) {
                                        return Slidable(
                                          startActionPane: ActionPane(
                                            motion: ScrollMotion(),
                                            children: [
                                              SlidableAction(
                                                onPressed: (context) =>
                                                    showAlertDialogForDelete(
                                                        context, index),
                                                backgroundColor:
                                                    Color(0xFFFE4A49),
                                                foregroundColor: Colors.white,
                                                icon: Icons.delete,
                                                label: 'Delete',
                                              ),
                                            ],
                                          ),
                                          endActionPane: ActionPane(
                                            motion: ScrollMotion(),
                                            children: [
                                              SlidableAction(
                                                onPressed: (context) =>
                                                    showAlertDialogForDelete(
                                                        context, index),
                                                backgroundColor:
                                                    Color(0xFFFE4A49),
                                                foregroundColor: Colors.white,
                                                icon: Icons.delete,
                                                label: 'Delete',
                                              ),
                                            ],
                                          ),
                                          child: SingleProductForAdmin(
                                            name: generalProvider
                                                .getSearchList[index].name,
                                            price: generalProvider
                                                .getSearchList[index].price,
                                            image: generalProvider
                                                .getSearchList[index].image,
                                          ),
                                          // repo: generalProvider
                                          //     .getSearchList[index].repo),
                                        );
                                      })),
                                )
                          : Container(
                              height: 300,
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              width: double.infinity,
                              child: ListView.builder(
                                  itemCount:
                                      generalProvider.getAllNumberProduct,
                                  itemBuilder: ((context, index) {
                                    return Slidable(
                                      startActionPane: ActionPane(
                                        motion: ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: (context) =>
                                                showAlertDialogForDelete(
                                                    context, index),
                                            backgroundColor: Color(0xFFFE4A49),
                                            foregroundColor: Colors.white,
                                            icon: Icons.delete,
                                            label: 'Delete',
                                          ),
                                        ],
                                      ),
                                      endActionPane: ActionPane(
                                        motion: ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: (context) =>
                                                showAlertDialogForDelete(
                                                    context, index),
                                            backgroundColor: Color(0xFFFE4A49),
                                            foregroundColor: Colors.white,
                                            icon: Icons.delete,
                                            label: 'Delete',
                                          ),
                                        ],
                                      ),
                                      child: SingleProductForAdmin(
                                        name: generalProvider
                                            .getAllProduct[index].name,
                                        price: generalProvider
                                            .getAllProduct[index].price,
                                        image: generalProvider
                                            .getAllProduct[index].image,
                                      ),
                                      // repo: generalProvider
                                      //     .getSearchList[index].repo),
                                    );
                                  })),
                            )
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget buildDrawer() {
    return Drawer(
        // key:_key,
        child: ListView(
      children: [
        UserAccountsDrawerHeader(
          accountName: Text(
            "Admin",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 30, color: Colors.red),
          ),
          accountEmail: Text(
            "admin@gmail.com",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 25,
                color: Colors.black),
          ),
          currentAccountPicture: CircleAvatar(
            backgroundImage: NetworkImage(
                "https://thumbs.dreamstime.com/b/admin-sign-laptop-icon-stock-vector-166205404.jpg"),
          ),
          decoration: BoxDecoration(
            color: Color(0xfff2f2f2),
          ),
        ),
        const Divider(
          height: 1,
          thickness: 1,
          color: Colors.lightGreen,
        ),
        ListTile(
          selected: true,
          onTap: () {},
          title: const Text("Home"),
          leading: const Icon(Icons.home),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context)
                .push(PageRouteToScreen().pushToAnalysistAdminScreen());
          },
          title: const Text("Analysis"),
          leading: const Icon(Icons.analytics),
        ),
        ListTile(
          onTap: () {
            // Navigator.of(context)
            //     .push(MaterialPageRoute(builder: (ctx) => TestScreen()));
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => ContactMessenger(
                    id: generalProvider.getContactUser.id,
                    name: generalProvider.getContactUser.name,
                    email: generalProvider.getContactUser.email)));
          },
          title: const Text("Contact"),
          leading: const Icon(Icons.message),
        ),
        ListTile(
          onTap: () {
            _key.currentState!.openEndDrawer();
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (ctx) => Login()));
          },
          title: const Text("Log Out"),
          leading: const Icon(Icons.logout),
        ),
      ],
    ));
  }

  addProduct() {
    if (dropdownValue == "Eastern Food") {
      addProductForCategory("EastDish");
      generalProvider.setEastDish();
    }
    if (dropdownValue == "Asia Food") {
      addProductForCategory("AsiaDish");
      generalProvider.setAsiaDish();
    }
    if (dropdownValue == "Water Food") {
      addProductForCategory("WaterDish");
      generalProvider.setwaterDish();
    }
    if (dropdownValue == "Drink") {
      addProductForCategory("Drink");
      generalProvider.setDrink();
    }
    if (dropdownValue == "Snack Food") {
      addProductForCategory("Snack");
      generalProvider.setSnack();
    }
    if (dropdownValue == "Feature Food") {
      FirebaseFirestore.instance
          .collection("products")
          .doc("Yr4cg3K870i11VWoxx5q")
          .collection("featuredproduct")
          .add({
        "category": nameController.text,
        "image": imageController.text,
        "price": nameController.text,
        "repo": repoController.text,
      });
      generalProvider.setFeatureProduct();
    }
    generalProvider.setNumberOfAllProduct();
    generalProvider.addNotiList(
        "${getTime()}: You add ${nameController.text.trim()} into product list");
  }

  validation() {
    if (nameController.text.isEmpty &&
        imageController.text.isEmpty &&
        priceController.text.isEmpty &&
        repoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Both Field Are Empty"),
      ));
    } else if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Name Of Product Are Empty"),
      ));
    } else if (imageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Image Of Product Are Empty"),
      ));
    } else if (priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Price Of Product Are Empty"),
      ));
    } else if (repoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Repository Of Product Are Empty"),
      ));
    } else {
      addProduct();
    }
  }

  addProductForCategory(String col) {
    FirebaseFirestore.instance
        .collection("category")
        .doc("2n0DMzp0z2in1eLYBXHG")
        .collection(col)
        .add({
      "category": nameController.text,
      "image": imageController.text,
      "price": priceController.text,
      "repo": repoController.text
    });
    print("add Product for $col succesfully");
  }

  showAlertDialogForDelete(BuildContext context, int index) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String nameOfDeletedProduct = searchController.text.trim().length != 0
            ? generalProvider.searchList[index].name
            : generalProvider.getAllProduct[index].name;
        return AlertDialog(
          title: Text('WARNING !!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You want delete ${nameOfDeletedProduct}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                deleteProduct(nameOfDeletedProduct);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  deleteProduct(String nameOfDeletedProduct) {
    checkForCategory("AsiaDish", nameOfDeletedProduct);
    checkForCategory("WaterDish", nameOfDeletedProduct);
    checkForCategory("Snack", nameOfDeletedProduct);
    checkForCategory("Drink", nameOfDeletedProduct);
    checkForCategory("EastDish", nameOfDeletedProduct);
    checkForProduct("featuredproduct", nameOfDeletedProduct);
    checkForProduct("newachives", nameOfDeletedProduct);
  }

  checkForProduct(String col, String nameOfDeletedProduct) async {
    QuerySnapshot<Object?> snapshot = await FirebaseFirestore.instance
        .collection("products")
        .doc("Yr4cg3K870i11VWoxx5q")
        .collection(col)
        .get();
    snapshot.docs.forEach((element) {
      if (element["category"] == nameOfDeletedProduct) {
        FirebaseFirestore.instance
            .collection("products")
            .doc("Yr4cg3K870i11VWoxx5q")
            .collection(col)
            .doc(element.id)
            .delete();
        print("$col delete $nameOfDeletedProduct succesfully");
        generalProvider.searchProductList(name);
        searchController.text = "";
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("You have already deleted ${nameOfDeletedProduct}")));
        generalProvider.addNotiList(
            "${getTime()}: You delete ${nameOfDeletedProduct} into ${col} list");
        return;
      }
    });
  }

  checkForCategory(String col, String nameOfDeletedProduct) async {
    QuerySnapshot<Object?> snapshot = await FirebaseFirestore.instance
        .collection("category")
        .doc("2n0DMzp0z2in1eLYBXHG")
        .collection(col)
        .get();
    snapshot.docs.forEach((element) {
      if (element["category"] == nameOfDeletedProduct) {
        FirebaseFirestore.instance
            .collection("category")
            .doc("2n0DMzp0z2in1eLYBXHG")
            .collection(col)
            .doc(element.id)
            .delete();
        print("$col delete $nameOfDeletedProduct succesfully");
        generalProvider.searchProductList(name);
        generalProvider.addNotiList(
            "${getTime()}: You delete ${nameOfDeletedProduct} into ${col} list");
        setState(() {
          searchController.text = "";
        });
        return;
      }
    });
  }
}
