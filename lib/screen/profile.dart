import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/addition/timer.dart';
import 'package:testecommerce/models/usermodel.dart';
import 'package:testecommerce/providers/general_provider.dart';
import 'package:testecommerce/providers/product_provider.dart';
import 'package:testecommerce/screen/homepage.dart';
import 'package:testecommerce/widget/notificationButton.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

String p =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
RegExp regExp = RegExp(p);

late UserModel userModel;
late List<UserModel> list = [];
late GeneralProvider generalProvider;
//late ProductProvider productProvider;
String name = "";
String phone = "";
String gender = "";
String email = "";
String address = "";
var imageMap = "";

late TextEditingController tName;
late TextEditingController tPhone;
late TextEditingController tEmail;
late TextEditingController tAddress;
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

// late TextEditingController tName = TextEditingController(text: "name");
// late TextEditingController tPhone = TextEditingController(text: "phone");
// late TextEditingController tEmail = TextEditingController(text: "email");
// late TextEditingController tAddress = TextEditingController(text: "address");

class _ProfileScreenState extends State<ProfileScreen> {
  bool edit = false;
  bool isLoading = false;
  bool centerCircle = false;
  late bool isMale = (gender == "Male");

  File? _pickedImage;
  XFile? _image;
  late String imageUrl;

