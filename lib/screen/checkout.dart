import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_dialog/custom_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/addition/format_input.dart';
import 'package:testecommerce/addition/pageRoute.dart';
import 'package:testecommerce/addition/unit_money.dart';
import 'package:testecommerce/gradient/gradient.dart';
import 'package:testecommerce/models/cartmodels.dart';
import 'package:testecommerce/models/product.dart';
import 'package:testecommerce/providers/general_provider.dart';
import 'package:http/http.dart' as http;
import 'package:testecommerce/screen/home_page.dart';
import 'dart:convert';
import 'package:testecommerce/widget/notification_button.dart';
import '../addition/timer.dart';

class CheckOut extends StatefulWidget {
  @override
  State<CheckOut> createState() => _CheckOutState();
}

TextEditingController cardNumber = TextEditingController();
TextEditingController expiry = TextEditingController();
TextEditingController cvv = TextEditingController();

TextEditingController verifyController = TextEditingController();

late GeneralProvider generalProvider;

class _CheckOutState extends State<CheckOut> {
  bool agri = false;
  bool mb = false;
  bool tp = false;
  bool us = false;
  bool viettin = false;

  bool isHasVerifyCode = false;
  bool isDola = true;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
    generalProvider = Provider.of<GeneralProvider>(context);
    Future<int> a = generalProvider.setUserModel();

    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: const Center(
          child: Text("Payment Invoice", style: TextStyle(color: Colors.black)),
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
        ],
      ),
      body: Container(
          decoration: DecorationBackGround().buildDecoration(),
          child: Column(children: [
            buildDetail("Name", generalProvider.userName),
            buildDetail("Email", generalProvider.userEmail),
            buildDetail("Phone", generalProvider.userPhone),
            buildDetail("Address", generalProvider.userAddress),
            // buildDetail("Test", "ghkjfhgdf kfdjghk kdjghkk kdfjghdfk"),
            const SizedBox(
              height: 20,
            ),
            const Center(
                child: Text(
              "Detail",
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 30),
            )),
            SizedBox(
              width: 250,
              height: 200,
              child: ListView(children: [
                DataTable(columns: const [
                  DataColumn(
                      label: Expanded(
                    child: Text(
                      "Quantity",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 15,
                      ),
                    ),
                  )),
                  DataColumn(
                      label: Expanded(
                    child: Text(
                      "Food Name",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 15,
                      ),
                    ),
                  ))
                ], rows: buildDataCell()),
              ]),
            ),
            buildDetail("Total", generalProvider.getTotal.toString()),
          ])),
      bottomSheet: buildBottomSheet(),
    );
  }

  List<DataRow> buildDataCell() {
    List<DataRow> list = [];
    int len = generalProvider.getCartModelListLength;
    for (int i = 0; i < len; i++) {
      list.add(DataRow(cells: [
        DataCell(Text(
          generalProvider.getCartModelList[i].quantity.toString(),
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        )),
        DataCell(Text(
          generalProvider.getCartModelList[i].name,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ))
      ]));
    }
    list.add(const DataRow(cells: [DataCell(Text("")), DataCell(Text(""))]));
    return list;
  }

  Widget buildBottomSheet() {
    return Container(
      height: 100,
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 150,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Navigator.of(context)
                //     .push(MaterialPageRoute(builder: (ctx) => CartScreen()));
                Navigator.of(context)
                    .push(PageRouteToScreen().pushToCartScreen());
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'CHECK AGAIN',
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: 150,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                // send();
                if (generalProvider.getTotal <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Your Cart Is Empty !!"),
                    backgroundColor: Colors.yellow,
                  ));
                  return;
                } else {
                  showModalBottomSheet(
                      context: context,
                      builder: (ctx) {
                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Center(
                                child: Text(
                                  "You Pay ${UnitMoney().convertMoney(generalProvider.getTotal, generalProvider.getMoneyIconName)} ${generalProvider.getMoneyIconName}",
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                              child: const Row(
                                children: [
                                  Text(
                                    "Select Bank",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  Divider(
                                    color: Colors.red,
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 130,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  Container(
                                    color: agri
                                        ? Colors.blue.withOpacity(0.5)
                                        : null,
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            agri = true;
                                            mb = false;
                                            tp = false;
                                            us = false;
                                            viettin = false;
                                          });
                                        },
                                        child: buildBankCard(
                                            "images/agri.png", "AgriBank")),
                                  ),
                                  Container(
                                    color: mb
                                        ? Colors.blue.withOpacity(0.5)
                                        : null,
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            agri = false;
                                            mb = true;
                                            tp = false;
                                            us = false;
                                            viettin = false;
                                          });
                                        },
                                        child: buildBankCard(
                                            "images/mb.png", "MB Bank")),
                                  ),
                                  Container(
                                    color: tp
                                        ? Colors.blue.withOpacity(0.5)
                                        : null,
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            agri = false;
                                            mb = false;
                                            tp = true;
                                            us = false;
                                            viettin = false;
                                          });
                                        },
                                        child: buildBankCard(
                                            "images/tp.jpg", "TP Bank")),
                                  ),
                                  Container(
                                    color: us
                                        ? Colors.blue.withOpacity(0.5)
                                        : null,
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            agri = false;
                                            mb = false;
                                            tp = false;
                                            us = true;
                                            viettin = false;
                                          });
                                        },
                                        child: buildBankCard(
                                            "images/us.png", "US Bank")),
                                  ),
                                  Container(
                                    color: viettin
                                        ? Colors.blue.withOpacity(0.5)
                                        : null,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          agri = false;
                                          mb = false;
                                          tp = false;
                                          us = false;
                                          viettin = true;
                                        });
                                      },
                                      child: buildBankCard(
                                          "images/vietin.jpg", "VietTin Bank"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                const Center(
                                    child: Text(
                                        "Enter your card number to pay")),
                                Container(
                                    width: 360,
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: TextFormField(
                                            controller: cardNumber,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              CustomInputFormatter()
                                            ],
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: "Card Number",
                                                labelText: "CARD NUMBER",
                                                hintStyle: TextStyle(
                                                    color: Colors.black)),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 0, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: 175,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 0, 0, 0),
                                                  child: TextFormField(
                                                    controller: expiry,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            hintText:
                                                                "Card Expiry",
                                                            labelText:
                                                                "CARD EXPIRY",
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .black)),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 175,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 10, 0),
                                                child: TextFormField(
                                                  controller: cvv,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration:
                                                      const InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          hintText: "Cvv",
                                                          labelText: "CVV",
                                                          hintStyle: TextStyle(
                                                              color: Colors
                                                                  .black)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 60,
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 0, 0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              validation();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.grey,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                "PAY",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                          ],
                        );
                      });
                }
              },
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'PAY',
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDetail(String startName, String endName) {
    //  buildDetail("Name", generalProvider.userName),
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 30,
                ),
                Text(
                  startName,
                  style: const TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: Text(
                startName == "Total"
                    ? "${UnitMoney().convertMoney(double.parse(endName), generalProvider.getMoneyIconName)} ${generalProvider.getMoneyIconName}"
                    : endName,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> send() async {
    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    String mes = ''' 
     Name                 : ${generalProvider.getUserModelName} \n
     Email                : ${generalProvider.getUserModelEmail} \n
     Phone                : ${generalProvider.getUserModelPhone}  \n
     Address              : ${generalProvider.getUserModelAddress} \n
     Total                : ${generalProvider.getTotal}     \n
     ''';

    //Quantity Of Products : quantity1 \n
    try {
      final response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            "origin": "http://localhost"
          },
          body: json.encode({
            "service_id": "service_epn6lva",
            "template_id": "template_34vsgep",
            "user_id": "XODjifkQVe_sJaakG",
            "template_params": {
              "to_email": "${generalProvider.getUserModelEmail}",
              "from_email": "H&HFood@gmail.com",
              "from_name": "H&H FOOD",
              "to_name": "${generalProvider.getUserModelName}",
              "name": "${generalProvider.getUserModelName}",
              "phone": "${generalProvider.getUserModelPhone}",
              "address": "${generalProvider.getUserModelAddress}",
              "quantityOfProduct": "${generalProvider.getCartModelListLength}",
              "total": "${generalProvider.getTotal}"
            }
          }));
      print(response.body);
    } catch (error) {
      print("ERROR: ${error}");
    }
  }

  Widget buildBankCard(String img, String name) {
    return SizedBox(
        // color: Colors.blue.withOpacity(20),
        width: 120.0,
        child: Column(
          children: [
            Container(
              // padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              width: 100,
              height: 100,
              decoration: const BoxDecoration(),
              // borderRadius: BorderRadius.circular(30), color: Colors.red),
              child: Image.asset(
                img,
                height: 80,
                width: 80,
              ),
            ),
            Center(
              child: Text(
                name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ));
  }

  validation() {
    if (mb == false &&
        viettin == false &&
        us == false &&
        tp == false &&
        agri == false) {
      showDialogWithWarning(context, "You don't choose bank category");
      return;
    } else if (cvv.text.isEmpty) {
      showDialogWithWarning(context, "Cvv Is Empty");
      return;
    } else if (expiry.text.isEmpty) {
      showDialogWithWarning(context, "Card Expiry Is Empty");
      return;
    } else if (cvv.text.isEmpty &&
        cardNumber.text.isEmpty &&
        expiry.text.isEmpty) {
      showDialogWithWarning(context, "Both Field Are Empty");
      return;
    } else {
      Navigator.of(context).pop();
      sendVerifyCode();
      _showVerifyModalBottomSheet(context);
    }
  }

  _showPaymentDialogSuccesfull(BuildContext context) async {
    generalProvider.updateRepo(generalProvider.getCartModelList); ////// s
    Navigator.of(context).push(CupertinoPageRoute(
        builder: (_) =>
            HomePage(nameList: generalProvider.getNameProductList)));
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        content: const Text(
          'Payment Successfull',
          style: TextStyle(
              fontWeight: FontWeight.w900, fontSize: 20.0, color: Colors.black),
        ),
        title: const Text(''),
        firstColor: const Color(0xFF3CCF57),
        secondColor: Colors.white,
        headerIcon: const Icon(
          Icons.check_circle_outline,
          size: 120.0,
          color: Colors.white,
        ),
      ),
    );

    await setCustomerAndTotalRevenue();
    await send();
    await analysistProduct();
    //reset any state in provider

    generalProvider.setTotalRenenue();
    generalProvider.reSetVerifyCode();
    generalProvider.setCartModelList([]);
    generalProvider.resetPromo();
    generalProvider.setTotal(0);
  }

  showDialogWithWarning(BuildContext context, String message) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('WARNING !!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _showVerifyDialog(BuildContext context) async {
    // buildTimeOutForResetPassword();
    return showDialog(
        context: context,
        builder: (ctx) {
          // sendVerifyCode();
          FocusManager.instance.primaryFocus?.unfocus();
          return AlertDialog(
            title: const Text(
              "Enter Verify Code From Your Email",
              textAlign: TextAlign.center,
            ),
            content: SizedBox(
              height: 100,
              child: Column(
                children: [
                  TextFormField(
                    controller: verifyController,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 6,
                  ),
                ],
              ),
            ),
            actions: [
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      if (verifyController.text.trim().length != 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Verify code must has 6 chracters")));
                        return;
                      }
                      if (verifyController.text.trim() ==
                          generalProvider.getVerifyCode) {
                        setState(() {
                          isHasVerifyCode = true;
                        });
                        FocusManager.instance.primaryFocus?.unfocus();
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                            PageRouteToScreen().pushToResetPasswordScreen());
                        return;
                      } else {
                        setState(() {
                          isHasVerifyCode = true;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Invalid Verify Code")));
                        return;
                      }
                    },
                    child: const Text("SEND")),
              )
            ],
          );
        });
  }

  void _showVerifyModalBottomSheet(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Column(
              children: [
                const Text(
                  "Enter Verify Code From Your Email",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(
                  height: 80,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: verifyController,
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 6,
                      ),
                    ],
                  ),
                ),
                Center(
                  child: ElevatedButton(
                      onPressed: () {
                        if (verifyController.text.trim().length != 6) {
                          showDialogWithWarning(
                              context, "Verify code must has 6 chracters");
                          return;
                        }
                        if (verifyController.text.trim() ==
                            generalProvider.getVerifyCode) {
                          FocusManager.instance.primaryFocus?.unfocus();
                          Navigator.of(context).pop();
                          _showPaymentDialogSuccesfull(context);
                          generalProvider.addNotiList(
                              "${getTime()}: You Have Already Paid Successfully ");
                          setState(() {
                            expiry.text = "";
                            cardNumber.text = "";
                            cvv.text = "";

                            mb = false;
                            tp = false;
                            viettin = false;
                            us = false;
                            agri = false;
                          });
                          return;
                        } else {
                          showDialogWithWarning(context, "Invalid Verify Code");
                          return;
                        }
                      },
                      child: const Text("SEND")),
                )
              ],
            ),
          );
        });
  }

  Future<void> sendVerifyCode() async {
    if (generalProvider.getVerifyCode == "") {
      final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
      String message = "";
      for (int i = 0; i < 6; i++) {
        message += Random().nextInt(9).toString();
      }
      generalProvider.setVerifyCode(message);
      print(message);
      try {
        final response = await http.post(url,
            headers: {
              "Content-Type": "application/json",
              "origin": "http://localhost"
            },
            body: json.encode({
              "service_id": "service_orfalor",
              "template_id": "template_hhf5y2i",
              "user_id": "sduv4yQPMsaNfNmjJ",
              "template_params": {
                "to_email": "${generalProvider.getUserModelEmail}",
                "from_email": "H&HFood@gmail.com",
                "from_name": "H&H FOOD",
                "to_name": "you",
                "message": message
              }
            }));
        print(response.body);
      } catch (error) {
        print("ERROR: ${error}");
      }
    }
  }

  Future<void> setCustomerAndTotalRevenue() async {
    await FirebaseFirestore.instance
        .collection("TotalRevenue")
        .doc("9EC0nIWg6Da6RaYG5cm8")
        .collection("bill")
        .add({
      "idUser": FirebaseAuth.instance.currentUser!.uid,
      "listOfProduct": generalProvider.getCartModelListListName,
      "purchaseTime": getTime().toString(),
      "total": generalProvider.getTotal
    });
    print("add user to bills ok");
    String money = (double.parse(generalProvider.getTotalRenenue) +
            generalProvider.getTotal)
        .toString();

    await FirebaseFirestore.instance
        .collection("TotalRevenue")
        .doc("9EC0nIWg6Da6RaYG5cm8")
        .collection("tr")
        .doc("W5hd5BaRmYrhNAySeeq3")
        .update({"totalMoney": money});
    print("add bill to totalRevenue $money");
  }

  Future<void> analysistProduct() async {
    late int snack, drink, news, east, asia, featured, water;
    List<CartModel> list = generalProvider.getCartModelList;
    QuerySnapshot<Object?> snapshot = await FirebaseFirestore.instance
        .collection("TotalRevenue")
        .doc("9EC0nIWg6Da6RaYG5cm8")
        .collection("analystProduct")
        .get();
    snapshot.docs.forEach((element) {
      snack = int.parse(element["Snack"]);
      water = int.parse(element["Water"]);
      asia = int.parse(element["Asia"]);
      featured = int.parse(element["Featured"]);
      news = int.parse(element['New']);
      drink = int.parse(element["Drink"]);
      east = int.parse(element["East"]);
    });

    for (int i = 0; i < list.length; i++) {
      if (checkNameProductWithList(generalProvider.getSnack(), list[i].name)) {
        snack += list[i].quantity;
        print("update Snack List: ${snack} products");
      }
      if (checkNameProductWithList(
          generalProvider.getWaterDish(), list[i].name)) {
        water += list[i].quantity;
        print("update Water List: ${water} products");
      }
      if (checkNameProductWithList(
          generalProvider.getListAsia(), list[i].name)) {
        asia += list[i].quantity;
        print("update Asia List: ${asia} products");
      }
      if (checkNameProductWithList(
          generalProvider.getFeatureProduct(), list[i].name)) {
        featured += list[i].quantity;
        print("update Featured List: ${featured} products");
      }
      if (checkNameProductWithList(
          generalProvider.getNewProduct(), list[i].name)) {
        news += list[i].quantity;
        print("update New List: ${news} products");
      }
      if (checkNameProductWithList(
          generalProvider.getListDrink(), list[i].name)) {
        drink += list[i].quantity;
        print("update Drink List: ${drink} products");
      }
      if (checkNameProductWithList(
          generalProvider.getEastDish(), list[i].name)) {
        east += list[i].quantity;
        print("update East List: ${east} products");
      }
    }
    FirebaseFirestore.instance
        .collection("TotalRevenue")
        .doc("9EC0nIWg6Da6RaYG5cm8")
        .collection("analystProduct")
        .doc("bMgdLeyriRz8LtdoWVOL")
        .update({
      "Asia": asia.toString(),
      "Drink": drink.toString(),
      "Snack": snack.toString(),
      "East": east.toString(),
      "New": news.toString(),
      "Featured": featured.toString(),
      "Water": water.toString()
    });
    print(
        "Update Asia :$asia, Drink: $drink, Snack: $snack, East: $east, New: $news, Featured: $featured, Water: $water");
  }

  bool checkNameProductWithList(List<Product> listOfProduct, String name) {
    for (int i = 0; i < listOfProduct.length; i++) {
      if (listOfProduct[i].name == name) {
        return true;
      }
    }
    return false;
  }
}

  // Widget buildCart() {
  //   return Container(
  //     height: 220,
  //     width: double.infinity,
  //     child: Card(
  //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //         Row(
  //           children: [
  //             Container(
  //               height: 180,
  //               width: 150,
  //               decoration: BoxDecoration(
  //                   image: DecorationImage(
  //                       image: NetworkImage(
  //                           "${widget.img == null ? "" : widget.img}"),
  //                       fit: BoxFit.fill)),
  //             ),
  //             Container(
  //               height: 200,
  //               width: 200,
  //               child: ListTile(
  //                 title: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   children: [
  //                     const Text(
  //                       widget.name == null ? "Demo1" : widget.name,
  //                       style: const TextStyle(
  //                           color: Colors.blue,
  //                           fontStyle: FontStyle.italic,
  //                           fontSize: 25),
  //                     ),
  //                     const Text(
  //                       "Category: ",
  //                       style: const TextStyle(
  //                           color: Colors.green,
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 20),
  //                     ),
  //                     const Text(
  //                       "Size: ",
  //                       style: const TextStyle(
  //                           color: Colors.redAccent,
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 13),
  //                     ),
  //                     const Text(
  //                       "Price: ${widget.price * quantity} ",
  //                       style: const TextStyle(
  //                           color: Colors.redAccent,
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 15),
  //                     ),
  //                     Container(
  //                       height: 30,
  //                       width: 100,
  //                       decoration: BoxDecoration(
  //                           color: Colors.grey[100],
  //                           borderRadius: BorderRadius.circular(20)),
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [const Text("Quantity"), const Text("1")],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             )
  //           ],
  //         ),
  //       ]),
  //     ),
  //   );
  // }


