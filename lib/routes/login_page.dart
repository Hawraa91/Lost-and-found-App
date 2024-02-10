import 'package:flutter/material.dart';
import '../ImageSection.dart';

void main() => runApp(const Login());

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    //const String appTitle = 'FindMyThing';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ImageSection(image: 'images/login.png', width: 250, height: 250),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
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
                        //navigate back
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