  @override
  Widget build(BuildContext context) {
    generalProvider = Provider.of<GeneralProvider>(context);

    // if (name == "") {
    //   Future<int> a = generalProvider.setUserModel();
    //   name = generalProvider.getUserModelName;
    //   tName = TextEditingController(text: name);
    // }
    // if (phone == "") {
    //   Future<int> b = generalProvider.setUserModel();
    //   phone = generalProvider.getUserModelPhone;
    //   tPhone = TextEditingController(text: phone);
    // }
    // if (email == "") {
    //   Future<int> c = generalProvider.setUserModel();
    //   email = generalProvider.getUserModelEmail;
    // }
    // if (address == "") {
    //   Future<int> d = generalProvider.setUserModel();
    //   address = generalProvider.getUserModelAddress;
    //   tAddress = TextEditingController(text: address);
    // }
    // if (gender == "") {
    //   Future<int> d = generalProvider.setUserModel();
    //   gender = generalProvider.getUserModelGender;
    // }
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          backgroundColor: generalProvider.isDark ? null : Colors.grey[100],
          actions: [
            edit
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        edit = false;
                      });
                      validation();
                    },
                    icon: Icon(
                      Icons.check,
                      color: Colors.green,
                    ))
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        edit = false;
                      });
                    },
                    child: NotificationButton(
                      // fromHomePage: false,
                    ),
                  )
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
                    Navigator.of(context).pop(MaterialPageRoute(
                        builder: (ctx) => HomePage(
                            nameList: generalProvider.getNameProductList)));
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.black))),
      body: centerCircle == false
          ? ListView(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance.collection("User").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    snapshot.data!.docs.forEach(((element) {
                      if (element["UserId"] ==
                          FirebaseAuth.instance.currentUser!.uid) {
                        name = element["UserName"];
                        email = element["UserEmail"];
                        phone = element["UserPhone"];
                        gender = element["UserGender"];
                        address = element["UserAddress"];
                        imageUrl = element["UserImage"];

                        tEmail = TextEditingController(text: email);
                        tAddress = TextEditingController(text: address);
                        tName = TextEditingController(text: name);
                        tPhone = TextEditingController(text: phone);
                      }
                    }));

                    return Container(
                      height: 900,
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                      maxRadius: 60,
                                      backgroundImage: setImageForAvatar()),
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
                                      padding: const EdgeInsets.only(
                                          left: 80, top: 80),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.green,
                                          child: Icon(Icons.camera_alt),
                                        ),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 80, top: 80),
                                  )
                          ]),
                          edit
                              ? Container(
                                  height: 330,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      buildTextFormFieldFromController(
                                          "Name", tName),
                                      buildTextFormFieldFromController(
                                          "Email", tEmail),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isMale = !isMale;
                                          });
                                        },
                                        child: Container(
                                          height: 55,
                                          width: double.infinity,
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10, top: 4),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                      buildTextFormFieldFromController(
                                          "Phone Number", tPhone),
                                      buildTextFormFieldFromController(
                                          "Address", tAddress)
                                    ],
                                  ),
                                )
                              : Container(
                                  height: 400,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      buildFieldInput("Name", name),
                                      buildFieldInput("Email", email),
                                      buildFieldInput("Gender", gender),
                                      buildFieldInput("Phone Number", phone),
                                      buildFieldInput("Address", address),
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
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.grey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(60.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        edit = !edit;
                                      });
                                    },
                                    child: Text("FIX"),
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    );
                  },
                )
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Future getImage(ImageSource src) async {
    _image = (await ImagePicker().pickImage(source: src));
    if (_image != null) {
      setState(() {
        _pickedImage = File(_image!.path);
      });
    }
  }

  bool checkDataFieldChange(String oldValue, String newValue) {
    return oldValue != newValue;
  }

  ImageProvider setImageForAvatar() {
    var i = generalProvider.getUserModelImage;
    if (_pickedImage == null) {
      if (i == null) {
        return const NetworkImage(
            "https://scontent.fhan2-4.fna.fbcdn.net/v/t1.6435-9/203063561_108326058170068_6656793944407315036_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=JL4XcaY8Kr8AX_C2foH&_nc_ht=scontent.fhan2-4.fna&oh=00_AT_xEYOqC4RzWAcgtHLMxTD9ata6kzl_qaRxlvQRZcQRog&oe=632E61CE");
      } else {
        return NetworkImage(generalProvider.getUserModelImage);
      }
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

  Future<String> uploadImage(File image) async {
    User? user = FirebaseAuth.instance.currentUser;
    Reference reference =
        FirebaseStorage.instance.ref().child("images/${user!.uid}");
    if (_image != null) {
      print("Image is $image");
      UploadTask uploadTask = reference.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      print("imageUrl is $imageUrl");
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Image null")));
    }

//  https://www.educative.io/answers/how-to-upload-to-firebase-storage-with-flutter

    // final result = await FilePicker.platform.pickFiles(
    //     allowMultiple: false,
    //     type: FileType.custom,
    //     allowedExtensions: ["png", "jpg"]);
    // if (result == null) {
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(SnackBar(content: Text("Image null")));
    // }
    // final path = result!.files.single.path!;
    // final pathName = result.files.single.name;
    // File file = File(path);
    // try{
    //   UploadTask uploadTask =  FirebaseStorage.instance.ref("img/${pathName}").putFile(file);
    //         TaskSnapshot snapshot = await uploadTask;
    //     imageUrl = await snapshot.ref.getDownloadURL();
    // }on FirebaseException  catch(e){
    //   print(e);
    // }
    return imageUrl;
  }

// uploadImage() async {
//     final _firebaseStorage = FirebaseStorage.instance;
//     final _imagePicker = ImagePicker();
//     PickedFile image;
//     //Check Permissions
//     await Permission.photos.request();
//     var permissionStatus = await Permission.photos.status;
//     if (permissionStatus.isGranted) {
//       //Select Image
//       image = await _imagePicker.getImage(source: ImageSource.gallery);
//       var file = File(image.path);
//       if (image != null) {
//         //Upload to Firebase
//         var snapshot = await _firebaseStorage
//             .ref()
//             .child('images/imageName')
//             .putFile(file)
//             .onComplete;
//         var downloadUrl = await snapshot.ref.getDownloadURL();
//         setState(() {
//           imageUrl = downloadUrl;
//         });
//       } else {
//         print('No Image Path Received');
//       }
//     } else {
//       print('Permission not granted. Try Again with permission access');
//     }
//   }
  void validation() async {
    if (tEmail.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Email Is Empty"),
        ),
      );
    } else if (!regExp.hasMatch(tEmail.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Try Valid Email"),
        ),
      );
    } else if (tPhone.text.length < 10 && tPhone.text.length > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Phone Number Is Too Short Or Too Long"),
        ),
      );
    } else if (tName.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Name Is Too Short"),
        ),
      );
    } else {
      updateUser();
    }
  }

  updateUser() async {
    setState(() {
      centerCircle = true;
    });
    User? user = FirebaseAuth.instance.currentUser;

    if (checkDataFieldChange(generalProvider.userName, tName.text) ||
        checkDataFieldChange(generalProvider.userAddress, tAddress.text) ||
        checkDataFieldChange(generalProvider.userPhone, tPhone.text) ||
        checkDataFieldChange(generalProvider.userImage, imageMap) ||
        generalProvider.userGender != (isMale == true ? "Male" : "Female")) {
      generalProvider.addNotiList("${getTime()}: You already change Profile");
    }
    _pickedImage != null
        ? imageMap = await uploadImage(_pickedImage!)
        : Container();
    FirebaseFirestore.instance.collection("User").doc(user!.uid).update({
      "UserName": tName.text,
      "UserEmail": email,
      "UserGender": isMale == true ? "Male" : "Female",
      "UserPhone": tPhone.text,
      "UserImage": (imageMap == null || imageMap == "")
          ? generalProvider.getUserModelImage
          : imageMap,
      "UserAddress": tAddress.text,
      "Id_messenger": generalProvider.getUserModelIdMessenger,
      "UserId": user.uid
    });
    generalProvider.setUserModel();

    setState(() {
      centerCircle = false;
    });
    setState(() {
      edit = false;
    });
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

Widget buildTextFormFieldFromController(
    String label, TextEditingController controller) {
  return Container(
    height: 50,
    child: TextFormField(
      readOnly: label == "Email",
      controller: controller,
      decoration: InputDecoration(
          // hintText: hintText,
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
          value.length < 20
              ? Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )
              : Container(
                  width: 180,
                  child: Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                )
        ],
      ),
    ),
  );
}
