import 'package:flutter/material.dart';
import 'package:lost_and_found/screens/login&signup/view/login_page.dart';
import 'package:lost_and_found/screens/startPage.dart';
import 'package:lost_and_found/screens/home/views/HomePage.dart';
import 'package:lost_and_found/screens/login&signup/view/signup.dart';
import 'package:lost_and_found/screens/home/views/profilePage.dart';
import '../screens/login&signup/view/forgetPassword.dart';
import '../screens/post/lostItem.dart';

// Define routes
final Map<String, WidgetBuilder> routes = {
  '/': (context) => const startPage(),
  '/login': (context) => const Login(),
  '/home': (context) => const Home(),
  '/signup': (context) => const Signup(),
  '/profile': (context) => const ProfilePage(),
  '/lost': (context) => const LostItem(),
  '/forgetPassword': (context) => const ForgetPasswordPage(),
};

