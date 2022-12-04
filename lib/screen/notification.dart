import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/addition/pageRoute.dart';
import 'package:testecommerce/gradient/gradient.dart';
import 'package:testecommerce/models/usermodel.dart';
import 'package:testecommerce/providers/category_provider.dart';
import 'package:testecommerce/providers/product_provider.dart';
import 'package:testecommerce/providers/theme_provider.dart';
import 'package:testecommerce/screen/about.dart';
import 'package:testecommerce/screen/cartscreen.dart';
import 'package:testecommerce/screen/detailscreen.dart';
import 'package:testecommerce/screen/homepage.dart';
import '../widget/listproduct.dart';
import 'package:testecommerce/screen/login.dart';
import '../widget/listproduct.dart';
import 'package:testecommerce/screen/profile.dart';
import '../addition/search.dart';
import '../widget/cartsingleproduct.dart';

import '../providers/general_provider.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:badges/badges.dart';
import '../models/product.dart';
import '../widget/singleproduct.dart';

class NotificationMessage extends StatefulWidget {
  @override
  State<NotificationMessage> createState() => _NotificationMessageState();
}

var asiaDish;
var eastDish;
var Snack;
var waterDish;

class _NotificationMessageState extends State<NotificationMessage> {
  late GeneralProvider generalProvider;

  @override
  Widget build(BuildContext context) {
    generalProvider = Provider.of<GeneralProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notification Page",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: generalProvider.isDark ? null : Colors.grey[100],
        leading: IconButton(
            onPressed: () {
              // Navigator.of(context)
              //     .push(MaterialPageRoute(builder: (ctx) => HomePage()));
              // generalProvider.getFromHomePage
              // ?  Navigator.of(context).push(MaterialPageRoute(
              //   builder: (ctx) =>
              //       HomePage(nameList: generalProvider.getNameProductList)))
              // : Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        actions: [
          generalProvider.getIsAdmin
              ? Container()
              : IconButton(
                  onPressed: () {
                    // Navigator.of(context).push(
                    //     MaterialPageRoute(builder: (ctx) => CartScreen()));
                    Navigator.of(context)
                        .push(PageRouteToScreen().pushToCartScreen());
                  },
                  icon: Badge(
                    animationType: BadgeAnimationType.scale,
                    shape: BadgeShape.circle,
                    badgeContent:
                        Text("${generalProvider.getCartModelListLength}"),
                    showBadge: true,
                    child: Icon(
                      Icons.shopping_cart,
                      color: Colors.black,
                    ),
                  ))
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    int num = generalProvider.getNotiList.length;
    return Container(
      decoration: DecorationBackGround().buildDecoration(),
      child: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Container(
              child: Text("Number Message: ${num}",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    // color: Colors.greenAccent,
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(
              color: Colors.red,
              height: 20,
              thickness: 2,
            ),
            const SizedBox(
              width: 20,
            ),
            Container(
              height: 450,
              width: double.infinity,
              child: ListView.builder(
                  itemCount: num,
                  itemBuilder: ((context, index) {
                    return Container(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        children: [
                          Text("${generalProvider.getNotiList[index]}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          index < num - 1
                              ? const Divider(
                                  color: Colors.green,
                                  height: 10,
                                  thickness: 2,
                                )
                              : Container()
                        ],
                      ),
                    );
                  })),
            ),
            const Divider(
              color: Colors.red,
              height: 10,
              thickness: 2,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // generalProvider.removeNotiList();
                  _showAlertDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Center(
                    child: Text(
                  "RESET",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }

  _showAlertDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning !!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('You want delete all history ??'),
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
                generalProvider.removeNotiList();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
// Column(
//         children: [
//           Container(
//             height: 460,
//             width: double.infinity,
//             child: ListView.builder(
//               itemCount: generalProvider.getCartModelLength,
//               itemBuilder: (context, index) {
//                 return CartSingleProduct(
//                     name: generalProvider.getCartModel[index].name,
//                     price: generalProvider.getCartModel[index].price,
//                     img: generalProvider.getCartModel[index].img,
//                     quantity: generalProvider.getCartModel[index].quantity);
//               },
//             ),
//           ),
//         ],
//       ),
