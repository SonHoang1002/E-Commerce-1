import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import 'package:testecommerce/addition/app_localization.dart';
import 'package:testecommerce/addition/pageRoute.dart';
import 'package:testecommerce/gradient/gradient.dart';
import 'package:testecommerce/screen/contact_messenger.dart';
import 'package:testecommerce/screen/detail_screen.dart';
import 'package:testecommerce/widget/notification_button.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../widget/list_product.dart';
import 'package:testecommerce/screen/profile.dart';

import '../providers/general_provider.dart'; 
import 'package:badges/badges.dart' as badges; 
import '../models/product.dart';
import '../widget/single_product.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  List<String> nameList;
  HomePage({required this.nameList});
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
  String image = "";
  bool isMale = false;
  bool isLoaded = false;

  bool hasSearchWord = false;
  bool showResultWord = false;
  // late final List<String> nameList;
  late String nameOfProduct = '';

  void loadData() {
    generalProvider = Provider.of<GeneralProvider>(context, listen: false);
    generalProvider.setEmailFromLogin(FirebaseAuth.instance.currentUser!.email);
    // print(" Product lists is empty__________________________________");
    listAsia = [];
    listDrink = [];
    listEast = [];
    listFeature = [];
    listSnack = [];
    listWater = [];
    listNew = [];
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
      Future<int> i = generalProvider.setUserModel();
      name = generalProvider.getUserModelName;
    }
    // if (nameList == []) {
    //   Future<int> xxx = generalProvider.setNameProductList();
    //   nameList = generalProvider.getNameProductList;
    // }

    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    // loadData();
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate("home_title") ?? "Home",
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
            )),
        actions: [
          IconButton(
              onPressed: () async {
                Future<int> abc = generalProvider.setNameProductList();
                setState(() {
                  searchTextField = !searchTextField;
                });
                // showSearch(context: context, delegate: Search());
              },
              icon: const Icon(
                Icons.search,
                color: Colors.red,
              )),
          NotificationButton(
              // fromHomePage: false,
              ),
          IconButton(
              onPressed: () {
                // Navigator.of(context)
                //     .push(MaterialPageRoute(builder: (ctx) => CartScreen()));
                Navigator.of(context)
                    .push(PageRouteToScreen().pushToCartScreen());
              },
              icon:badges. Badge(
                badgeAnimation: const badges.BadgeAnimation.scale(),
                badgeStyle: const badges.BadgeStyle(shape: badges.BadgeShape.circle,),
                badgeContent: Text("${generalProvider.getCartModelListLength}"),
                showBadge: true,
                child: const Icon(
                  Icons.shopping_cart,
                  color: Colors.black,
                ),
              ))
        ],
      ),
      // endDrawer: buildDrawer(),
      drawer: buildDrawer(),
      body: isLoaded ? buildBody() : const CircularProgressIndicator(),
    );
  }

  Widget buildDrawer() {
    return Drawer(
        child: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("User").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        snapshot.data!.docs.forEach((element) {
          if (element["UserId"] == FirebaseAuth.instance.currentUser!.uid) {
            name = element["UserName"];
            email = element["UserEmail"];
            image = element["UserImage"];
            isMale = element["UserGender"] == "Male";
          }
        });
        return ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(
                  name!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.red),
                ),
              ),
              accountEmail: Text(
                generalProvider.getEmailFromLogin,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                    color: Colors.black),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: image == ""
                    ? isMale
                        ? const NetworkImage(
                            "https://w7.pngwing.com/pngs/481/915/png-transparent-computer-icons-user-avatar-woman-avatar-computer-business-conversation-thumbnail.png")
                        : const NetworkImage(
                            "https://cdn-icons-png.flaticon.com/512/219/219990.png")
                    : NetworkImage(image),
              ),
              decoration: const BoxDecoration(
                color: Color(0xfff2f2f2),
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Colors.lightGreen,
            ),
            //home
            ListTile(
              selected: homeColor,
              onTap: () {
                _key.currentState!.openEndDrawer();
                // _key.currentState!.showSnackBar(
                //     const SnackBar(content: Text("You click Home ListTile")));
                // ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(content: Text("You click Home ListTile")));
                setState(() {
                  homeColor = true;
                  settingColor = false;
                  profileColor = false;
                  aboutColor = false;
                });
              },
              title: Text(
                  AppLocalizations.of(context)!.translate("home_title") ??
                      "Home"),
              leading: const Icon(Icons.home),
            ),
            //profile
            ListTile(
              selected: profileColor,
              onTap: () {
                _key.currentState!.openEndDrawer();
                // Navigator.of(context)
                //     .push(MaterialPageRoute(builder: (ctx) => ProfileScreen()));
                Navigator.of(context)
                    .push(PageRouteToScreen().pushToProfileScreen());

                // _key.currentState!.showSnackBar(
                //     const SnackBar(content: Text("You click Contact ListTile")));
                setState(() {
                  settingColor = false;
                  profileColor = true;
                  homeColor = false;
                  aboutColor = false;
                });
              },
              title: Text(
                  AppLocalizations.of(context)!.translate("profile_title") ??
                      "Profile"),
              leading: const Icon(Icons.people),
            ),
            //setting
            ExpansionTile(
              title: Text(
                  AppLocalizations.of(context)!.translate("setting_title") ??
                      "Settings"),
              leading: const Icon(Icons.settings),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Text(AppLocalizations.of(context)!.translate("theme") ??
                            "Theme"),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            generalProvider.setTheme();
                          },
                          icon: generalProvider.isDark
                              ? const Icon(Icons.light_mode)
                              : const Icon(Icons.dark_mode),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text(
                      AppLocalizations.of(context)!.translate("language") ??
                          "Language"),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: const Text("Vietnamese"),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {}, icon: const Icon(Icons.language)),
                            const SizedBox(
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
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: const Text("English"),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.language),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                  // leading: const Icon(Icons.language),
                ),
                ExpansionTile(
                  title: Text(
                      AppLocalizations.of(context)!.translate("currentcy") ??
                          "Currentcy"),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: const Text("Viet Nam Dong"),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  generalProvider.setMoneyIcon(1);
                                },
                                icon: const Icon(Icons.money)),
                            const SizedBox(
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
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: const Text("USD"),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                generalProvider.setMoneyIcon(2);
                              },
                              icon: const Icon(Icons.money),
                            ),
                            const SizedBox(
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
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: const Text("Euro"),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                generalProvider.setMoneyIcon(3);
                              },
                              icon: const Icon(Icons.money),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                  // leading: const Icon(Icons.language),
                ),
              ],
            ),
            //contact
            ExpansionTile(
              title: Text(
                  AppLocalizations.of(context)!.translate("contact_title") ??
                      "Contact"),
              leading: const Icon(Icons.contact_page),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Text(AppLocalizations.of(context)!.translate("phone") ??
                            "Phone"),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              launchUrlString('tel: 0346311358');
                            },
                            icon: const Icon(Icons.phone)),
                        const SizedBox(
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
                        const SizedBox(
                          width: 20,
                        ),
                        Text(AppLocalizations.of(context)!
                                .translate("messenger") ??
                            "Messenger"),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              var id = FirebaseAuth.instance.currentUser!.uid;
                              QuerySnapshot<Object?> snapshot =
                                  await FirebaseFirestore.instance
                                      .collection("User")
                                      .get();
                              snapshot.docs.forEach((element) {
                                if (element.id == id) {
                                  generalProvider
                                      .setListId(element["Id_messenger"]);
                                  generalProvider.setContactUser(
                                    element["Id_messenger"],
                                    element["UserName"],
                                    element["UserEmail"],
                                  );
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) => ContactMessenger(
                                            id: element["Id_messenger"],
                                            name: element["UserName"],
                                            email: element["UserEmail"],
                                          )));
                                }
                              });
                            },
                            icon: const Icon(Icons.message)),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            //about
            ListTile(
              selected: aboutColor,
              onTap: () {
                _key.currentState!.openEndDrawer();
                // Navigator.of(context)
                //     .push(MaterialPageRoute(builder: (ctx) => About()));
                Navigator.of(context)
                    .push(PageRouteToScreen().pushToAboutScreen());
                setState(() {
                  settingColor = false;
                  profileColor = false;
                  homeColor = false;
                  aboutColor = true;
                });
              },
              title: Text(
                  AppLocalizations.of(context)!.translate("about_title") ??
                      "About"),
              leading: const Icon(Icons.info),
            ),
            //logout
            ListTile(
              onTap: () {
                _key.currentState!.openEndDrawer();
                // Navigator.of(context).pushReplacement(
                //     MaterialPageRoute(builder: (ctx) => Login()));
                _showAlertDialog(context);
                setState(() {
                  settingColor = false;
                  profileColor = true;
                  homeColor = false;
                  aboutColor = false;
                });
              },
              title: Text(
                  AppLocalizations.of(context)!.translate("logout_title") ??
                      "Logout"),
              leading: const Icon(Icons.exit_to_app),
            ),
            //test
            // ListTile(
            //   selected: homeColor,
            //   onTap: () {
            //     // Navigator.of(context).push(MaterialPageRoute(
            //     //     builder: (ctx) =>
            //     //         // TestScreen(list: generalProvider.getNameProductList)));
            //     //         TestScreen()));
            //     Navigator.of(context)
            //         .push(PageRouteToScreen().pushToTestScreen());
            //   },
            //   title: const Text("Test"),
            //   leading: const Icon(Icons.text_snippet),
            // ),
          ],
        );
      },
    ));
  }

  _showAlertDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning !!'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Text('You really want log out ??'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context)
                    .pushReplacement(PageRouteToScreen().pushToLoginScreen());
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildBody() {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Container(
        decoration: DecorationBackGround().buildDecoration(),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          height: double.infinity,
          width: double.infinity,
          child: ListView(
            children: [
              Column(children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // searchTextField ? buildSearch() : buildCarousel(),
                      searchTextField
                          ? buildSearchSingleProduct()
                          : buildCarousel(),
                      hasSearchWord
                          ? showResultWord
                              ? Container(
                                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  searchInput.text = "";
                                                  hasSearchWord = false;
                                                  searchTextField = false;
                                                });
                                              },
                                              child: const Center(
                                                  child: Tooltip(
                                                waitDuration:
                                                    Duration(seconds: 1),
                                                showDuration:
                                                    Duration(seconds: 3),
                                                message: "Back To Home",
                                                child: CircleAvatar(
                                                    maxRadius: 25,
                                                    backgroundColor:
                                                        Colors.grey,
                                                    child:
                                                        Icon(Icons.arrow_back)),
                                              )),
                                            ),
                                          ),
                                        ],
                                      ),
                                      generalProvider.getSearchListFromQuery
                                                  .length >
                                              0
                                          ? Column(
                                              children: [
                                                 Text(
                                                  AppLocalizations.of(context)!.translate("result") ??"Result",
                                                  style: const TextStyle(
                                                      fontSize: 30,
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ),
                                                Container(
                                                  height: 500,
                                                  child: ListView.builder(
                                                    itemCount: generalProvider
                                                        .getSearchListFromQuery
                                                        .length,
                                                    itemBuilder: (context, index) => SingleProduct(
                                                        name: generalProvider
                                                            .getSearchListFromQuery[
                                                                index]
                                                            .name,
                                                        price: generalProvider
                                                            .getSearchListFromQuery[
                                                                index]
                                                            .price,
                                                        image: generalProvider
                                                            .getSearchListFromQuery[
                                                                index]
                                                            .image,
                                                        repo: generalProvider
                                                            .getSearchListFromQuery[
                                                                index]
                                                            .repo),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : const Text(
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
                                buildAds(),
                                buildNewProduct(),
                              ],
                            )
                    ],
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearch() {
    return Container(
      // height: 60,
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
      child: TextFormField(
        controller: searchInput,
        style: const TextStyle(),
        decoration: InputDecoration(
          suffixIcon: Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 10, 0),
            child: Wrap(
              children: [
                GestureDetector(
                  child: const Icon(Icons.close),
                  onTap: () {
                    generalProvider.setNumberOfAllProduct();
                    setState(() {
                      searchInput.text = "";
                    });
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  child: const Icon(Icons.send),
                  onTap: () {
                    if (searchInput.text.trim().length > 0) {
                      hasSearchWord = true;
                      showResultWord = true;
                      FocusManager.instance.primaryFocus?.unfocus();
                      generalProvider
                          .searchProductListEqualQuery(searchInput.text);
                    }
                  },
                )
              ],
            ),
          ),
          hintText: "Search",
          labelText: "Search",
          hintStyle: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget buildSearchSingleProduct() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      height: 195,
      child: SimpleAutocompleteFormField<String>(
        decoration: InputDecoration(
          labelText:
              AppLocalizations.of(context)!.translate("search") ?? 'Search',
          hintText:
              AppLocalizations.of(context)!.translate("search") ?? "Search",
          border: const OutlineInputBorder(),
        ),
        // suggestionsHeight: 70.0,
        maxSuggestions: 4,
        itemBuilder: (context, item) => Container(
          padding: const EdgeInsets.all(8.0),
          child: Text(item!),
        ),
        onSearch: (String search) async => search.isEmpty
            ? widget.nameList
            : widget.nameList
                .where((letter) =>
                    letter.toLowerCase().contains(search.toLowerCase()))
                .toList(),
        itemFromString: (string) => widget.nameList.singleWhere(
            (letter) => letter.toLowerCase() == string.toLowerCase(),
            orElse: () => ''),
        onChanged: (value) {
          setState(() => nameOfProduct = value.toString());
          print("Name Of Product onChange is ${nameOfProduct}");
          //////////////////////////////////////////////////////////////////////////////////////////////////  search from this
          if (value.toString().length > 0 && value != null) {
            hasSearchWord = true;
            showResultWord = true;
            FocusManager.instance.primaryFocus?.unfocus();
            generalProvider.searchProductListEqualQuery(value);
          }
        },
        validator: (letter) => letter == null ? 'Invalid letter.' : null,
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
        images: const [
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
                AppLocalizations.of(context)!.translate("category") ??"Category",
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Container(
          height: 90,
          child: Row(
            children: [
              buildIconCategory(
                  "waterdish.webp", AppLocalizations.of(context)!.translate("water_title") ??"Water Food", "WATER FOOD", listWater),
              buildIconCategory(
                  "snack-food.png", AppLocalizations.of(context)!.translate("snack_title") ??"Snack Food", "SNACK FOOD", listSnack),
              buildIconCategory(
                  "east-food.png", AppLocalizations.of(context)!.translate("eastern_title") ??"Europe Food", "EUROPE FOOD", listEast),
              buildIconCategory(
                  "asiafood.png", AppLocalizations.of(context)!.translate("asia_title") ??"Asia Food", "ASIA FOOD", listAsia),
              buildIconCategory(
                  "cocktail.png", AppLocalizations.of(context)!.translate("drink_title") ??"Drinking", "DRINKING", listDrink),
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
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                   AppLocalizations.of(context)!.translate("main_product") ??"Main Products",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => ListProduct(
                              name: "Main Products",
                              list: listFeature,
                            )));
                  },
                  child:  Text(
                     AppLocalizations.of(context)!.translate("see_more") ??"See More",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                              img: listFeature[0].image,
                              repo: listFeature[0].repo),
                        ));
                      },
                      child: SingleProduct(
                          name: listFeature[0].name,
                          price: listFeature[0].price,
                          image: listFeature[0].image,
                          repo: listFeature[0].repo),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (ctx) => DetailScreen(
                                name: listFeature[1].name,
                                price: listFeature[1].price,
                                img: listFeature[1].image,
                                repo: listFeature[1].repo)));
                      },
                      child: SingleProduct(
                          name: listFeature[1].name,
                          price: listFeature[1].price,
                          image: listFeature[1].image,
                          repo: listFeature[1].repo),
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
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
          height: 50,
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                   AppLocalizations.of(context)!.translate("new_product") ??"New Products",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => ListProduct(
                              name: "New Product",
                              list: listNew,
                            )));
                  },
                  child:  Text(
                     AppLocalizations.of(context)!.translate("see_more") ??"See More",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                                img: listNew[0].image,
                                repo: listFeature[0].repo)));
                      },
                      child: SingleProduct(
                          name: listNew[0].name,
                          price: listNew[0].price,
                          image: listNew[0].image,
                          repo: listNew[0].repo),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (ctx) => DetailScreen(
                                name: listNew[1].name,
                                price: listNew[1].price,
                                img: listNew[1].image,
                                repo: listNew[1].repo)));
                      },
                      child: SingleProduct(
                          name: listNew[1].name,
                          price: listNew[1].price,
                          image: listNew[1].image,
                          repo: listNew[1].repo),
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

  Widget buildAds() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      height: 50,
      width: double.infinity,
      alignment: Alignment.center,
      child: AdWidget(ad: generalProvider.getAds),
    );
  }
}

