import 'package:flutter/material.dart';
import 'package:lost_and_found/routes/login_page.dart';
import 'package:lost_and_found/startPage.dart';
import 'package:lost_and_found/HomePage.dart'; // Import the home page

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  initialRoute: '/',
  routes: {
    '/': (context) => const startPage(),
    '/login': (context) => const Login(),
    '/home': (context) => Home(),
  },
));


