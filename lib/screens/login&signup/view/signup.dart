import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: Signup(),
    // other configurations
  ));
}

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  late Future<FirebaseApp> _initializeFirebase;
  final _formKey = GlobalKey<FormState>(); // Add a form key
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController(); // New controller

  @override
  void initState() {
    super.initState();
    _initializeFirebase = _initializeFirebaseApp();
    _initializeFirebase.then((_) {
      setState(() {}); // Refresh the UI after Firebase is initialized
    });
  }

  Future<FirebaseApp> _initializeFirebaseApp() async {
    return await Firebase.initializeApp();
  }

  Future<void> signUp() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Send email verification
      await userCredential.user!.sendEmailVerification();

      // Get the user ID after successful sign-up
      String userId = userCredential.user!.uid;

      // Save additional user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'email': emailController.text,
        'phoneNumber': phoneNumberController.text,
        'imageUrl': "https://firebasestorage.googleapis.com/"
            "v0/b/findmything-9663a.appspot.com/o/"
            "images%2F1715060427112746?alt=media&token=4b71b2ef-abb2-4662-9a68-0d421c2510b7"
      });

      // Navigate to the login screen only after successful sign-up
      Navigator.pushNamed(context, '/login');
    } catch (e) {
      // Handle sign-up errors
      print("Error during sign-up: $e");
      // You can display an error message to the user using a Snackbar or some other UI element
    }
  }

  Widget input(String label, IconData icon, bool obscureText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: Icon(icon),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label is required';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: _initializeFirebase,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
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
                      input('Confirm Password', Icons.security, true, confirmPasswordController),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Container(
                          width: 350,
                          height: 65,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(46, 61, 95, 1.0),
                            borderRadius:
                            BorderRadius.circular(8.0),
                          ),
                          child: TextButton(
                            onPressed:
                                () async {
                              if (_formKey.currentState!.validate()) {
                                await signUp();
                              }
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/captcha');
                        },
                        child: const Text(
                          'Already have an account? Login',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
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
