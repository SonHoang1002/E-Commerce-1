import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:testecommerce/screen/homepage.dart';
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
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => CartScreen()));
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
      body: buildBody(),
    );
  }

  Widget buildBody() {
    int num = generalProvider.getNotiList.length;
    return Container(
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
          SizedBox(
            height: 20,
          ),
          Divider(
            color: Colors.red,
            height: 20,
            thickness: 2,
          ),
          SizedBox(
            width: 20,
          ),
          Container(
            height: 500,
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
                            style: TextStyle(
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        index < num - 1
                            ? Divider(
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
          Divider(
            color: Colors.red,
            height: 10,
            thickness: 2,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 50,
            width: double.infinity,
            child: RaisedButton(
              onPressed: () {
                generalProvider.removeNotiList();
              },
              child: Center(
                  child: Text(
                "RESET",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              )),
            ),
          )
        ],
      ),
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