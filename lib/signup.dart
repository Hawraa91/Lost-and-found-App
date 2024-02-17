import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(const Signup());

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  late Future<FirebaseApp> _initializeFirebase;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeFirebase = _initializeFirebaseApp();
  }

  Future<FirebaseApp> _initializeFirebaseApp() async {
    return await Firebase.initializeApp();
  }

  Widget input(String label, IconData icon, bool obscureText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
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
                      TitleSection(desc: 'Signup'),
                      input('First Name', Icons.person, false, firstNameController),
                      const SizedBox(height: 10),
                      input('Last Name', Icons.person, false, lastNameController),
                      const SizedBox(height: 10),
                      input('Email', Icons.email, false, emailController),
                      const SizedBox(height: 10),
                      input('Phone Number', Icons.phone, false, phoneNumberController),
                      const SizedBox(height: 10),
                      input('Password', Icons.security, true, passwordController),
                      const SizedBox(height: 10),
                      input('Confirm Password', Icons.security, true, passwordController),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Container(
                          width: 200,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(96, 172, 182, 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              final firstName = firstNameController.text;
                              final lastName = lastNameController.text;
                              final email = emailController.text;
                              final phoneNumber = phoneNumberController.text;
                              final password = passwordController.text;

                              try {
                                final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );

                                final String userId = userCredential.user!.uid;

                                await FirebaseFirestore.instance.collection('users').doc(userId).set({
                                  'firstName': firstName,
                                  'lastName': lastName,
                                  'email': email,
                                  'phoneNumber': phoneNumber,
                                });

                                print('User registered successfully');
                                Navigator.pushNamed(context, '/home');
                              } catch (e) {
                                print('Error during signup: $e');
                                // TODO: Handle any error that occurred during signup
                              }
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextButton(
                        onPressed: () {
                          print('Login button pressed');
                          Navigator.pushNamed(context, '/login');
                        },
                        child: const Text(
                          'Already have an account? Login',
                          style: TextStyle(color: Colors.blue),
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

class TitleSection extends StatelessWidget {
  final String desc;

  TitleSection({required this.desc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 230, bottom: 20),
      child: Text(
        desc,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        softWrap: true,
      ),
    );
  }
}