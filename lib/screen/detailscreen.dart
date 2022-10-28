
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/addition/pageRoute.dart';
import 'package:testecommerce/addition/timer.dart';
import 'package:testecommerce/providers/general_provider.dart';
import 'package:testecommerce/providers/product_provider.dart';
import 'package:testecommerce/screen/cartscreen.dart';
import 'package:testecommerce/screen/checkout.dart';
import '../widget/notification_button.dart';


class DetailScreen extends StatefulWidget {
  late String name;
  late String img;
  late double price;
  DetailScreen({required this.name, required this.price, required this.img});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  double total = 0;
  late int quantity = 1;
  // late GeneralProvider generalProvider;
  late GeneralProvider generalProvider;
 

  @override
  Widget build(BuildContext context) {
    generalProvider = Provider.of<GeneralProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Detail", style: TextStyle(color: Colors.black)),
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
          NotificationButton(),
          IconButton(
              icon: Badge(
                  badgeContent: Text("${generalProvider.getCartModelLength}"),
                  badgeColor: Colors.red,
                  shape: BadgeShape.circle,
                  showBadge: true,
                  child: Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  )),
              onPressed: () {
                // Navigator.of(context)
                //     .push(MaterialPageRoute(builder: (ctx) => CartScreen()));
                      Navigator.of(context)
              .push(PageRouteToScreen().pushToCartScreen());
              }),
        ],
      ),
      body: Container(
        child: ListView(
          children: [
            Column(children: [
              buildImage(),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  children: [
                    buildNameToDescription(),
                    buildContentDescription(),
                    // buildSizes(),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // buildColors()
                  ],
                ),
              ),
              buildQuantity(),
              SizedBox(
                height: 10,
              ),
              buildButton(),
              SizedBox(
                height: 10,
              )
            ]),
          ],
        ),
      ),
    );
  }

  Widget buildImage() {
    return Center(
      child: Container(
        width: 350,
        child: Card(
          child: Container(
            padding: EdgeInsets.all(15),
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                          "${widget.img == null ? "" : widget.img}"))),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNameToDescription() {
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                widget.name == null ? "Product" : widget.name,
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 28,
                    fontStyle: FontStyle.italic),
              ),
              Text(
                "${widget.price == null ? 30.0 : widget.price} \$",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 23,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Description",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildContentDescription() {
    return Container(
      height: 200,
      child: Wrap(
        children: [
          Text(
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software",
            style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Widget buildSizes() {
    return Column(
      children: [
        Text(
          "Size",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        Container(
            width: 260,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildSizeForEach(
                  "S",
                ),
                buildSizeForEach(
                  "XXL",
                ),
                buildSizeForEach(
                  "XL",
                ),
                buildSizeForEach(
                  "L",
                ),
              ],
            ))
      ],
    );
  }

  Widget buildColors() {
    return Column(
      children: [
        Text(
          "Color",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        Container(
            width: 260,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildColorProduct("Red", Colors.red),
                buildColorProduct("Orange", Colors.orange),
                buildColorProduct("Blue", Colors.blue),
                buildColorProduct("Green", Color.fromARGB(255, 102, 183, 104)),
              ],
            ))
      ],
    );
  }

  Widget buildQuantity() {
    return Column(
      children: [
        Text(
          "Quantity",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        Container(
          height: 30,
          width: 100,
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                child: Icon(Icons.remove),
                onTap: () {
                  setState(() {
                    if (quantity > 0) {
                      quantity -= 1;
                    } else {
                      quantity = 0;
                    }
                  });
                },
              ),
              Text(
                "${quantity}",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              GestureDetector(
                child: Icon(Icons.add),
                onTap: () {
                  setState(() {
                    quantity += 1;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildButton() {
    return Container(
      height: 50,
      width: double.infinity,
      padding:EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton(
        onPressed: () {
          total = 0;
          generalProvider.setCartModel(
              widget.name, widget.price, quantity, widget.img);
          for (int i = 0; i < generalProvider.getCartModelLength; i++) {
            total += (generalProvider.getCartModel[i].quantity *
                generalProvider.getCartModel[i].price);
          }
          generalProvider.setTotal(total);
          generalProvider.setNotiList(widget.name);
          generalProvider.addNotiList("${getTime()}: You have already added ${quantity} ${widget.name}");
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (ctx) => CartScreen()));
                Navigator.of(context)
              .push(PageRouteToScreen().pushToCartScreen());

          // total = 0;
          // bool? isExist;
          // int? index;
          // for (int i = 0; i < generalProvider.getCartmodelLength; i++) {
          //   total += (generalProvider.getCartmodel[i].quantity *
          //       generalProvider.getCartmodel[i].price);
          //   if (widget.name == generalProvider.getCartmodel[i]) {
          //     isExist = true;
          //     index = i;
          //   }
          // }
          // if (isExist == true) {
          //   generalProvider.getCartmodel[index!].quantity += quantity;
          // } else {
          //   generalProvider.setCartModel(
          //       widget.name, widget.price, quantity, widget.img);
          // }
          // generalProvider.setTotal(total);
          // generalProvider.setNotiList(widget.name);
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (ctx) => CartScreen()));
        },
        style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),),
        child: Center(
            child: Text(
          "ADD TO CART",
          style: TextStyle(color: Colors.white, fontSize: 20),
        )),
      ),
    );
  }

  Widget buildSizeForEach(String size) {
    return Container(
      height: 60,
      width: 60,
      color: Color.fromARGB(255, 234, 233, 230),
      child: Center(
        child: Text(
          size,
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildColorProduct(String size, Color color) {
    return Container(
      height: 60,
      width: 60,
      color: Color.fromARGB(255, 234, 233, 230),
      child: Center(
        child: Text(
          size,
          style: TextStyle(
              color: color, fontSize: 17, fontWeight: FontWeight.bold),
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
}
