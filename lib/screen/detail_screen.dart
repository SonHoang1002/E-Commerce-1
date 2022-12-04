import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/addition/pageRoute.dart';
import 'package:testecommerce/addition/timer.dart';
import 'package:testecommerce/addition/unit_money.dart';
import 'package:testecommerce/gradient/gradient.dart';
import 'package:testecommerce/providers/general_provider.dart';
import 'package:testecommerce/providers/product_provider.dart';
import 'package:testecommerce/screen/cart_screen.dart';
import 'package:testecommerce/screen/checkout.dart';
import 'package:testecommerce/widget/notification_button.dart';

class DetailScreen extends StatefulWidget {
  late String name;
  late String img;
  late double price;
  late int repo;
  DetailScreen(
      {required this.name,
      required this.price,
      required this.img,
      required this.repo});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  double total = 0;
  late int quantity = 1;
  bool overPlus = false;
  bool isUpdate = false;
  // late GeneralProvider generalProvider;
  late GeneralProvider generalProvider;

  @override
  Widget build(BuildContext context) {
    generalProvider = Provider.of<GeneralProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Detail", style: TextStyle(color: Colors.black)),
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
          IconButton(
              icon: Badge(
                  badgeContent:
                      Text("${generalProvider.getCartModelListLength}"),
                  badgeColor: Colors.red,
                  shape: BadgeShape.circle,
                  showBadge: true,
                  child: const Icon(
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
        decoration: DecorationBackGround().buildDecoration(),
        child: ListView(
          children: [
            Column(children: [
              buildImage(),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  children: [
                    buildNameToDescription(),
                    buildContentDescription(),
                    // buildSizes(),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // buildColors()
                  ],
                ),
              ),
              buildRepo(),
              const SizedBox(
                height: 10,
              ),
              buildQuantity(),
              const SizedBox(
                height: 10,
              ),
              buildButton(),
              const SizedBox(
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
            padding: const EdgeInsets.all(15),
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
                style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 28,
                    fontStyle: FontStyle.italic),
              ),
              Text(
                "${UnitMoney().convertMoney(widget.price, generalProvider.getMoneyIconName)} ${generalProvider.getMoneyIconName}",
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 23,
                    fontWeight: FontWeight.bold),
              ),
              // Text(
              //   "Description",
              //   style: TextStyle(
              //     color: Colors.black,
              //     fontSize: 20,
              //   ),
              // ),
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
        children: const [
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

  Widget buildRepo() {
    return Container(
      child: Center(
        child: Text(
          "Available: ${widget.repo}",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget buildQuantity() {
    return Column(
      children: [
        const Text(
          "Quantity",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        const SizedBox(
          height: 5,
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
                child: const Icon(Icons.remove),
                onTap: () {
                  setState(() {
                    if (quantity >= 2) {
                      quantity -= 1;
                    } else {
                      quantity = 1;
                    }
                  });
                },
              ),
              Text(
                "${quantity}",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              GestureDetector(
                child: const Icon(Icons.add),
                onTap: () {
                  if (quantity < widget.repo) {
                    setState(() {
                      quantity += 1;
                    });
                  } else {
                    setState(() {
                      overPlus = true;
                    });
                  }
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
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton(
        onPressed: () {
          total = 0;
          generalProvider.setAddCartModel(
              widget.name, widget.price, quantity, widget.img, widget.repo);
          for (int i = 0; i < generalProvider.getCartModelListLength; i++) {
            total += (generalProvider.getCartModelList[i].quantity *
                generalProvider.getCartModelList[i].price);
          }
          generalProvider.setTotal(total);
          generalProvider.setNotiList(widget.name);
          generalProvider.addNotiList(
              "${getTime()}: You have already added ${quantity} ${widget.name}");
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (ctx) => CartScreen()));
          Navigator.of(context).push(PageRouteToScreen().pushToCartScreen());

          // total = 0;
          // bool? isExist;
          // int? index;
          // for (int i = 0; i < generalProvider.getCartModelListLength; i++) {
          //   total += (generalProvider.getCartModelList[i].quantity *
          //       generalProvider.getCartModelList[i].price);
          //   if (widget.name == generalProvider.getCartModelList[i]) {
          //     isExist = true;
          //     index = i;
          //   }
          // }
          // if (isExist == true) {
          //   generalProvider.getCartModelList[index!].quantity += quantity;
          // } else {
          //   generalProvider.setCartModel(
          //       widget.name, widget.price, quantity, widget.img);
          // }
          // generalProvider.setTotal(total);
          // generalProvider.setNotiList(widget.name);
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (ctx) => CartScreen()));
        },
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: const Center(
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
          style: const TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildColorProduct(String size, Color color) {
    return Container(
      height: 60,
      width: 60,
      color: const Color.fromARGB(255, 234, 233, 230),
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
    for (int i = 0; i < generalProvider.getCartModelListLength; i++) {
      total += (generalProvider.getCartModelList[i].quantity *
          generalProvider.getCartModelList[i].price);
    }
  }

  Widget buildSizes() {
    return Column(
      children: [
        const Text(
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
        const Text(
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
}
