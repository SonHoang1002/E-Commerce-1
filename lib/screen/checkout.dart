import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/providers/general_provider.dart';
import 'package:testecommerce/providers/product_provider.dart';
import 'package:testecommerce/widget/cartsingleproduct.dart';

class CheckOut extends StatefulWidget {
  @override
  State<CheckOut> createState() => _CheckOutState();
}

// late ProductProvider productProvider;
late GeneralProvider generalProvider;

class _CheckOutState extends State<CheckOut> {
  @override
  Widget build(BuildContext context) {
    generalProvider = Provider.of<GeneralProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Check Out", style: TextStyle(color: Colors.black)),
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
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          children: [
            Container(
              height: 400,
              child: ListView.builder(
                itemCount: generalProvider.getCartModelLength,
                itemBuilder: (context, index) => CartSingleProduct(
                    name: generalProvider.getCartModel[index].name,
                    price: generalProvider.getCartModel[index].price,
                    img: generalProvider.getCartModel[index].img,
                    quantity: generalProvider.getCartModel[index].quantity),
              ),
            ),
            
          ],
        ),
      ),
      bottomSheet: Container(
        height: 300,
          child: Column(
        children: [
          Container(
                          height: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildDeatail("Price", "300 \$"),
                              buildDeatail("Discount", " 15%"),
                              buildDeatail("Shipping", "32 \$"),
                              buildDeatail("Total", "3465 \$"),
                            ],
                          ),
                        ),
          buildBottomSheet(),
        ],
      )),
    );
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
      height: 50,
      width: 700,
      margin: EdgeInsets.all(20),
      child: RaisedButton(
        onPressed: () {
          // Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (ctx) => CheckOut()));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [Text('CHECK OUT')],
        ),
      ),
    );
  }

  Widget buildDeatail(String startName, String endName) {
    return Container(
      width: 380,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              startName,
              style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
            Text(endName,
                style: TextStyle(
                  fontSize: 14,
                ))
          ],
        ),
      ),
    );
  }
}
