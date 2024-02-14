import 'package:flutter/material.dart';
import 'package:lost_and_found/routes/login_page.dart';
import 'package:lost_and_found/startPage.dart';
//import 'ImageSection.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: MyApp(),
      initialRoute: '/',
      routes: {
        '/': (context) => const startPage(),
        '/login': (context) => const Login(),
      },
    ));

