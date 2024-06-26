import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/addition/timer.dart';
import 'package:testecommerce/providers/general_provider.dart';
import 'package:testecommerce/providers/product_provider.dart';
import 'package:testecommerce/screen/cart_screen.dart';
import 'package:testecommerce/screen/checkout.dart';
import 'package:testecommerce/screen/home_page.dart';
import 'package:testecommerce/screen/profile.dart';
import '../../models/product.dart';

class DetailScreenForAdmin extends StatefulWidget {
  late String name;
  late String img;
  late double price;
  late int repo;
  DetailScreenForAdmin(
      {required this.name,
      required this.price,
      required this.img,
      required this.repo});

  @override
  State<DetailScreenForAdmin> createState() => _DetailScreenForAdminState();
}

class _DetailScreenForAdminState extends State<DetailScreenForAdmin> {
  bool isFixing = false;
  late String tName;
  late String tPrice;
  late String tRepo;
  late GeneralProvider generalProvider;
  late TextEditingController nameController =
      TextEditingController(text: widget.name);
  late TextEditingController priceController =
      TextEditingController(text: widget.price.toString());
  // late TextEditingController repoController =
  //     TextEditingController(text: widget.repo.toString());
  late TextEditingController repoController =
      TextEditingController(text: widget.repo.toString());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tName = widget.name;
    tPrice = widget.price.toString();
    tRepo = widget.repo.toString();
    // tRepo = "9";
  }

  @override
  Widget build(BuildContext context) {
    generalProvider = Provider.of<GeneralProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child:
              const Text("Detail", style: const TextStyle(color: Colors.black)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: isFixing
            ? IconButton(
                icon: const Icon(
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
                icon: const Icon(
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
                  icon: const Icon(Icons.check))
              : IconButton(
                  color: Colors.black,
                  onPressed: () {
                    setState(() {
                      isFixing = true;
                    });
                  },
                  icon: const Icon(Icons.drive_file_rename_outline))
        ],
      ),
      body: Container(
        height: 700,
        child: ListView(
          children: [
            StreamBuilder<Object>(
                stream: null,
                builder: (context, snapshot) {
                  return Column(children: [
                    buildImage(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Column(
                        children: [
                          buildNameToDescription(),
                          buildContentDescription(),
                          const SizedBox(
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
      height: isFixing ? null : 150,
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            isFixing
                ? Container(
                    height: 70,
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
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
                : Center(
                    child: Text(
                      tName,
                      style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 28,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
            isFixing
                ? Container(
                    height: 70,
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
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
                : Center(
                    // child: Badge(
                    // position: BadgePosition(bottom: 8,start: 45),
                    // badgeContent: Text("New"),
                    child: Text(
                      "${tPrice} ${generalProvider.getMoneyIconName}",
                      style: const TextStyle(
                          color: Colors.green,
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
            // ),
            isFixing
                ? Container(
                    height: 70,
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: TextFormField(
                      controller: repoController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Repository",
                        labelText: "Repository",
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
                : Center(
                    child: Text(
                      "${tRepo} products",
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    ),
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
            style: const TextStyle(
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
            "price": priceController.text.trim(),
            "repo": repoController.text
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
            "price": priceController.text.trim(),
            "repo": repoController.text.trim()
          });
          print("$nameList update succesfully");
        }
      });
    }
    setState(() {
      tName = nameController.text.trim();
      tPrice = priceController.text.trim();
      tRepo = repoController.text.trim();
      isFixing = false;
    });
  }
}
