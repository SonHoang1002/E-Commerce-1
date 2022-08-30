import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String userName;
  final String userId;
  final String userEmail;
  final String userGender;
  final String userPhone;

  UserModel({
    required this.userName,
    required this.userId,
    required this.userEmail,
    required this.userGender,
    required this.userPhone,
  });


}

