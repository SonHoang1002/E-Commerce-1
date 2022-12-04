


import 'package:flutter/widgets.dart';
import 'package:testecommerce/models/product.dart';
import 'package:testecommerce/screen/about.dart';
import 'package:testecommerce/screen/admin/analysist_screen.dart';
import 'package:testecommerce/screen/admin/home_admin.dart';
import 'package:testecommerce/screen/cart_screen.dart';
import 'package:testecommerce/screen/checkout.dart';
import 'package:testecommerce/screen/contact_messenger.dart';
import 'package:testecommerce/screen/detail_screen.dart';
import 'package:testecommerce/screen/home_page.dart';
import 'package:testecommerce/screen/login.dart';
import 'package:testecommerce/screen/notification.dart';
import 'package:testecommerce/screen/profile.dart';
import 'package:testecommerce/screen/reset_password.dart';
import 'package:testecommerce/screen/sign_up.dart';
import 'package:testecommerce/screen/welcome_screen.dart';
import 'package:testecommerce/testScreen/test.dart';
import 'package:testecommerce/widget/list_product.dart';

class PageRouteToScreen{

Route pushToAboutScreen() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => About(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route pushToCartScreen() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => CartScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route pushToCheckOutScreen() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => CheckOut(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route pushToLoginScreen() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Login(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route pushToNotificationScreen() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => NotificationMessage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route pushToProfileScreen() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => ProfileScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route pushToSignupScreen() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Signup(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route pushToWelcomeScreen() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => WelcomeScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route pushToResetPasswordScreen() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => ResetPassword(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

//admin

Route pushToHomeAdminScreen() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => HomeAdmin(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route pushToAnalysistAdminScreen(double cost) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Analysist(cost: cost,),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

//test

Route pushToTestScreen() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => TestScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

}



