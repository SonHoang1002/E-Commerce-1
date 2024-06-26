import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testecommerce/gradient/gradient.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:testecommerce/widget/notification_button.dart';
import 'package:testecommerce/widget/single_product.dart';

import '../models/product.dart';

class ListProduct extends StatelessWidget {
  String? name;
  late List<Product> list;
  late AsyncSnapshot<QuerySnapshot<Object?>>? snapshot;
  ListProduct(
      {required this.name,
      required this.list,
      AsyncSnapshot<QuerySnapshot<Object?>>? snapshot1});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            NotificationButton(
                // fromHomePage: false,
                ),
          ],
        ),
        body: Container(
          decoration: DecorationBackGround().buildDecoration(),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: ListView(
              children: [
                Column(
                  children: [
                    Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  name == null ? "Featured" : name!,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ]),
                    ),
                    Container(
                      height: 600,
                      child: GridView.count(
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 10,
                        scrollDirection: Axis.vertical,
                        crossAxisCount: 2,
                        children: list
                            .map((e) => SingleProduct(
                                name: e.name,
                                price: e.price,
                                image: e.image,
                                repo: e.repo))
                            .toList(),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}


// child: GridView.builder(
                    //   scrollDirection: Axis.vertical,
                    //   itemCount: snapshot.data!.docs.length,
                    //   itemBuilder: ((context, index) => SingleProduct(
                    //       name: snapshot.data!.docs[index]["category"],
                    //       price:
                    //           double.parse(snapshot.data!.docs[index]["price"]),
                    //       image: snapshot.data!.docs[index]["image"])),
                    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //       crossAxisCount: 2,
                    //       mainAxisSpacing: 10,
                    //       childAspectRatio: 0.7,
                    //       crossAxisSpacing: 10),
                    // ),