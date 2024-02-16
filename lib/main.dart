// main.dart
import 'package:flutter/material.dart';
import 'routes.dart'; // Import routes from route.dart

void main() {
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
