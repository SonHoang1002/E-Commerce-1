import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import 'package:testecommerce/providers/general_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ElevatedButton(
          onPressed: () async {
            String address = "207 Giai Phong";
            String googleUrl =
                'https://www.google.com/maps/search/?api=1&query=$address';
            await launchUrlString(googleUrl);
          },
          child: Text("GO to GG Map"),
        ),
      ),
    );
  }
}
