import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'routes.dart'; // Import routes from route.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(options: FirebaseOptions(apiKey: "AIzaSyCVM7_S30Mef_3p34LiCqVQ6vULNCuXilU", appId: "1:336882153933:web:3f9f6fdba5931b1b06ac84", messagingSenderId: "336882153933", projectId: "findmything-9663a"));
  }
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: routes, // Use routes defined in route.dart
    );
  }
}
