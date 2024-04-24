import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _emailController = TextEditingController();
  bool _isEmailEmpty = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> passwordReset() async {
    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _isEmailEmpty = true;
      });
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Check Email'),
            content: const Text('Email sent to reset password via link'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Error: ${e.message}'),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Enter Your Email',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: _isEmailEmpty ? Colors.red : Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: _isEmailEmpty ? Colors.red : Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'Enter your email',
                hintStyle: TextStyle(color: _isEmailEmpty ? Colors.red : Colors.grey),
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: 300,
            height: 65,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(46, 61, 95, 1.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: MaterialButton(
              onPressed: () => passwordReset(),
              child: Text(
                'Reset Password',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
