import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/models/usermodel.dart';
import 'package:testecommerce/providers/product_provider.dart';
import 'package:testecommerce/screen/homepage.dart';
import 'package:testecommerce/screen/notification_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

late UserModel userModel;
late List<UserModel> list = [];
late ProductProvider productProvider;
String name = "";
String phone = "";
String gender = "";
String email = "";

class _ProfileScreenState extends State<ProfileScreen> {
  bool edit = false;

  late bool isMale = (gender == "Male");

  File? _pickedImage;
  PickedFile? _image;
  late String imageUrl;
  Future getImage(ImageSource src) async {
    _image = (await ImagePicker().getImage(source: src))!;
    if (_image != null) {
      _pickedImage = File(_image!.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of<ProductProvider>(context);

    if (name == "") {
      Future<int> i = productProvider.setUserModel();
      name = productProvider.getUserModelName;
    }
    if (phone == "") {
      Future<int> i = productProvider.setUserModel();
      phone = productProvider.getUserModelPhone;
    }
    if (email == "") {
      Future<int> i = productProvider.setUserModel();
      email = productProvider.getUserModelEmail;
    }
    if (gender == "") {
      Future<int> i = productProvider.setUserModel();
      gender = productProvider.getUserModelGender;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff8f8f8),
      appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            edit
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        edit = false;
                      });
                      uploadImage(_pickedImage!);
                    },
                    icon: Icon(
                      Icons.check,
                      color: Colors.green,
                    ))
                : IconButton(
                    onPressed: () {
                      setState(() {
                        edit = false;
                      });
                    },
                    icon: NotificationButton())
          ],
          leading: edit
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      edit = false;
                    });
                  },
                  icon: Icon(Icons.close, color: Colors.red))
              : IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(MaterialPageRoute(builder: (ctx) => HomePage()));
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.black))),
      body: Container(
        height: 500,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Stack(children: [
              Container(
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                        maxRadius: 60, backgroundImage: setImageForAvatar()),
                  ],
                ),
              ),
              edit
                  ? GestureDetector(
                      onTap: () {
                        // getImage(ImageSource.camera);
                        ImageDialogBox();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 80, top: 80),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          child: CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Icon(Icons.camera_alt),
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 80, top: 80),
                    )
            ]),
            edit
                ? Container(
                    height: 250,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildTextFormField("Enter Your Username", name),
                        buildTextFormField("Enter Your Email", email),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isMale = !isMale;
                            });
                          },
                          child: Container(
                            height: 55,
                            width: double.infinity,
                            padding:
                                EdgeInsets.only(left: 10, right: 10, top: 4),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(30)),
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    isMale ? "Male" : "Female",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Icon(Icons.arrow_drop_up),
                                      Icon(Icons.arrow_drop_down)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        buildTextFormField("Enter Your Phone Number", phone),

                        // buildTextFormField(name, "Enter Your Username"),
                        // buildTextFormField( email, "Enter Your Email"),
                        // buildTextFormField(gender, "Enter Your Gender"),
                        // buildTextFormField(phone, "Enter Your Phone Number"),
                      ],
                    ),
                  )
                : Container(
                    height: 250,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildFieldInput("Name", name),
                        buildFieldInput("Email", email),
                        buildFieldInput("Gender", gender),
                        buildFieldInput("Phone Number", phone),
                      ],
                    ),
                  ),
            !edit
                ? Container(
                    height: 45,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60)),
                      onPressed: () {
                        setState(() {
                          edit = !edit;
                        });
                      },
                      color: Colors.grey,
                      child: Text("FIX"),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  ImageProvider setImageForAvatar() {
    if (_pickedImage == null) {
      return NetworkImage(
          "https://scontent.fhan2-4.fna.fbcdn.net/v/t1.6435-9/203063561_108326058170068_6656793944407315036_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=JL4XcaY8Kr8AX_C2foH&_nc_ht=scontent.fhan2-4.fna&oh=00_AT_xEYOqC4RzWAcgtHLMxTD9ata6kzl_qaRxlvQRZcQRog&oe=632E61CE");
    } else {
      return FileImage(_pickedImage!);
    }
  }

  ImageDialogBox() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text('Pick From Camera'),
                  onTap: () {
                    getImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Pick From Photo Library'),
                  onTap: () {
                    getImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        );
      },
      barrierDismissible: false,
    );
  }

  uploadImage(File image) async {
    User? user = FirebaseAuth.instance.currentUser;
    Reference reference = FirebaseStorage.instance.ref().child("images/a.jpg");
    print("reference:${reference}");
    UploadTask uploadTask = reference.putFile(image);
    print("images: ${image}");
    print("uploadTask: ${uploadTask}");
    TaskSnapshot snapshot = await uploadTask;
    print("snapshot: ${snapshot}");
    imageUrl = await snapshot.ref.getDownloadURL();
    print("imageUrl: ${imageUrl}");
    
  }
}

Widget buildTextFormField(String hintText, String label) {
  return Container(
    height: 50,
    child: TextFormField(
      decoration: InputDecoration(
          hintText: hintText,
          labelText: label,
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
    ),
  );
}

Widget buildFieldInput(String name, String value) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Text(
            value,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          )
        ],
      ),
    ),
  );
}
