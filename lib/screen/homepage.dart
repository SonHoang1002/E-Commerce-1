import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/models/usermodel.dart';
import 'package:testecommerce/providers/category_provider.dart';
import 'package:testecommerce/providers/product_provider.dart';
import 'package:testecommerce/providers/theme_provider.dart';
import 'package:testecommerce/screen/about.dart';
import 'package:testecommerce/screen/cartscreen.dart';
import 'package:testecommerce/screen/detailscreen.dart';
import '../widget/listproduct.dart';
import 'package:testecommerce/screen/login.dart';
import '../widget/listproduct.dart';
import '../widget/notification_button.dart';
import 'package:testecommerce/screen/profile.dart';
import '../addition/search.dart';
import '../widget/cartsingleproduct.dart';

import '../providers/general_provider.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:badges/badges.dart';
import '../models/product.dart';
import '../widget/singleproduct.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

var asiaDish;
var eastDish;
var Snack;
var waterDish;

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final GlobalKey<State<Tooltip>> keyTooltip = GlobalKey<State<Tooltip>>();
  late GeneralProvider generalProvider;

  late bool homeColor = true;
  late bool settingColor = false;
  late bool aboutColor = false;
  late bool profileColor = false;
  late bool searchTextField = false;
  TextEditingController searchInput = TextEditingController();

  late List<Product> listFeature = [];
  late List<Product> listNew = [];

  late List<Product> listAsia = [];
  late List<Product> listEast = [];
  late List<Product> listSnack = [];
  late List<Product> listWater = [];
  late List<Product> listDrink = [];

  String? name = "";
  bool isLoaded = false;

  bool hasSearchWord = false;
  bool showResultWord = false;

  void loadData() {
    generalProvider = Provider.of<GeneralProvider>(context, listen: false);
    generalProvider.setEmailFromLogin(FirebaseAuth.instance.currentUser!.email);
    if (listAsia.length == 0) {
      Future<int> a = generalProvider.setAsiaDish();
      listAsia = generalProvider.getListAsia();
    }
    if (listEast.length == 0) {
      Future<int> b = generalProvider.setEastDish();
      listEast = generalProvider.getEastDish();
    }
    if (listSnack.length == 0) {
      Future<int> c = generalProvider.setSnack();
      listSnack = generalProvider.getSnack();
    }
    if (listWater.length == 0) {
      Future<int> d = generalProvider.setwaterDish();
      listWater = generalProvider.getWaterDish();
    }
    if (listFeature.length == 0) {
      Future<int> e = generalProvider.setFeatureProduct();
      listFeature = generalProvider.getFeatureProduct();
    }
    if (listNew.length == 0) {
      Future<int> f = generalProvider.setNewProduct();
      listNew = generalProvider.getNewProduct();
    }
    if (listDrink.length == 0) {
      Future<int> g = generalProvider.setDrink();
      listDrink = generalProvider.getListDrink();
    }
    if (name == "") {
      Future<int> f = generalProvider.setUserModel();
      name = generalProvider.getUserModelName;
    }
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    loadData();
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text(
          "Home",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: generalProvider.isDark ? null : Colors.grey[100],
        leading: IconButton(
            onPressed: () {
              _key.currentState!.openDrawer();
              setState(() {
                homeColor = true;
              });
            },
            icon: Icon(
              Icons.menu,
              color: Colors.black,
            )),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  searchTextField = !searchTextField;
                });
                // showSearch(context: context, delegate: Search());
              },
              icon: Icon(
                Icons.search,
                color: Colors.red,
              )),
          NotificationButton(),
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (ctx) => CartScreen()));
              },
              icon: Badge(
                animationType: BadgeAnimationType.scale,
                shape: BadgeShape.circle,
                badgeContent: Text("${generalProvider.getCartModelLength}"),
                showBadge: true,
                child: Icon(
                  Icons.shopping_cart,
                  color: Colors.black,
                ),
              ))
        ],
      ),
      drawer: buildDrawer(),
      body: isLoaded ? buildBody() : CircularProgressIndicator(),
    );
  }

  Widget buildDrawer() {
    return Drawer(
        child: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("User").snapshots(),
      builder: (context, snapshot) {
        snapshot.data!.docs.forEach((element) {
          if (element["UserId"] == FirebaseAuth.instance.currentUser!.uid) {
            name = element["UserName"];
            email = element["UserEmail"];
          }
        });
        return ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                name!,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.red),
              ),
              accountEmail: Text(
                generalProvider.getEmailFromLogin,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 25,
                    color: Colors.black),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("images/userlogo.jpg"),
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
              selected: homeColor,
              onTap: () {
                // _key.currentState!.openEndDrawer();
                _key.currentState!.showSnackBar(
                    const SnackBar(content: Text("You click Home ListTile")));
                setState(() {
                  homeColor = true;
                  settingColor = false;
                  profileColor = false;
                  aboutColor = false;
                });
              },
              title: const Text("Home"),
              leading: const Icon(Icons.home),
            ),
            ListTile(
              selected: profileColor,
              onTap: () {
                _key.currentState!.openEndDrawer();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (ctx) => ProfileScreen()));
                // _key.currentState!.showSnackBar(
                //     const SnackBar(content: Text("You click Contact ListTile")));
                setState(() {
                  settingColor = false;
                  profileColor = true;
                  homeColor = false;
                  aboutColor = false;
                });
              },
              title: const Text("Profile"),
              leading: const Icon(Icons.phone),
            ),
            ExpansionTile(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Text("Theme"),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            generalProvider.setTheme();
                          },
                          icon: generalProvider.isDark
                              ? Icon(Icons.light_mode)
                              : Icon(Icons.dark_mode),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Text("Phone"),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.phone),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ],
                )
              ],
              title: const Text("Settings"),
              leading: const Icon(Icons.settings),
            ),
            ListTile(
              selected: aboutColor,
              onTap: () {
                _key.currentState!.openEndDrawer();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (ctx) => About()));
                setState(() {
                  settingColor = false;
                  profileColor = false;
                  homeColor = false;
                  aboutColor = true;
                });
              },
              title: const Text("About"),
              leading: const Icon(Icons.info),
            ),
            ListTile(
              onTap: () {
                _key.currentState!.openEndDrawer();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (ctx) => Login()));
                setState(() {
                  settingColor = false;
                  profileColor = true;
                  homeColor = false;
                  aboutColor = false;
                });
              },
              title: const Text("Logout"),
              leading: const Icon(Icons.exit_to_app),
            ),
          ],
        );
      },
    ));
  }

  Widget buildBody() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      height: double.infinity,
      width: double.infinity,
      child: ListView(
        children: [
          Column(children: [
            Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  searchTextField ? buildSearch() : buildCarousel(),
                  hasSearchWord
                      ? showResultWord
                          ? Container(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Column(
                                children: [
                                  searchInput.text.trim().length > 0
                                      ? Row(
                                          children: [
                                            Text(
                                              "You search:  ${searchInput.text}",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            GestureDetector(
                                              child: Icon(Icons.close),
                                              onTap: () {
                                                setState(() {
                                                  searchInput.text = "";
                                                });
                                              },
                                            )
                                          ],
                                        )
                                      : Container(),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              searchInput.text = "";
                                              hasSearchWord = false;
                                            });
                                          },
                                          child: Center(
                                              child: Tooltip(
                                            waitDuration: Duration(seconds: 1),
                                            showDuration: Duration(seconds: 3),
                                            message: "Back To Home",
                                            child: CircleAvatar(
                                                maxRadius: 25,
                                                backgroundColor: Colors.grey,
                                                child: Icon(Icons.arrow_back)),
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),
                                  generalProvider.getSearchList.length > 0
                                      ? Column(
                                          children: [
                                            Text(
                                              "Result",
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                            Container(
                                              height: 500,
                                              child: ListView.builder(
                                                itemCount: generalProvider
                                                    .getSearchList.length,
                                                itemBuilder: (context, index) =>
                                                    SingleProduct(
                                                        name: generalProvider
                                                            .getSearchList[
                                                                index]
                                                            .name,
                                                        price: generalProvider
                                                            .getSearchList[
                                                                index]
                                                            .price,
                                                        image: generalProvider
                                                            .getSearchList[
                                                                index]
                                                            .image),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Text(
                                          "NO RESULT",
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontStyle: FontStyle.italic),
                                        ),
                                ],
                              ),
                            )
                          : Container()
                      : Column(
                          children: [
                            buildCategory(),
                            buildFeatured(),
                            buildNewProduct()
                          ],
                        )
                ],
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget buildSearch() {
    return Container(
      height: 50,
      width: 450,
      child: Container(
        child: TextFormField(
          controller: searchInput,
          decoration: InputDecoration(
              suffixIcon: GestureDetector(
                child: Icon(
                  Icons.send,
                ),
                onTap: () {
                  setState(() {
                    if (searchInput.text.trim().length > 0) {
                      hasSearchWord = true;
                      showResultWord = true;
                      FocusManager.instance.primaryFocus?.unfocus();
                      generalProvider.searchProductList(searchInput.text);
                    }
                  });
                },
              ),
              hintText: "Search Something",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
        ),
      ),
    );
  }

  Widget buildCarousel() {
    return Container(
      height: 200,
      child: Carousel(
        autoplay: true,
        showIndicator: false,
        dotSize: 20,
        images: [
          NetworkImage(
              "https://lavenderstudio.com.vn/wp-content/uploads/2017/03/chup-san-pham.jpg"),
          NetworkImage(
              "https://camnangbep.com/wp-content/uploads/2022/04/hinh-anh-do-an-vat-ngon.jpg"),
          NetworkImage(
              "https://i.pinimg.com/originals/df/de/09/dfde098d1ae962ea1efe2f58cd20a968.jpg"),
          NetworkImage(
              "https://images.squarespace-cdn.com/content/v1/53883795e4b016c956b8d243/1551438228969-H0FPV1FO3W5B0QL328AS/chup-anh-thuc-an-1.jpg"),
          NetworkImage(
              "https://bepvang.org.vn/Userfiles/Upload/images/Download/2017/2/24/268f41e9fdcd49999f327632ed207db1.jpg")
        ],
      ),
    );
  }

  Widget buildCategory() {
    return Column(
      children: [
        Container(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Category",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Container(
          height: 90,
          child: Row(
            children: [
              buildIconCategory(
                  "waterdish.webp", "Water Food", "WATER FOOD", listWater),
              buildIconCategory(
                  "snack-food.png", "Snack Food", "SNACK FOOD", listSnack),
              buildIconCategory(
                  "east-food.png", "Europe Food", "EUROPE FOOD", listEast),
              buildIconCategory(
                  "asiafood.png", "Asia Food", "ASIA FOOD", listAsia),
              buildIconCategory(
                  "cocktail.png", "Drinking", "DRINKING", listDrink),
            ],
          ),
        )
      ],
    );
  }

  Widget buildIconCategory(
      String pathImage, String name, String nameList, List<Product> list) {
    return GestureDetector(
      child: _CircleImage(pathImage, 0xffb74093, name),
      onTap: () {
        // keyTooltip.currentState!.;
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (ctx) => ListProduct(name: nameList, list: list)));
      },
    );
  }

  Widget buildFeatured() {
    return Column(
      children: [
        Container(
          height: 50,
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Main Products",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => ListProduct(
                              name: "Main Products",
                              list: listFeature,
                            )));
                  },
                  child: Text(
                    "See More",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ]),
        ),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (ctx) => DetailScreen(
                                name: listFeature[0].name,
                                price: listFeature[0].price,
                                img: listFeature[0].image)));
                      },
                      child: SingleProduct(
                          name: listFeature[0].name,
                          price: listFeature[0].price,
                          image: listFeature[0].image),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (ctx) => DetailScreen(
                                name: listFeature[1].name,
                                price: listFeature[1].price,
                                img: listFeature[1].image)));
                      },
                      child: SingleProduct(
                          name: listFeature[1].name,
                          price: listFeature[1].price,
                          image: listFeature[1].image),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget buildNewProduct() {
    return Column(
      children: [
        Container(
          height: 50,
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "New Products",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => ListProduct(
                              name: "New Product",
                              list: listNew,
                            )));
                  },
                  child: Text(
                    "See More",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ]),
        ),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (ctx) => DetailScreen(
                                name: listNew[0].name,
                                price: listNew[0].price,
                                img: listNew[0].image)));
                      },
                      child: SingleProduct(
                          name: listNew[0].name,
                          price: listNew[0].price,
                          image: listNew[0].image),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (ctx) => DetailScreen(
                                name: listNew[1].name,
                                price: listNew[1].price,
                                img: listNew[1].image)));
                      },
                      child: SingleProduct(
                          name: listNew[1].name,
                          price: listNew[1].price,
                          image: listNew[1].image),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}

Widget _CircleImage(String img, int color, String messageOfTooltip) {
  return Tooltip(
    waitDuration: Duration(seconds: 1),
    showDuration: Duration(seconds: 2),
    message: messageOfTooltip,
    padding: const EdgeInsets.all(5),
    height: 25,
    preferBelow: true,
    child: Container(
      margin: EdgeInsets.all(4),
      child: CircleAvatar(
        maxRadius: 30,
        backgroundColor: Color(color),
        child: Image(image: AssetImage("images/$img")),
      ),
    ),
  );
}