Widget _CircleImage(String img, int color, String messageOfTooltip) {
  return Tooltip(
    waitDuration: const Duration(seconds: 1),
    showDuration: const Duration(seconds: 2),
    message: messageOfTooltip,
    padding: const EdgeInsets.all(5),
    height: 25,
    preferBelow: true,
    child: Container(
      margin: const EdgeInsets.all(4),
      child: CircleAvatar(
        maxRadius: 28,
        backgroundColor: Color(color),
        child: Image(image: AssetImage("images/$img")),
      ),
    ),
  );
}

// generalProvider.getSearchList.length > 0
//                                         ? Column(
//                                             children: [
//                                               Text(
//                                                 "Result",
//                                                 style: TextStyle(
//                                                     fontSize: 30,
//                                                     fontStyle:
//                                                         FontStyle.italic),
//                                               ),
//                                               Container(
//                                                 height: 500,
//                                                 child: ListView.builder(
//                                                   itemCount: generalProvider
//                                                       .getSearchList.length,
//                                                   itemBuilder: (context,
//                                                           index) =>
//                                                       SingleProduct(
//                                                           name: generalProvider
//                                                               .getSearchList[
//                                                                   index]
//                                                               .name,
//                                                           price: generalProvider
//                                                               .getSearchList[
//                                                                   index]
//                                                               .price,
//                                                           image: generalProvider
//                                                               .getSearchList[
//                                                                   index]
//                                                               .image),
//                                                 ),
//                                               ),
//                                             ],
//                                           )
//                                         : Text(
//                                             "NO RESULT",
//                                             style: TextStyle(
//                                                 fontSize: 30,
//                                                 fontStyle: FontStyle.italic),
//                                           ),
         