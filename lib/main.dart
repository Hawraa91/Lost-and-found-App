import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found/screens/login/login_page.dart';
import 'routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: routes,
      //home: const Login(),
    );
  }
}
