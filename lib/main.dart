import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/providers/general_provider.dart';
import 'package:testecommerce/screen/welcome_screen.dart';
import 'addition/app_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

ThemeData light = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.indigo,
    primaryColor: const Color(0xff746bc9),
    iconTheme: const IconThemeData(color: Colors.black),
    scaffoldBackgroundColor: const Color(0xfff1f1f1));

ThemeData dark = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.indigo,
  primaryColor: const Color(0xff746bc9),
  iconTheme: const IconThemeData(color: Colors.black),
);

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key});
  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState? state = context.findAncestorStateOfType();
    state!.changeLanguage(locale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale _locale = const Locale("en", "US");
  changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => GeneralProvider(),
        child: Consumer<GeneralProvider>(
            builder: (context, GeneralProvider notifier, child) {
          return MaterialApp(
            title: "H&H FOOD",
            theme: notifier.isDark ? dark : light,
            darkTheme: notifier.isDark ? dark : light,
            themeMode: notifier.isDark ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            locale: _locale,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [const Locale("vi", "VN"), const Locale("en", "US")],
            localeResolutionCallback: ((locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale!.languageCode &&
                    supportedLocale.countryCode == locale.countryCode) {
                  return supportedLocale;
                }
                return const Locale("en", "US");
              }
            }),
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                // if (snapshot.hasData) {
                //   print(
                //       "HomePage() is called first -----------${snapshot.data}");
                //   return HomePage();
                // } else {
                //   print("Login() is called first");
                //   return WelcomeScreen();
                // }
                return WelcomeScreen();
              },
            ),
          );
        }));
  }
}


// MultiProvider(
//       providers: [
//         ChangeNotifierProvider<CategoryProvider>(
//           create: (context) => CategoryProvider(),
//         ),
//         ChangeNotifierProvider<ProductProvider>(
//           create: (context) => ProductProvider(),
//         ),
//         ChangeNotifierProvider<ThemeDarkProvider>(
//           create: (context) => ThemeDarkProvider(),
//         ),
//       ],
//       child: MaterialApp(
//         // theme: Provider.of<ThemeDarkProvider>(context).isDark ? dark:light,
//         theme: ThemeData(
//           brightness: Brightness.dark,
//           primarySwatch: Colors.indigo,
//           primaryColor: Color(0xff746bc9),
//           iconTheme: IconThemeData(color: Colors.black),
//         ),
//         debugShowCheckedModeBanner: false,
//         home: StreamBuilder(
//           stream: FirebaseAuth.instance.authStateChanges(),
//           builder: (context, snapshot) {
//             // print("snapshot: ${snapshot}");
//             // print("snapshot.hasData: ${snapshot.hasData}");
//             // print("snapshot.hasError: ${snapshot.hasError}");
//             // if (snapshot.hasData) {
//             //   print("HomePage() is called first");
//             //   return HomePage();
//             // } else {
//             //   print("Login() is called first");
//             //   return Login();
//             // }
//             return Login();
//           },
//         ),
//       ),
//     );


// git remote add origin https://github.com/SonHoang1002/E-Commerce-1.git
// git branch -M main
// git push -u origin main
// git add .
// git commit -m 'askjfhskd'
// git push -u origin main