// Row(
            //   children: [
            //     endName.length < 20
            //         ? (startName == "Total")
            //             ? Row(
            //                 children: [
            //                   IconButton(
            //                       onPressed: () {
            //                         setState(() {
            //                           isDola = !isDola;
            //                         });
            //                       },
            //                       icon: const Icon(Icons.change_circle_rounded)),
            //                   const Text(
            //                     isDola ? "${endName} ${generalProvider.getMoneyIconName}": "${(double.parse(endName)*23000).round()} \đ",
            //                     overflow: TextOverflow.ellipsis,
            //                     style: const TextStyle(
            //                         fontSize: 18,
            //                         fontWeight: FontWeight.bold,
            //                         color: Colors.black),
            //                   )
            //                 ],
            //               )
            //             : const Text(
            //                 "${endName}",
            //                 overflow: TextOverflow.ellipsis,
            //                 style: const TextStyle(
            //                     fontSize: 18,
            //                     fontWeight: FontWeight.bold,
            //                     color: Colors.black),
            //               )
            //         : Container(
            //             width: 180,
            //             child: const Text(
            //               endName,
            //               overflow: TextOverflow.ellipsis,
            //               style: const TextStyle(
            //                   fontSize: 18,
            //                   fontWeight: FontWeight.bold,
            //                   color: Colors.black),
            //             ),
            //           ),
            //     const SizedBox(
            //       width: 30,
            //     )
            //   ],
            // )