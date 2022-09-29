import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/addition/timer.dart';
import 'package:testecommerce/providers/general_provider.dart';
import 'package:testecommerce/providers/product_provider.dart';
import 'package:testecommerce/screen/cartscreen.dart';
import 'package:testecommerce/screen/checkout.dart';
import 'package:testecommerce/screen/homepage.dart';
import 'package:testecommerce/screen/profile.dart';
import '../../models/product.dart';
import '../../widget/notification_button.dart';

class DetailScreenForAdmin extends StatefulWidget {
  late String name;
  late String img;
  late double price;
  DetailScreenForAdmin(
      {required this.name, required this.price, required this.img});

  @override
  State<DetailScreenForAdmin> createState() => _DetailScreenForAdminState();
}

class _DetailScreenForAdminState extends State<DetailScreenForAdmin> {
  bool isFixing = false;
  late String tName;
  late String tPrice;
  late GeneralProvider generalProvider;
  late TextEditingController nameController =
      TextEditingController(text: widget.name);
  late TextEditingController priceController =
      TextEditingController(text: widget.price.toString());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tName = widget.name;
    tPrice = widget.price.toString();
  }

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
        leading: isFixing
            ? IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    isFixing = false;
                  });
                },
              )
            : IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
        actions: [
          isFixing
              ? IconButton(
                  color: Colors.green,
                  onPressed: () {
                     checkNameInList();
                  },
                  icon: Icon(Icons.check))
              : IconButton(
                  color: Colors.black,
                  onPressed: () {
                    setState(() {
                      isFixing = true;
                    });
                  },
                  icon: Icon(Icons.drive_file_rename_outline))
        ],
      ),
      body: Container(
        child: ListView(
          children: [
            StreamBuilder<Object>(
                stream: null,
                builder: (context, snapshot) {
                  return Column(children: [
                    buildImage(),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Column(
                        children: [
                          buildNameToDescription(),
                          buildContentDescription(),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ]);
                }),
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
      height: 150,
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            isFixing
                ? Container(
                    height: 70,
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        // hintText: "Name",
                        labelText: "Name",
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(color: Colors.green),
                            gapPadding: 10.0),
                      ),
                    ),
                  )
                : Text(
                    tName,
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 28,
                        fontStyle: FontStyle.italic),
                  ),
            isFixing
                ? Container(
                    height: 70,
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Price",
                        labelText: "Price",
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(color: Colors.green),
                            gapPadding: 10.0),
                      ),
                    ),
                  )
                : Text(
                    "${tPrice} \$",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 23,
                        fontWeight: FontWeight.bold),
                  ),
          ],
        ),
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
        ],
      ),
    );
  }

  checkNameInList() async {
    List<Product> asia = generalProvider.getListAsia();
    List<Product> water = generalProvider.getWaterDish();
    List<Product> east = generalProvider.getEastDish();
    List<Product> drink = generalProvider.getListDrink();
    List<Product> snack = generalProvider.getSnack();
    List<Product> feature = generalProvider.getFeatureProduct();
    String nameList = "";
    for (int i = 0; i < asia.length; i++) {
      if (asia[i].name == widget.name) {
        nameList = "AsiaDish";
      }
    }
    for (int i = 0; i < water.length; i++) {
      if (water[i].name == widget.name) {
        nameList = "WaterDish";
      }
    }
    for (int i = 0; i < east.length; i++) {
      if (east[i].name == widget.name) {
        nameList = "EastDish";
      }
    }
    for (int i = 0; i < drink.length; i++) {
      if (drink[i].name == widget.name) {
        nameList = "Drink";
      }
    }
    for (int i = 0; i < snack.length; i++) {
      if (snack[i].name == widget.name) {
        nameList = "Snack";
      }
    }
    for (int i = 0; i < feature.length; i++) {
      if (feature[i].name == widget.name) {
        nameList = "featuredproduct";
      }
    }
    print(nameList);
    if (nameList == "featuredproduct") {
      QuerySnapshot<Object?> snapshot = await FirebaseFirestore.instance
          .collection("products")
          .doc("Yr4cg3K870i11VWoxx5q")
          .collection("featuredproduct")
          .get();
      snapshot.docs.forEach((element) {
        if (element["category"] == widget.name) {
          FirebaseFirestore.instance
              .collection("products")
              .doc("Yr4cg3K870i11VWoxx5q")
              .collection("featuredproduct")
              .doc(element.id)
              .update({
            "category": nameController.text.trim(),
            "image": widget.img,
            "price": priceController.text.trim()
          });
          print("featuredproduct update succesfully");
        }
      });
    } else {
      QuerySnapshot<Object?> snapshot = await FirebaseFirestore.instance
          .collection("category")
          .doc("2n0DMzp0z2in1eLYBXHG")
          .collection(nameList)
          .get();
      snapshot.docs.forEach((element) {
        if (element["category"] == widget.name) {
          FirebaseFirestore.instance
              .collection("category")
              .doc("2n0DMzp0z2in1eLYBXHG")
              .collection(nameList)
              .doc(element.id)
              .update({
            "category": nameController.text.trim(),
            "image": widget.img,
            "price": priceController.text.trim()
          });
          print("$nameList update succesfully");
        }
      });
    }
    setState(() {
      tName = nameController.text.trim();
      tPrice = priceController.text.trim();
      isFixing = false;
    });
  }
}
