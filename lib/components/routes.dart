import 'package:flutter/material.dart';
import 'package:lost_and_found/screens/login&signup/view/login_page.dart';
import 'package:lost_and_found/screens/startPage.dart';
import 'package:lost_and_found/screens/home/views/HomePage.dart';
import 'package:lost_and_found/screens/login&signup/view/signup.dart';
import 'package:lost_and_found/screens/Profile/profilePage.dart';
import '../screens/chat/contacts.dart';
import '../screens/home/modelView/CategoryItemsPage.dart';
import '../screens/home/modelView/EditReportPage.dart';
import '../screens/home/modelView/location.dart';
import '../screens/login&signup/view/captcha.dart';
import '../screens/login&signup/view/forgetPassword.dart';
import '../screens/post/View/SearchResults.dart';
import '../screens/post/modelView/foundItem.dart';
import '../screens/post/modelView/lostItem.dart';
import '../screens/post/model/SearchItem.dart';

// Define routes
final Map<String, WidgetBuilder> routes = {
  '/': (context) => const startPage(),
  '/captcha': (context) => const CaptachaVerification(),
  '/login': (context) => const Login(),
  '/home': (context) => const Home(),
  '/signup': (context) => const Signup(),
  '/profile': (context) => const ProfilePage(),
  '/lost': (context) => const LostItem(),
  '/contact': (context) => ContactsPage(),
  '/found': (context) => const FoundItem(),
  '/search': (context) => const SearchPage(),
  '/forgetPassword': (context) => const ForgetPasswordPage(),
  '/location': (context) => LocationTrackerPage(),
  '/categoryItem': (context) => CategoryItemPage(category: '',),
  '/searchResults': (context) => const SearchResultsPage(matchedTitles: [ ],),
};
