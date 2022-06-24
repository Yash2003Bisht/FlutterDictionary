// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final wordChecker = GlobalKey<FormState>();
  final word = TextEditingController();
  bool hover = false;
  bool parsingError = false;
  bool dataParseorNot = false;
  String meaning = '';

  axisaligment(BuildContext context) {}

  authenticate(BuildContext context) {
    if (wordChecker.currentState!.validate()) {
      setState(() {
        dataParseorNot = true;
      });
      wordDefination(word);
    }
  }

  wordDefination(word) async {
    try {
      String url = 'https://api.dictionaryapi.dev/api/v2/entries/en/' +
          word.text.toLowerCase();
      final res = await http.get(Uri.parse(url));
      setState(() {
        dataParseorNot = false;
        meaning = jsonDecode(res.body)[0]['meanings'][0]['definitions'][0]
            ["definition"];
      });
    } catch (e) {
      setState(() {
        dataParseorNot = false;
        meaning =
            "Sorry, we couldn't find definitions for the word you were looking for.";
      });
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 90,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Row(
                  verticalDirection: VerticalDirection.up,
                  children: [
                    Expanded(
                      child: Form(
                        key: wordChecker,
                        child: TextFormField(
                          controller: word,
                          decoration: InputDecoration(
                              labelText: "Type it here..",
                              labelStyle: TextStyle(fontSize: 28)),
                          onChanged: (value) {
                            if (value.isEmpty) {
                              setState(() {
                                meaning = '';
                              });
                            }
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Kindly enter a word!';
                            }
                            if (value.contains(RegExp(r'[0-9]'))) {
                              return 'That \'s not a correct word!';
                            }
                            if (value.split(' ').length > 1) {
                              return "Word should not contains spaces!";
                            }
                          },
                        ),
                      ),
                    ),
                    InkWell(
                        hoverColor: Colors.white,
                        onHover: (value) {
                          setState(() {
                            hover = value;
                          });
                        },
                        onTap: () => authenticate(context),
                        child: Icon(
                          Icons.search,
                          color: hover ? Colors.blue : Colors.black,
                          size: 35,
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: dataParseorNot
                      ? CircularProgressIndicator()
                      : Text(meaning),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
