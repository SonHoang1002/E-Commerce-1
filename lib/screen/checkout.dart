import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/providers/product_provider.dart';
import 'package:testecommerce/widget/cartsingleproduct.dart';

class CheckOut extends StatefulWidget {
  @override
  State<CheckOut> createState() => _CheckOutState();
}

late ProductProvider productProvider;

class _CheckOutState extends State<CheckOut> {
  @override
  Widget build(BuildContext context) {
  productProvider = Provider.of<ProductProvider>(context);

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
              height: 595,
              child: ListView.builder(
                itemCount: productProvider.getCartmodelLength,
                itemBuilder: (context, index) => CartSingleProduct(
                    name: productProvider.getCartmodel[index].name,
                    price: productProvider.getCartmodel[index].price, 
                    img: productProvider.getCartmodel[index].img, 
                    quantity: productProvider.getCartmodel[index].quantity
                ),
              ),
            ),
            buildBottomSheet()
          ],
        ),
      ),
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

  // Container(
  //                         height: 100,
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                           children: [
  //                             buildDeatail("Price", "300 \$"),
  //                             buildDeatail("Discount", " 15%"),
  //                             // buildDeatail("Shipping", "32 \$"),
  //                             // buildDeatail("Total", "3465 \$"),
  //                           ],
  //                         ),
  //                       )

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
    return Row(
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
    );
  }
}



 // Container(
                        //   height: 150,
                        //   width: double.infinity,
                        //   color: Colors.grey,
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Text(
                        //         "Checkout",
                        //         style: TextStyle(fontSize: 30),
                        //       )
                        //     ],
                        //   ),
                        // ),