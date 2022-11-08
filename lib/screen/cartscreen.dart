import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/addition/pageRoute.dart';
import 'package:testecommerce/gradient/gradient.dart';
import 'package:testecommerce/models/product.dart';
import 'package:testecommerce/providers/product_provider.dart';
import 'package:testecommerce/screen/checkout.dart';
import 'package:testecommerce/screen/homepage.dart';
import 'package:testecommerce/widget/cartsingleproduct.dart';
import 'package:testecommerce/widget/notificationButton.dart';

import '../providers/general_provider.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // late ProductProvider productProvider;
  late GeneralProvider generalProvider;

  int quantity = 1;
  double total = 0;
  late String promo = "Add promo";
  bool showRemovePromoButton = false;
  @override
  Widget build(BuildContext context) {
    generalProvider = Provider.of<GeneralProvider>(context);
    total = generalProvider.getTotal;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Cart", style: TextStyle(color: Colors.black)),
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
        actions: [
          NotificationButton(
            // fromHomePage: false,
          ),
          // IconButton(
          //   icon: Icon(
          //     Icons.shopping_cart,
          //     color: Colors.black,
          //   ),
          //   onPressed: () {},
          // ),
        ],
      ),
      body: Container(
        decoration: DecorationBackGround().buildDecoration(),
        child: Column(
          children: [
            Container(
              height: 390,
              width: double.infinity,
              child: ListView.builder(
                itemCount: generalProvider.getCartModelLength,
                itemBuilder: (context, index) {
                  return CartSingleProduct(
                      name: generalProvider.getCartModel[index].name,
                      price: generalProvider.getCartModel[index].price,
                      img: generalProvider.getCartModel[index].img,
                      quantity: generalProvider.getCartModel[index].quantity);
                },
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: Container(
      //   height: 50,
      //   width: 100,
      //   margin: EdgeInsets.all(20),
      //   child: RaisedButton(
      //     onPressed: () {},
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //       children: [Text("Total: "), Text('CHECK OUT')],
      //     ),
      //   ),
      // ),
      bottomSheet: Container(
          height: 290,
          child: Column(
            children: [
              Container(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildDeatail(Icon(Icons.price_change), "Price",
                        "${generalProvider.getPrice} \$"),
                    buildDeatail(Icon(Icons.discount), "Discount (-10%)",
                        "-${generalProvider.getDiscount} \$"),
                    buildDeatail(Icon(Icons.local_shipping), "Shipping",
                        "+${generalProvider.getShipping} \$"),
                    Container(
                      width: 380,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Icon(Icons.money),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text("Total: "),
                                          Text(
                                              "${total == null ? 0 : total} \$")
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _showMyDialog();
                              },
                              child: Container(
                                  child: Row(
                                children: [
                                  Text(generalProvider.getPromo == 0
                                      ? "Add Promo"
                                      : "-${generalProvider.getPromo}%"),
                                  generalProvider.getPromo != 0
                                      ? IconButton(
                                          onPressed: () {
                                            double value = 0;
                                            for (int i = 0;
                                                i <
                                                    generalProvider
                                                        .getCartModelLength;
                                                i++) {
                                              value += (generalProvider
                                                      .getCartModel[i]
                                                      .quantity *
                                                  generalProvider
                                                      .getCartModel[i].price);
                                            }
                                            generalProvider.setPromo(0);
                                            generalProvider.setTotal(value);

                                            setState(() {
                                              showRemovePromoButton = false;
                                              // promo = "Add Promo";
                                            });
                                          },
                                          icon: Icon(
                                            Icons.cancel,
                                            size: 15,
                                          ))
                                      : Container()
                                ],
                              )),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              buildButtonCheckOut(),
            ],
          )),
    );
  }

  Widget buildDeatail(Icon icon, String startName, String endName) {
    return Container(
      width: 380,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  icon,
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(startName),
                        ]),
                  ),
                ],
              ),
            ),
            Text(endName)
          ],
        ),
      ),
    );
  }

  Widget buildButtonCheckOut() {
    return Container(
      height: 50,
      width: 700,
      margin: EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: () {
          // Navigator.of(context)
          //     .push(CupertinoPageRoute(builder: (ctx) => CheckOut()));
          Navigator.of(context)
              .push(PageRouteToScreen().pushToCheckOutScreen());
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'BUY ',
              style: TextStyle(color: Colors.black, fontSize: 20),
            )
          ],
        ),
      ),
    );
  }

  void _showMyDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select assignment'),
          children: <Widget>[
            buildSimpleDialogOption('15'),
            buildSimpleDialogOption('25'),
            buildSimpleDialogOption('30'),
            buildSimpleDialogOption('35'),
            buildSimpleDialogOption('40'),
            buildSimpleDialogOption('None')
          ],
        );
      },
    );
  }

  Widget buildSimpleDialogOption(String message) {
    return SimpleDialogOption(
      child: GestureDetector(
        child: Text(message),
        onTap: () {
          if (message == "None") {
            Navigator.of(context).pop();
            generalProvider.setPromo(0);
            double value = 0;
            for (int i = 0; i < generalProvider.getCartModelLength; i++) {
              value += (generalProvider.getCartModel[i].quantity *
                  generalProvider.getCartModel[i].price);
            }
            generalProvider.setPromo(0);
            generalProvider.setTotal(value);
          } else {
            setState(() {
              double subTotal = 0;
              showRemovePromoButton = true;
              promo = "-" + message + "%";
              for (int i = 0; i < generalProvider.getCartModelLength; i++) {
                subTotal += (generalProvider.getCartModel[i].quantity *
                    generalProvider.getCartModel[i].price);
              }
              generalProvider.setPromo(double.parse(message));
              generalProvider.setTotal(subTotal);
            });
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
