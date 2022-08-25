import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:testecommerce/screen/detailscreen.dart';

class SingleProduct extends StatelessWidget {
  SingleProduct({required this.name, required this.price, required this.image});
  late final String name;
  late final String image;
  late final double price;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(CupertinoPageRoute(builder: (context) =>
            DetailScreen(name: name, price: price, img: image)
            ));
      },
      child: Card(
        child: Container(
          height: 230,
          width: 180,
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
              height: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "$price \$",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.red),
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
}
