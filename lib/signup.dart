import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MaterialApp(
  home: Signup(),
  // other configurations
));

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
  final TextEditingController confirmPasswordController =
  TextEditingController(); // New controller

  final RegExp passwordPattern =
  RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
  final RegExp passwordMatchPattern =
  RegExp(r'^$|^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  bool _isPasswordVisible = false; // New variable to track password visibility

  @override
  void initState() {
    super.initState();
    _initializeFirebase = _initializeFirebaseApp();
  }

  Future<FirebaseApp> _initializeFirebaseApp() async {
    return await Firebase.initializeApp();
  }

  Future<void> signUp() async {
    // Validate password strength
    if (!passwordPattern.hasMatch(passwordController.text)) {
      // Password is weak, show error message
      print('Weak password');
      // You can display an error message to the user using a Snackbar or some other UI element
      return;
    }

    // Check if password and confirm password match
    if (passwordController.text != confirmPasswordController.text) {
      // Passwords don't match, show error message
      print('Passwords do not match');
      // You can display an error message to the user using a Snackbar or some other UI element
      return;
    }

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Get the user ID after successful sign-up
      String userId = userCredential.user!.uid;

      // Save additional user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'email': emailController.text,
        'phoneNumber': phoneNumberController.text,
      });

      // Navigate to the next screen or perform any other action after sign-up
      // For example, you can use Navigator.pushNamed to navigate to another screen
      // Navigator.pushNamed(context, '/next_screen');
    } catch (e) {
      // Handle sign-up errors
      print("Error during sign-up: $e");
      // You can display an error message to the user using a Snackbar or some other UI element
    }
  }

  Widget input(String label, IconData icon, bool obscureText,
      TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Enter your $label',
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
          ),
        ),
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
                child: Column(
                  children: <Widget>[
                    TitleSection(desc: 'Signup'),
                    input('First Name', Icons.person, false,
                        firstNameController),
                    const SizedBox(height: 10),
                    input(
                        'Last Name', Icons.person, false, lastNameController),
                    const SizedBox(height: 10),
                    input('Email', Icons.email, false, emailController),
                    const SizedBox(height: 10),
                    input('Phone Number', Icons.phone, false,
                        phoneNumberController),
                    const SizedBox(height: 10),
                    input('Password', Icons.security, _isPasswordVisible,
                        passwordController),
                    const SizedBox(height: 10),
                    input('Confirm Password', Icons.security, true,
                        confirmPasswordController),
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
                            Navigator.pushNamed(context, '/login');
                            await signUp();
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

  const TitleSection({required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 32.0),
      child: Column(
        children: <Widget>[
          Text(
            desc,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}