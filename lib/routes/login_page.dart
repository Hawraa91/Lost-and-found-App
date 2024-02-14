import 'package:flutter/material.dart';
import '../ImageSection.dart';
import 'package:firebase_core/firebase_core.dart';

void main() => runApp(const Login());

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late Future<FirebaseApp> _initializeFirebase;

  @override
  void initState() {
    super.initState();
    _initializeFirebase = _initializeFirebaseApp();
  }

  Future<FirebaseApp> _initializeFirebaseApp() async {
    return await Firebase.initializeApp();
  }

  //Adding the Input Fields method
  Widget input(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: FutureBuilder(
            future: _initializeFirebase,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const ImageSection(image: 'images/login.png', width: 200, height: 250),
                      const TitleSection(desc: 'Login'),
                      //const SizedBox(height: 20), // Add some spacing between the image and input fields
                      input('Email', Icons.email),
                      const SizedBox(height: 10), // Add some spacing between input fields
                      input('Password', Icons.security),
                      //TODO: the forgot password page
                      const SizedBox(height: 10), // Add some spacing between input fields and login button
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Container(
                          width: 200, // match parent width
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(
                                96, 172, 182, 1.0), // change color as needed
                            borderRadius: BorderRadius.circular(8.0), // apply border radius
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          //navigate back to signup page
                          //TODO: change the navigation to go to the signup page
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'new account? Sign Up',
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
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
      padding: const EdgeInsets.only(right: 230, bottom: 20),
      child: Text(
        desc,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontSize: 28, // Adjust the font size as needed
          fontWeight: FontWeight.bold, // Make the text bold
        ),
        softWrap: true,
      ),
    );
  }
}
