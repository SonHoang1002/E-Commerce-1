import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/addition/unit_money.dart';
import 'package:testecommerce/providers/general_provider.dart';
import 'package:testecommerce/screen/alertResetPassword.dart';
import 'package:testecommerce/screen/detailscreen.dart';


class SingleProduct extends StatelessWidget {
  SingleProduct(
      {required this.name,
      required this.price,
      required this.image,
      required this.repo});
  late final String name;
  late final String image;
  late final double price;
  late final int repo;

  late GeneralProvider generalProvider;
  @override
  Widget build(BuildContext context) {
    generalProvider = Provider.of<GeneralProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) => DetailScreen(
                name: name, price: price, img: image, repo: repo)));
      },
      onLongPress: () {
        _showAlertDialog(context);
        print(name);
      },
      child: Card(
        child: Container(
          height: 230,
          width: 157,
          color: Colors.blue,
          child: Column(children: [
            Container(
              height: 170,
              decoration: BoxDecoration(
                  color: Colors.red,
                  image: DecorationImage(
                      fit: BoxFit.fill, image: NetworkImage("$image"))),
            ),
            Container(
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "${UnitMoney().convertMoney(price,generalProvider.getMoneyIconName)} ${generalProvider.getMoneyIconName}",
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
          title: Text('Cancel booking'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure want to cancel booking?'),
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
