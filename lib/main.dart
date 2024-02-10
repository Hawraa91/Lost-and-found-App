import 'package:flutter/material.dart';
import 'package:lost_and_found/routes/login_page.dart';
import 'ImageSection.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
      routes: {
        '/login': (context) => const Login(),
      },
    ));

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    //const String appTitle = 'FindMyThing';
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Text section
              const TitleSection(
                desc: 'FindMyThing',
              ),
              const TextSection(
                desc:
                    'Find what\'s lost, reunite what\'s found. Together, let\'s make lost things found',
              ),
              const ImageSection(
                image: 'images/pic.png',
                width: 250, // Adjust the width as needed
                height: 250,
              ),
              // Signup button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Container(
                  width: 200, // match parent width
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(
                        96, 172, 182, 1.0), // change color as needed
                    borderRadius:
                        BorderRadius.circular(8.0), // apply border radius
                  ),
                  child: TextButton(
                    onPressed: () {
                      // Handle signup button press
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              //the login click
              TextButton(
                onPressed: () {
                  //navigate to login page
                  Navigator.pushNamed(context, "/login");
                },
                child: const Text(
                  'got an account? Log in',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Title field
class TitleSection extends StatelessWidget {
  const TitleSection({Key? key, required this.desc}) : super(key: key);
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Text(
        desc,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 28, // Adjust the font size as needed
          fontWeight: FontWeight.bold, // Make the text bold
        ),
        softWrap: true,
      ),
    );
  }
}

// Text field
class TextSection extends StatelessWidget {
  const TextSection({Key? key, required this.desc}) : super(key: key);
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Text(
        desc,
        textAlign: TextAlign.center,
        softWrap: true,
      ),
    );
  }
}
