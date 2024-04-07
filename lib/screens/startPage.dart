import 'package:flutter/material.dart';
import '../components/ImageSection.dart';

void main() => runApp(const startPage());

class startPage extends StatefulWidget {
  const startPage({super.key});

  @override
  State<startPage> createState() => _startPageState();
}

class _startPageState extends State<startPage> {
  @override
  Widget build(BuildContext context) {
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
                image: 'assets/images/startup.png',
                width: 250, 
                height: 250,
              ),
              // Signup button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Container(
                  width: 300,
                  height: 65,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(46, 61, 95, 1.0),
                    borderRadius:
                        BorderRadius.circular(8.0), // apply border radius
                  ),
                  child: TextButton(
                    onPressed: () {
                      // Handle signup button press
                      Navigator.pushNamed(context, "/signup");
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 16,),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 1.0),
                child: Container(
                  width: 300,
                  height: 65,
                  decoration: BoxDecoration(
                    color: Colors.white, // change color as needed
                    borderRadius:
                    BorderRadius.circular(8.0),
                    border: Border.all(
                      color: const Color.fromRGBO(46, 61, 95, 1.0), // Border color
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      // Handle login button press
                      Navigator.pushNamed(context, "/captcha");
                    },
                    child: const Text(
                      'got an account? Log in',
                      style: TextStyle(color: Color.fromRGBO(46, 61, 95, 1.0), fontSize: 16,),
                    ),
                  ),
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
        style: const TextStyle(
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
