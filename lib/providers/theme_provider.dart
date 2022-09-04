import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testecommerce/models/product.dart';

class ThemeDarkProvider with ChangeNotifier {
  final String key = "theme";
  late bool _isDark;
  late SharedPreferences _preferences;
  ThemeDarkProvider() {
    _isDark = false;
  }
  get isDark => _isDark;
  setTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
