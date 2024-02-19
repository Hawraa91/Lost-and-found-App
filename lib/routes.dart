import 'package:flutter/material.dart';
import 'package:lost_and_found/login_page.dart';
import 'package:lost_and_found/startPage.dart';
import 'package:lost_and_found/screens/home/views/HomePage.dart'; // Import the home page

// Define routes
final Map<String, WidgetBuilder> routes = {
  '/': (context) => const startPage(),
  '/login': (context) => const Login(),
  '/home': (context) => const Home(),
};
