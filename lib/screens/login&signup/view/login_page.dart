import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../components/ImageSection.dart';

void main() => runApp(const Login());

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //pop up dialog if the password is wrong
  Future<void> _showMyDialogPass() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Wrong Password'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You have entered an invalid password.'),
                Text('Please try again'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  //pop up dialog if the email is wrong
  Future<void> _showMyDialogEmail() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('User not found'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You have entered an invalid email.'),
                Text('Please try again'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //sign in with email and password
  Future<void> signIn() async {
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // If sign-in is successful, navigate to the home page
      Navigator.pushNamed(context, '/home');

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        if (kDebugMode) {
          print('No user found for that email.');
        }
        _showMyDialogEmail();
      } else if (e.code == 'wrong-password') {
        if (kDebugMode) {
          print('Wrong password provided for that user.');
        }
        _showMyDialogPass();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected error occurred: $e');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const ImageSection(
                image: 'assets/images/login2.png',
                width: 200,
                height: 250,
              ),
              const TitleSection(desc: 'Login'),

              //email
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(10), // Apply border radius here
                    border: Border.all(
                        color: Colors.grey), // Add border color and width
                  ),
                  child: TextField(
                    controller: _emailController,
                    obscureText: false,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: InputBorder.none, // Remove default input border
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              //password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(10), // Apply border radius here
                    border: Border.all(
                        color: Colors.grey), // Add border color and width
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.security),
                      border: InputBorder.none, // Remove default input border
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
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
                      //navigate to home page
                      signIn();
                      // After signing in, navigate to the home page
                      //Navigator.pushNamed(context, '/home');
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
                  // Navigate to the start page
                  Navigator.pushNamed(context, "/signup");
                },
                child: const Text(
                  'new account? Sign Up',
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to the forget password
                  Navigator.pushNamed(context, "/forgetPassword");
                },
                child: const Text(
                  'Forget Password?',
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
