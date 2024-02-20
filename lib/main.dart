import 'package:flutter/material.dart';
import 'routes.dart'; // Import routes from route.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDtmIZXK524Gtjt8FDdTafoKD9lfmYlGso",
      appId: "1:336882153933:android:16afdc1d5782301706ac84",
      messagingSenderId: "336882153933",
      projectId: "findmything-9663a",
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Check the login status and build the app accordingly
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loading indicator while waiting for authentication state
          return CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          // User is logged in
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/home', // Assuming '/home' is your home route
            routes: routes, // Use routes defined in route.dart
          );
        } else {
          // User is not logged in
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/', // Assuming '/login' is your login route
            routes: routes, // Use routes defined in route.dart
          );
        }
      },
    );
  }
}
