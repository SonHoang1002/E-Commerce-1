import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/main.dart';
import 'package:testecommerce/models/product.dart';
import 'package:testecommerce/providers/general_provider.dart';
import 'package:testecommerce/screen/admin/detailScreenAmin.dart';
import 'package:testecommerce/screen/admin/homeAdmin.dart';
import 'package:testecommerce/screen/checkout.dart';
import 'package:testecommerce/screen/detailscreen.dart';

class SingleProductForAdmin extends StatelessWidget {
  SingleProductForAdmin(
      // {required this.name, required this.price, required this.image,required this.repo});
      {required this.name,
      required this.price,
      required this.image});
  late final String name;
  late final String image;
  late final double price;
  // late final int repo;

  late GeneralProvider generalProvider;
  @override
  Widget build(BuildContext context) {
    generalProvider = Provider.of<GeneralProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        int repox = 0;
        List<Product> list = generalProvider.getAllProduct;
        for (int i = 0; i < list.length; i++) {
          if (name == list[i].name) {
            repox = list[i].repo;
          }
        }
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) => DetailScreenForAdmin(
                name: name, price: price, img: image, repo: repox)));
        // name: name, price: price, img: image)));
      },
      child: Card(
        child: Container(
          height: 230,
          width: double.infinity,
          color: Colors.blue,
          child: Column(children: [
            Container(
              width: double.infinity,
              height: 170,
              decoration: BoxDecoration(
                  color: Colors.red,
                  image: DecorationImage(
                      fit: BoxFit.fill, image: NetworkImage("$image"))),
            ),
            Container(
              width: double.infinity,
              height: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "$price ${generalProvider.getMoneyIconName}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.white),
                  ),
                  Text(
                    name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  )
                ],
              ),
            )
          ]),
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
          // <-- SEE HERE
          title: Text('Warning!!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You want delete $name'),
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
                deleteProduct(context);
              },
            ),
          ],
        );
      },
    );
  }

  deleteProduct(BuildContext context) {
    checkForCategory("AsiaDish", context);
    checkForCategory("WaterDish", context);
    checkForCategory("Snack", context);
    checkForCategory("Drink", context);
    checkForCategory("EastDish", context);
    checkForProduct("featuredproduct", context);
    checkForProduct("newachives", context);
    Navigator.of(context).pop();
  }

  checkForProduct(String col, BuildContext context) async {
    QuerySnapshot<Object?> snapshot = await FirebaseFirestore.instance
        .collection("products")
        .doc("Yr4cg3K870i11VWoxx5q")
        .collection(col)
        .get();
    snapshot.docs.forEach((element) {
      if (element["category"] == name) {
        FirebaseFirestore.instance
            .collection("products")
            .doc("Yr4cg3K870i11VWoxx5q")
            .collection(col)
            .doc(element.id)
            .delete();
        print("$col delete $name succesfully");
        Navigator.of(context).pop();
        generalProvider.searchProductList(name);

        return;
      }
    });
    // print("$col delete $name succesfully");
  }

  checkForCategory(String col, BuildContext context) async {
    QuerySnapshot<Object?> snapshot = await FirebaseFirestore.instance
        .collection("category")
        .doc("2n0DMzp0z2in1eLYBXHG")
        .collection(col)
        .get();
    snapshot.docs.forEach((element) {
      if (element["category"] == name) {
        FirebaseFirestore.instance
            .collection("category")
            .doc("2n0DMzp0z2in1eLYBXHG")
            .collection(col)
            .doc(element.id)
            .delete();
        print("$col delete $name succesfully");
        return;
      }
    });
  }
}
