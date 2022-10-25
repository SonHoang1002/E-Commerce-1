import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkjs_flutter/talkjs_flutter.dart';
import 'package:testecommerce/providers/general_provider.dart';

class ContactMessenger extends StatefulWidget {
  String id;
  String name;
  String email;
  ContactMessenger({required this.id, required this.name, required this.email});
  @override
  State<ContactMessenger> createState() => _ContactMessengerState();
}

late GeneralProvider generalProvider;

class _ContactMessengerState extends State<ContactMessenger> {
  bool chatBoxVisible = false;
  @override
  void initState() {
    super.initState();
    generalProvider = Provider.of<GeneralProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    print("Id: ${widget.id}, Name:${widget.name}, Email: ${widget.email}");
    final session = Session(appId: 'tFEud7Mm');
    final admin = session.getUser(
      id: '012345',
      name: 'H&H Food Admin',
      email: ["admin@gmail.com"],
      welcomeMessage: "Hello, Can We Help You"
    );
   

    final user = session.getUser(id: widget.id, name: widget.name,email: [widget.email]);

    // final user =
    //     session.getUser(id: '995648', name: 'd12345', email: ["d@gmail.com"]);

    generalProvider.isAdmin ? session.me = admin : session.me = user;

    final conversation = session.getConversation(
      id: Talk.oneOnOneId(admin.id, user.id),
      participants: {Participant(admin), Participant(user)},
    );

    return MaterialApp(
      title: 'Messenger',
      home: Scaffold(
        appBar: AppBar(
            title: const Text('Messenger Contact'),
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back))),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) => Column(
            children: <Widget>[
              Visibility(
                visible: !chatBoxVisible,
                child: Container(
                  padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                  child: Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
              Visibility(
                maintainState: true,
                visible: chatBoxVisible,
                child: ConstrainedBox(
                  constraints: constraints,
                  child: ChatBox(
                    session: session,
                    conversation: conversation,
                    onLoadingStateChanged: (state) {
                      setState(() {
                        if (state == LoadingState.loaded) {
                          chatBoxVisible = true;
                        } else {
                          chatBoxVisible = false;
                        }
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
