import 'package:flutter/material.dart';
import 'components/routes.dart'; // Import routes from route.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart'; // Import the firebase_options.dart file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseOptions);

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