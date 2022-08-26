// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:project_x/screens/homepage.dart';

import 'package:google_translator/google_translator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  final String apiKey = "AIzaSyDVVL3xd6st3YnY3dN7DE-vD1JQ_D9SCS4";

  @override
  Widget build(BuildContext context) {
    return GoogleTranslatorInit(apiKey,
      translateFrom: Locale('fr'),
      translateTo: Locale('es'),
      // automaticDetection: , In case you don't know the user language will want to traslate,
      // cacheDuration: Duration(days: 13), The duration of the cache translation.
      builder: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: const HomePage(),
      ),
    );
  }
}