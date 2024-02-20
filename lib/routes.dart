import 'package:flutter/material.dart';
import 'package:lost_and_found/screens/login/login_page.dart';
import 'package:lost_and_found/startPage.dart';
import 'package:lost_and_found/screens/home/views/HomePage.dart'; // Import the home page
import 'package:lost_and_found/Signup.dart';
// Define routes
final Map<String, WidgetBuilder> routes = {
  '/': (context) => const startPage(),
  '/login': (context) => const Login(),
  '/home': (context) => const Home(),
  '/signup': (context) => const Signup(),
};
