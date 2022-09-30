import 'package:custom_dialog/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:testecommerce/screen/admin/singleProductAdmin.dart';

class CustomExpansionTile extends StatefulWidget {
  @override
  State createState() => CustomExpansionTileState();
}

class CustomExpansionTileState extends State<CustomExpansionTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Container(
        child: Text(
          "HEADER HERE",
          style: TextStyle(
            color: isExpanded ? Colors.pink : Colors.teal,
          ),
        ),
        // Change header (which is a Container widget in this case) background colour here.
        color: isExpanded ? Colors.orange : Colors.green,
      ),
      leading: Icon(
        Icons.face,
        size: 36.0,
      ),
      children: <Widget>[
        Text("Child Widget One"),
        Text("Child Widget Two"),
      ],
      onExpansionChanged: (bool expanding) => setState(() => this.isExpanded = expanding),
    );
  }
}
class TestScreen extends StatelessWidget {
  const TestScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slidable Example',
      home: Scaffold(
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Slidable(
                  key: const ValueKey(1),
                  startActionPane: const ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: _showAlertDialog,
                        backgroundColor: Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                      SlidableAction(
                        onPressed: _showAlertDialog,
                        backgroundColor: Color(0xFF21B7CA),
                        foregroundColor: Colors.white,
                        icon: Icons.share,
                        label: 'Share',
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    dismissible: DismissiblePane(onDismissed: () {}),
                    children: const [
                      SlidableAction(
                        flex: 2,
                        onPressed: _showAlertDialog,
                        backgroundColor: Color(0xFF7BC043),
                        foregroundColor: Colors.white,
                        icon: Icons.archive,
                        label: 'Archive',
                      ),
                      SlidableAction(
                        onPressed: _showAlertDialog,
                        backgroundColor: Color(0xFF0392CF),
                        foregroundColor: Colors.white,
                        icon: Icons.save,
                        label: 'Save',
                      ),
                    ],
                  ),
                  child: Container(
                    width: double.infinity,
                    child: SingleProductForAdmin(
                      image:
                          "https://anhdephd.vn/wp-content/uploads/2022/05/anh-meo-cute.jpg",
                      name: "Test1",
                      price: 23.0,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void showCustomDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            height: 240,
            child: SizedBox.expand(child: FlutterLogo()),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(40)),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }
}

_showAlertDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => CustomDialog(
      content: Text(
        'Payment Successful',
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 20.0,
        ),
      ),
      title: Text('Health Insurance'),
      firstColor: Color(0xFF3CCF57),
      secondColor: Colors.white,
      headerIcon: Icon(
        Icons.check_circle_outline,
        size: 120.0,
        color: Colors.white,
      ),
    ),
  );
}
