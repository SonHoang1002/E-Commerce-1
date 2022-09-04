import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/models/product.dart';
import 'package:testecommerce/providers/product_provider.dart';
import 'package:testecommerce/screen/checkout.dart';
import 'package:testecommerce/screen/homepage.dart';
import 'package:testecommerce/widget/cartsingleproduct.dart';

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
            IconButton(
              icon: Icon(
                Icons.notifications,
                color: Colors.red,
              ),
              onPressed: () {},
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
        body: Column(
          children: [
            Container(
              height: 560,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(Icons.money),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Total: "),
                              Text("${total == null ? 0 : total} \$")
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
                      margin: EdgeInsets.all(20),
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
                                        i < generalProvider.getCartModelLength;
                                        i++) {
                                      value += (generalProvider
                                              .getCartModel[i].quantity *
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
            )
          ],
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
        bottomSheet: buildBottomSheet());
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
  //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                         children: [
  //                           GestureDetector(
  //                             child: Icon(
  //                               Icons.remove,
  //                               color: Colors.black,
  //                             ),
  //                             onTap: () {
  //                               setState(() {
  //                                 if (quantity > 0) {
  //                                   quantity -= 1;
  //                                 } else {
  //                                   quantity = 0;
  //                                 }
  //                               });
  //                             },
  //                           ),
  //                           Text(
  //                             "${quantity}",
  //                             style:
  //                                 TextStyle(color: Colors.black, fontSize: 20),
  //                           ),
  //                           GestureDetector(
  //                             child: Icon(
  //                               Icons.add,
  //                               color: Colors.black,
  //                             ),
  //                             onTap: () {
  //                               setState(() {
  //                                 quantity += 1;
  //                               });
  //                             },
  //                           ),
  //                         ],
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
      height: 50,
      width: 700,
      margin: EdgeInsets.all(20),
      child: RaisedButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (ctx) => CheckOut()));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [Text('CHECK OUT')],
        ),
      ),
    );
  }

  void CountTotal() {
    for (int i = 0; i < generalProvider.getCartModelLength; i++) {
      total += (generalProvider.getCartModel[i].quantity *
          generalProvider.getCartModel[i].price);
    }
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
            buildSimpleDialogOption('40')
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
          setState(() {
            double subTotal = 0;
            showRemovePromoButton = true;
            promo = "-" + message + "%";
            generalProvider.setPromo(0);
            for (int i = 0; i < generalProvider.getCartModelLength; i++) {
              subTotal += (generalProvider.getCartModel[i].quantity *
                  generalProvider.getCartModel[i].price);
            }
            generalProvider.setTotal(0);
            generalProvider
                .setTotal(subTotal * (1 - double.parse(message) / 100));
            generalProvider.setPromo(double.parse(message));
          });

          Navigator.of(context).pop();
        },
      ),
    );
  }
}

//Container(
//   height: 40,
//   width: 100,
//   child: RaisedButton(
//     onPressed: () {},
//     shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(0)),
//     child: Center(
//         child: Text(
//       "CHECK OUT",
//       style:
//           TextStyle(color: Colors.white, fontSize: 12),
//     )),
//     color: Colors.red,
//   ),
// )
