import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/addition/pageRoute.dart';
import 'package:testecommerce/addition/timer.dart';
import 'package:testecommerce/addition/unit_money.dart';
import 'package:testecommerce/gradient/gradient.dart';
import 'package:testecommerce/widget/cart_single_product.dart';
import 'package:testecommerce/widget/notification_button.dart';

import '../providers/general_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

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
        title: const Center(
          child: Text("Cart", style: TextStyle(color: Colors.black)),
        ),
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
          // IconButton(
          //   icon: const Icon(
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
                itemCount: generalProvider.getCartModelListLength,
                itemBuilder: (context, index) {
                  return CartSingleProduct(
                      name: generalProvider.getCartModelList[index].name,
                      price: generalProvider.getCartModelList[index].price,
                      img: generalProvider.getCartModelList[index].img,
                      quantity:
                          generalProvider.getCartModelList[index].quantity,
                      repo: generalProvider.getCartModelList[index].repo);
                },
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: Container(
      //   height: 50,
      //   width: 100,
      //   margin: const EdgeInsets.all(20),
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
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Container(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildDeatail(const Icon(Icons.price_change), "Price",
                        "${UnitMoney().convertMoney(generalProvider.getPrice, generalProvider.getMoneyIconName)} ${generalProvider.getMoneyIconName}"),
                    buildDeatail(const Icon(Icons.discount), "Discount (-10%)",
                        "-${UnitMoney().convertMoney(generalProvider.getDiscount, generalProvider.getMoneyIconName)} ${generalProvider.getMoneyIconName}"),
                    buildDeatail(const Icon(Icons.local_shipping), "Shipping",
                        "+${UnitMoney().convertMoney(generalProvider.getShipping, generalProvider.getMoneyIconName)} ${generalProvider.getMoneyIconName}"),
                    Container(
                      width: 380,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  const Icon(Icons.money),
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text("Total: "),
                                          Text(
                                              // ignore: unnecessary_null_comparison
                                              "${total == null ? 0 : UnitMoney().convertMoney(total, generalProvider.getMoneyIconName)} ${generalProvider.getMoneyIconName}")
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
                                                        .getCartModelListLength;
                                                i++) {
                                              value += (generalProvider
                                                      .getCartModelList[i]
                                                      .quantity *
                                                  generalProvider
                                                      .getCartModelList[i]
                                                      .price);
                                            }
                                            generalProvider.setPromo(0);
                                            generalProvider.setTotal(value);

                                            setState(() {
                                              showRemovePromoButton = false;
                                              // promo = "Add Promo";
                                            });
                                          },
                                          icon: const Icon(
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

  //
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
                    margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
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
      margin: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: () async {
          // Navigator.of(context)
          //     .push(CupertinoPageRoute(builder: (ctx) => CheckOut()));
          generalProvider.setCartModelListName();
          //
          // final list = await checkEmailHaveAnyAccount();
          // if(list.length>1){
          //    Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (_)=> WarningFromName(listOfName: list,)));
          // }else{
          Navigator.of(context)
              .push(PageRouteToScreen().pushToCheckOutScreen());
          // }
          //
          if (generalProvider.getIsUpdateForCartProduct) {
            generalProvider.addNotiList(
                "${getTime()}: You have already updated quantity any product");
          }
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
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
          title: const Text('Select discount rate'),
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
            for (int i = 0; i < generalProvider.getCartModelListLength; i++) {
              value += (generalProvider.getCartModelList[i].quantity *
                  generalProvider.getCartModelList[i].price);
            }
            generalProvider.setPromo(0);
            generalProvider.setTotal(value);
          } else {
            setState(() {
              double subTotal = 0;
              showRemovePromoButton = true;
              promo = "-" + message + "%";
              for (int i = 0; i < generalProvider.getCartModelListLength; i++) {
                subTotal += (generalProvider.getCartModelList[i].quantity *
                    generalProvider.getCartModelList[i].price);
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

  Future<List<String>> checkEmailHaveAnyAccount() async {
    List<String> listOfName = [];
    QuerySnapshot<Object?> snapshot =
        await FirebaseFirestore.instance.collection("User").get();
    snapshot.docs.forEach((element) {
      if (element["UserEmail"] == generalProvider.getEmailFromLogin) {
        listOfName.add(element['UserName']);
      }
    });
    print(listOfName.toList());
    return listOfName;
  }
}
