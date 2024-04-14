import 'package:flutter/material.dart';
import 'package:lost_and_found/screens/login&signup/view/login_page.dart';
import 'package:lost_and_found/screens/startPage.dart';
import 'package:lost_and_found/screens/home/views/HomePage.dart';
import 'package:lost_and_found/screens/login&signup/view/signup.dart';
import 'package:lost_and_found/screens/home/views/profilePage.dart';
import '../screens/home/modelView/CategoryItemsPage.dart';
import '../screens/login&signup/view/captcha.dart';
import '../screens/login&signup/view/forgetPassword.dart';

import '../screens/post/foundItem.dart';
import '../screens/post/lostItem.dart';

// Define routes
final Map<String, WidgetBuilder> routes = {
  '/': (context) => const startPage(),
  '/captcha': (context) => const CaptachaVerification(),
  '/login': (context) => const Login(),
  '/home': (context) => const Home(),
  '/signup': (context) => const Signup(),
  '/profile': (context) => ProfilePage(),
  '/lost': (context) => const LostItem(),
  '/found': (context) => const FoundItem(),
  '/forgetPassword': (context) => const ForgetPasswordPage(),
  '/categoryItem': (context) => CategoryItemPage(category: '',),
};

