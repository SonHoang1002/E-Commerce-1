import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/addition/timer.dart';
import 'package:testecommerce/models/cartmodels.dart';
import 'package:testecommerce/providers/general_provider.dart';
import 'package:testecommerce/providers/product_provider.dart';
import 'package:testecommerce/screen/checkout.dart';
import 'package:testecommerce/screen/homepage.dart';

class CartSingleProduct extends StatefulWidget {
  late String name;
  late double price;
  late int quantity;
  late String img;
  late int repo;

  CartSingleProduct(
      {required this.name,
      required this.price,
      required this.img,
      required this.quantity,
      required this.repo});

  @override
  State<CartSingleProduct> createState() => _CartSingleProductState();
}

late GeneralProvider generalProvider;

class _CartSingleProductState extends State<CartSingleProduct> {
  @override
  Widget build(BuildContext context) {
    generalProvider = Provider.of<GeneralProvider>(context);
    return Container(
      height: 210,
      width: double.infinity,
      child: Card(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                height: 180,
                width: 150,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            "${widget.img == null ? "" : widget.img}"),
                        fit: BoxFit.fill)),
              ),
              Container(
                height: 200,
                width: 200,
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        widget.name == null ? "Demo1" : widget.name,
                        style: TextStyle(
                            color: Colors.blue,
                            fontStyle: FontStyle.italic,
                            fontSize: 25),
                      ),
                      // Text(
                      //   "Category: ",
                      //   style: TextStyle(
                      //       color: Colors.green,
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 20),
                      // ),
                      // Text(
                      //   "Size: ",
                      //   style: TextStyle(
                      //       color: Colors.redAccent,
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 13),
                      // ),
                      Text(
                        "Price: ${widget.price} ",
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      Text(
                        "Suitable: ${widget.repo} ",
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      Container(
                        height: 30,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              child: Icon(
                                Icons.remove,
                                color: Colors.black,
                              ),
                              onTap: () {
                                setState(() {
                                  if (widget.quantity > 0) {
                                    widget.quantity -= 1;
                                  } else {
                                    widget.quantity = 0;
                                  }
                                });
                                updateQuantity(widget.name);
                              },
                            ),
                            Text(
                              "${widget.quantity}",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            GestureDetector(
                              child: Icon(
                                Icons.add,
                                color: Colors.black,
                              ),
                              onTap: () {
                                if (widget.quantity < widget.repo) {
                                  setState(() {
                                    widget.quantity += 1;
                                  });
                                  updateQuantity(widget.name);
                                  generalProvider.addNotiList(
                                      "${getTime()}: You have already updated ${widget.name} quantity");
                                } else {}
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                  child: Icon(Icons.close),
                  onTap: () {
                    List<CartModel> list = generalProvider.cartModelList;
                    late int index;
                    for (int i = 0; i < list.length; i++) {
                      if (widget.name == list[i].name) {
                        index = i;
                      }
                    }
                    list.remove(list[index]);
                    generalProvider.setCartModelList(list);
                    if (list.length == 0) {
                      generalProvider.setTotal(0);
                    } else {
                      generalProvider.setTotal(CountTotal(list));
                    }
                    generalProvider.addNotiList(
                        "${getTime()}: You have already deleted ${widget.quantity} ${widget.name}");
                  })
            ],
          ),
        ]),
      ),
    );
  }

  void updateQuantity(String name) {
    List<CartModel> list = generalProvider.cartModelList;
    late int index;
    for (int i = 0; i < list.length; i++) {
      if (widget.name == list[i].name) {
        index = i;
      }
    }

    if (widget.quantity == 0) {
      list.remove(list[index]);
    } else {
      list[index].quantity = widget.quantity;
    }

    generalProvider.setCartModelList(list);
    if (list.length == 0) {
      generalProvider.setTotal(0);
    } else {
      generalProvider.setTotal(CountTotal(list));
    }
  }

  double CountTotal(List<CartModel> list) {
    double value = 0;
    for (int i = 0; i < list.length; i++) {
      value += (list[i].quantity * list[i].price);
    }
    return value;
  }
}
