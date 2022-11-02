import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import 'package:talkjs_flutter/talkjs_flutter.dart';
import 'package:testecommerce/providers/general_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../addition/pageRoute.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

late GeneralProvider generalProvider;

class _TestScreenState extends State<TestScreen> {
  bool chatBoxVisible = false;
  @override
  void initState() {
    super.initState();
    // generalProvider = Provider.of<GeneralProvider>(context, listen: false);
  }

  late Timer timer;
  int start = 10;
  int minute = 1;
  String zero = "";

  @override
  Widget build(BuildContext context) {
    final session = Session(appId: 'tFEud7Mm');
    final admin = session.getUser(
        id: '999999',
        name: 'H&H Food Admin',
        email: ["hello@gmail.com"],
        role: "admin"
        // welcomeMessage: "Hello, Can We Help You"
        );

    // final user = session.getUser(id: widget.id, name: widget.name,email: [widget.email]);

    final user = session.getUser(
        id: '995648', name: 'd12345', email: ["d@gmail.com"], role: "user");
    session.me = admin;

    final conversation = session.getConversation(
      id: Talk.oneOnOneId(admin.id, user.id),
      participants: {Participant(admin), Participant(user)},
    );
    //   return MaterialApp(
    //     title: 'Messenger',
    //     home: Scaffold(
    //       appBar: AppBar(
    //           title: const Text('Messenger Contact'),
    //           leading: IconButton(
    //               onPressed: () {
    //                 Navigator.of(context).pop();
    //               },
    //               icon: Icon(Icons.arrow_back))),
    //       body: LayoutBuilder(
    //         builder: (BuildContext context, BoxConstraints constraints) => Column(
    //           children: <Widget>[
    //             Visibility(
    //               visible: !chatBoxVisible,
    //               child: Container(
    //                 padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
    //                 child: Center(
    //                   child: SizedBox(
    //                     width: 50,
    //                     height: 50,
    //                     child: CircularProgressIndicator(),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             Visibility(
    //               maintainState: true,
    //               visible: chatBoxVisible,
    //               child: ConstrainedBox(
    //                 constraints: constraints,
    //                 child: ChatBox(
    //                   session: session,
    //                   conversation: conversation,
    //                   onLoadingStateChanged: (state) {
    //                     setState(() {
    //                       if (state == LoadingState.loaded) {
    //                         chatBoxVisible = true;
    //                       } else {
    //                         chatBoxVisible = false;
    //                       }
    //                     });
    //                   },
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   );
    return Scaffold(
      appBar: AppBar(title: Text("TestScreen")),
      body: Container(
          child: Center(
        child: Column(children: [
          Text(
            "${minute}:${zero}${start}",
            style: TextStyle(fontSize: 30),
          ),
          ElevatedButton(
            child: Text("Click me"),
            onPressed: () {
              buildTimer();
            },
          )
        ]),
      )),
    );
  }

  void buildTimer() {
    const perSecond = Duration(seconds: 1);
    timer = Timer.periodic(perSecond, (timer) {
      if (minute == 0 && start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        if (start == 0) {
          setState(() {
            minute--;
            start = 10;
          });
        } else {
          setState(() {
            // if (start<11) {
            //   setState(() {
            //     zero = "0";
            //   });
            // } else {
            //   setState(() {
            //     zero = "";
            //   });
            // }
            start--;
          });
        }
      }
    });
  }

  void buildSecondCountDown() {
    const perSecond = Duration(seconds: 1);
    timer = Timer.periodic(perSecond, (timer) {
      if (minute == 0) {
        if (start == 0) {
          timer.cancel();
        } else {
          setState(() {
            start--;
          });
        }
      } else {
        if (start == 0) {
          start = 10;
        } 
          setState(() {
            start--;
          });
      }
    });
  }
   void _buildResetDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (ctx) {
          FocusManager.instance.primaryFocus?.unfocus();
          return AlertDialog(
            title: Text(
              "Please enter reset number from my email",
              textAlign: TextAlign.center,
            ),
            content: Container(
              height: 100,
              child: Column(
                children: [
                  Text(
                    "${minute}:${zero}${start}",
                    style: TextStyle(fontSize: 25),
                  ),
                
                ],
              ),
            ),
            actions: [
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      
                     
                        FocusManager.instance.primaryFocus?.unfocus();
                        Navigator.of(context).pop();
                        // Navigator.of(context).push(
                        //     MaterialPageRoute(
                        //         builder: (_) =>
                        //             ResetPassword()));
                        Navigator.of(context).push(
                            PageRouteToScreen().pushToResetPasswordScreen());
                        return;
                    },
                    child: Text("CHECK")),
              )
            ],
          );
        });
  }
}
