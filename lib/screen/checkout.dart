import 'dart:math';

import 'package:custom_dialog/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/addition/formatInput.dart';
import 'package:testecommerce/addition/pageRoute.dart';
import 'package:testecommerce/gradient/gradient.dart';
import 'package:testecommerce/providers/general_provider.dart';
import 'package:testecommerce/screen/cartscreen.dart';
import 'package:http/http.dart' as http;
import 'package:testecommerce/screen/homePage.dart';
import 'dart:convert';

import 'package:testecommerce/widget/notificationButton.dart';

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

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
    generalProvider = Provider.of<GeneralProvider>(context);
    Future<int> a = generalProvider.setUserModel();

    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Center(
          child: Text("Payment Invoice", style: TextStyle(color: Colors.black)),
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
        actions: [NotificationButton()],
      ),
      body: Container(
          decoration: DecorationBackGround().buildDecoration(),
          child: Column(children: [
            buildDetail("Name", generalProvider.userName),
            buildDetail("Email", generalProvider.userEmail),
            buildDetail("Phone", generalProvider.userPhone),
            buildDetail("Address", generalProvider.userAddress),
            // buildDetail("Test", "ghkjfhgdf kfdjghk kdjghkk kdfjghdfk"),
            SizedBox(
              height: 20,
            ),
            Center(
                child: Text(
              "Detail",
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 30),
            )),
            Container(
              width: 250,
              height: 200,
              child: ListView(children: [
                DataTable(columns: [
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
            buildDetail("Total", "${generalProvider.getTotal.toString()} \$"),
          ])),
      bottomSheet: buildBottomSheet(),
    );
  }

  List<DataRow> buildDataCell() {
    List<DataRow> list = [];
    int len = generalProvider.getCartModelLength;
    for (int i = 0; i < len; i++) {
      list.add(DataRow(cells: [
        DataCell(Text(
          generalProvider.getCartModel[i].quantity.toString(),
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        )),
        DataCell(Text(
          generalProvider.getCartModel[i].name,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ))
      ]));
    }
    list.add(DataRow(cells: [DataCell(Text("")), DataCell(Text(""))]));
    return list;
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
  //                     Text(
  //                       widget.name == null ? "Demo1" : widget.name,
  //                       style: TextStyle(
  //                           color: Colors.blue,
  //                           fontStyle: FontStyle.italic,
  //                           fontSize: 25),
  //                     ),
  //                     Text(
  //                       "Category: ",
  //                       style: TextStyle(
  //                           color: Colors.green,
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 20),
  //                     ),
  //                     Text(
  //                       "Size: ",
  //                       style: TextStyle(
  //                           color: Colors.redAccent,
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 13),
  //                     ),
  //                     Text(
  //                       "Price: ${widget.price * quantity} ",
  //                       style: TextStyle(
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
  //                         children: [Text("Quantity"), Text("1")],
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

  Widget buildBottomSheet() {
    return Container(
      height: 100,
      width: double.infinity,
      margin: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
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
              child: Column(
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
          Container(
            width: 150,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                // send();
                if (generalProvider.getTotal <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Your Cart Is Empty !!"),
                    backgroundColor: Colors.yellow,
                  ));
                  return;
                } else {
                  showModalBottomSheet(
                      context: context,
                      builder: (ctx) {
                        return Container(
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Center(
                                  child: Text(
                                    "You Pay ${generalProvider.getTotal}\$",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Select Bank",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontStyle: FontStyle.italic),
                                    ),
                                    Container(
                                        child: Divider(
                                      color: Colors.red,
                                      height: 40,
                                    )),
                                  ],
                                ),
                              ),
                              Container(
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
                                            "images/vietin.jpg",
                                            "VietTin Bank"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Container(
                                    child: Center(
                                        child: Text(
                                            "Enter your card number to pay")),
                                  ),
                                  Container(
                                      width: 360,
                                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            controller: cardNumber,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              CustomInputFormatter()
                                            ],
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: "Card Number",
                                                labelText: "CARD NUMBER",
                                                hintStyle: TextStyle(
                                                    color: Colors.black)),
                                          ),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 10, 0, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: 175,
                                                  child: TextFormField(
                                                    controller: expiry,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration: InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText: "Card Expiry",
                                                        labelText:
                                                            "CARD EXPIRY",
                                                        hintStyle: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                ),
                                                Container(
                                                  width: 175,
                                                  child: TextFormField(
                                                    controller: cvv,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration: InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText: "Cvv",
                                                        labelText: "CVV",
                                                        hintStyle: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 60,
                                            padding: EdgeInsets.fromLTRB(
                                                0, 10, 0, 0),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                validation();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.grey,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                              child: Center(
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
                          ),
                        );
                      });
                }
              },
              child: Column(
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
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                Text(
                  startName,
                  style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              children: [
                endName.length < 20
                    ? Text(
                        endName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      )
                    : Container(
                        width: 180,
                        child: Text(
                          endName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                SizedBox(
                  width: 30,
                )
              ],
            )
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
              "to_email": "kingmountain117@gmail.com",
              "from_email": "H&HFood@gmail.com",
              "from_name": "H&H FOOD",
              "to_name": "${generalProvider.getUserModelName}",
              "name": "${generalProvider.getUserModelName}",
              "phone": "${generalProvider.getUserModelPhone}",
              "address": "${generalProvider.getUserModelAddress}",
              "quantityOfProduct": "${generalProvider.getCartModelLength}",
              "total": "${generalProvider.getTotal}"
            }
          }));
      print(response.body);
    } catch (error) {
      print("ERROR: ${error}");
    }
  }

  Widget buildBankCard(String img, String name) {
    return Container(
        // color: Colors.blue.withOpacity(20),
        width: 120.0,
        child: Column(
          children: [
            Container(
              // padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              width: 100,
              height: 100,
              decoration: BoxDecoration(),
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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

  _showPaymentDialog(BuildContext context) {
    // send();
    resetCart();
    Navigator.of(context).push(CupertinoPageRoute(
        builder: (_) =>
            HomePage(nameList: generalProvider.getNameProductList)));
    return showDialog(
      context: context,
      builder: (context) => CustomDialog(
        content: Text(
          'Payment Successfull',
          style: TextStyle(
              fontWeight: FontWeight.w900, fontSize: 20.0, color: Colors.black),
        ),
        title: Text(''),
        firstColor: Color(0xFF3CCF57),
        secondColor: Colors.white,
        headerIcon: Icon(
          Icons.check_circle_outline,
          size: 120.0,
          color: Colors.white,
        ),
      ),
    );
  }

  void resetCart() {
    generalProvider.setCartModelList([]);
    generalProvider.setTotal(0);
  }

  showDialogWithWarning(BuildContext context, String message) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('WARNING !!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
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
            title: Text(
              "Enter Verify Code From Your Email",
              textAlign: TextAlign.center,
            ),
            content: Container(
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
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Verify code must has 6 chracters")));
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
                            SnackBar(content: Text("Invalid Verify Code")));
                        return;
                      }
                    },
                    child: Text("SEND")),
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
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Column(
              children: [
                Text(
                  "Enter Verify Code From Your Email",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30),
                ),
                Container(
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
                          _showPaymentDialog(context);
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
                      child: Text("SEND")),
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
              "to_email": "kingmountain117@gmail.com",
              "from_email": "H&HFood@gmail.com",
              "from_name": "H&H FOOD",
              "to_name": "you",
              "message": message
            }
          }));
          //213637
      print(response.body);
    } catch (error) {
      print("ERROR: ${error}");
    }
    }
  }
}
