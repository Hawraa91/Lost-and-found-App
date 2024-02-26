import 'package:flutter/material.dart';
import 'package:lost_and_found/screens/login&signup/view/login_page.dart';
import 'package:lost_and_found/screens/startPage.dart';
import 'package:lost_and_found/screens/home/views/HomePage.dart'; // Import the home page
import 'package:lost_and_found/Signup.dart';

import 'package:lost_and_found/screens/home/views/profilePage.dart';
// Define routes
final Map<String, WidgetBuilder> routes = {
  '/': (context) => const startPage(),
  '/login': (context) => const Login(),
  '/home': (context) => const Home(),
  '/signup': (context) => const Signup(),
  '/profile': (context) => const ProfilePage(),
};