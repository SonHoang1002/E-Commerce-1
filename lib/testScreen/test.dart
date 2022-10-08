import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import 'package:testecommerce/providers/general_provider.dart';

final people = <Person>[Person('Alice', '123 Main'), Person('Bob', '456 Main')];
// final letters = 'abcdefghijklmnopqrstuvwxyz'.split('');
// late final letters;

// late final nameList;
// late GeneralProvider generalProvider;

class _TestScreenState extends State<TestScreen> {
  String? selectedLetter;
  Person? selectedPerson;

  final formKey = GlobalKey<FormState>();

  bool autovalidate = false;
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   generalProvider = Provider.of<GeneralProvider>(context, listen: false);

  //   if (letters == [] || letters == null) {
  //     Future<int> a = generalProvider.setNameProductList();
  //     letters = generalProvider.getNameProductList;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Builder(
          builder: (context) => Padding(
            padding: EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              autovalidateMode: autovalidate
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: ListView(children: <Widget>[
                SizedBox(height: 16.0),
                Text('Selected person: "$selectedPerson"'),
                Text('Selected letter: "$selectedLetter"'),
                SizedBox(height: 16.0),
                SimpleAutocompleteFormField<Person>(
                  decoration: InputDecoration(
                      labelText: 'Person',
                      border: OutlineInputBorder(),
                      ),
                  suggestionsHeight: 80.0,
                  itemBuilder: (context, person) => Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(person!.name,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(person.address)
                        ]),
                  ),
                  onSearch: (search) async => people
                      .where((person) =>
                          person.name
                              .toLowerCase()
                              .contains(search.toLowerCase()) ||
                          person.address
                              .toLowerCase()
                              .contains(search.toLowerCase()))
                      .toList(),
                  itemFromString: (string) {
                    final matches = people.where((person) =>
                        person.name.toLowerCase() == string.toLowerCase());
                    return matches.isEmpty ? null : matches.first;
                  },
                  onChanged: (value) => setState(() => selectedPerson = value),
                  onSaved: (value) => setState(() => selectedPerson = value),
                  validator: (person) =>
                      person == null ? 'Invalid person.' : null,
                ),
                SizedBox(height: 16.0),
                SimpleAutocompleteFormField<String>(
                  decoration: InputDecoration(
                      labelText: 'Letter', border: OutlineInputBorder(),),
                  // suggestionsHeight: 70.0,
                  maxSuggestions: 6,
                  itemBuilder: (context, item) => Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(item!),
                  ),
                  onSearch: (String search) async => search.isEmpty
                      ? widget.list
                      : widget.list
                          .where((letter) => letter
                              .toLowerCase()
                              .contains(search.toLowerCase()))
                          .toList(),
                  itemFromString: (string) => widget.list.singleWhere(
                      (letter) => letter.toLowerCase() == string.toLowerCase(),
                      orElse: () => ''),
                  onChanged: (value) => setState(() => selectedLetter = value),
                  onSaved: (value) => setState(() => selectedLetter = value),
                  validator: (letter) =>
                      letter == null ? 'Invalid letter.' : null,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                    child: Text('Submit'),
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        formKey.currentState!.save();
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Fields valid!')));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Fix errors to continue.')));
                        setState(() => autovalidate = true);
                      }
                    })
              ]),
            ),
          ),
        ));
  }
}

class Person {
  Person(this.name, this.address);
  final String name, address;
  @override
  String toString() => name;
}

const title = 'simple_autocomplete_formfield example';

class TestScreen extends StatefulWidget {
  List<String> list;
  TestScreen({required this.list});
  @override
  _TestScreenState createState() => _TestScreenState();
}
