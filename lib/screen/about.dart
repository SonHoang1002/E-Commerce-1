import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/gradient/gradient.dart';
import 'package:testecommerce/models/product.dart';
import 'package:testecommerce/providers/product_provider.dart';
import 'package:testecommerce/screen/checkout.dart';
import 'package:testecommerce/screen/homepage.dart';
import 'package:testecommerce/widget/cartsingleproduct.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../providers/general_provider.dart';

class About extends StatefulWidget {
  @override
  State<About> createState() => _AboutState();
}

// late GeneralProvider generalProvider;

class _AboutState extends State<About> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // generalProvider = Provider.of<GeneralProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("About", style: TextStyle(color: Colors.black)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(
        //       Icons.notifications,
        //       color: Colors.red,
        //     ),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: Container(
        decoration: DecorationBackGround().buildDecoration(),
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: ListView(
            children: [
              Column(
                children: [
                  Center(
                    child: Text("H&H FOOD",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            fontFamily: "DynaPuff")),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Text('''
           H&H FOOD is stands for Healthy and Happy FOOD, with the principle of bringing an extremely rich variety of really quality and nutritional products to users through a system of products that are tested daily and provided with certificates. food safety permits of countries.
          
          We are committed to giving our customers an unforgettable experience when shopping at our address
                      ''',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                          )),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.streetview),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Address Of Their Headquarters:",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
                    child: Center(
                      child: Text(
                          "No.207, Giai Phong Street, Dong Tam Ward, Hai Ba Trung District, Ha Noi, Viet Nam",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            // color: Colors.greenAccent,
                            fontSize: 20,
                            fontStyle: FontStyle.normal,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () async {
                      String address = "207 Giai Phong";
                      String googleUrl =
                          'https://www.google.com/maps/search/?api=1&query=$address';
                      await launchUrlString(googleUrl);
                    },
                    child: Image.asset(
                      "images/map.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Icon(Icons.timelapse),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Opening - Closing Time:",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 150, 0),
                    child: Text("8.00 AM - 6.30 PM",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          // color: Colors.greenAccent,
                          fontSize: 20,
                          fontStyle: FontStyle.normal,
                        )),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Icon(Icons.people),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Member Number:",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 215, 0),
                    child: Text("8 members",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          // color: Colors.greenAccent,
                          fontSize: 20,
                          fontStyle: FontStyle.normal,
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
          //Container(
          //   height: 460,
          //   width: double.infinity,
          //   child: ListView.builder(
          //     itemCount: generalProvider.getCartModelLength,
          //     itemBuilder: (context, index) {
          //       return CartSingleProduct(
          //           name: generalProvider.getCartModel[index].name,
          //           price: generalProvider.getCartModel[index].price,
          //           img: generalProvider.getCartModel[index].img,
          //           quantity: generalProvider.getCartModel[index].quantity);
          //     },
          //   ),
          // ),