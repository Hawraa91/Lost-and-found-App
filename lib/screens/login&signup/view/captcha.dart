import 'package:flutter/material.dart';
import 'dart:math';

class CaptachaVerification extends StatefulWidget {
  const CaptachaVerification({super.key});

  @override
  State<CaptachaVerification> createState() => _CaptachaVerificationState();
}

class _CaptachaVerificationState extends State<CaptachaVerification> {
  String randomString = "";
  bool isVerified = false;
  TextEditingController controller = TextEditingController();

  void buildCaptcha() {
    const letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
    const length = 6;

    final random = Random();

    randomString = String.fromCharCodes(List.generate(
        length, (index) => letters.codeUnitAt(random.nextInt(letters.length))));
    setState(() {});
    print("the random string is $randomString");
  }

  @override
  void initState() {
    super.initState();
    buildCaptcha();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Captcha Verification"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter Captcha Value",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    randomString,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    buildCaptcha();
                  },
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  isVerified = false;
                });
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: "Enter Captcha Value",
                labelText: "Enter Captcha Value",
                filled: true,
                fillColor: Colors.grey[200],
              ),
              controller: controller,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                isVerified = controller.text == randomString;

                setState(() {
                  if (isVerified) {
                    Navigator.pushNamed(context, "/login");
                  }
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(46, 61, 95, 1.0)),
              ),
              child: const Text("Check", style: TextStyle(
                  color: Colors.white,
                  fontSize: 16),),
            ),
            const SizedBox(height: 10),
            if (isVerified)
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.verified), Text("Verified")],
              )
            else
              const Text("Please enter the value you see on the screen"),
          ],
        ),
      ),
    );
  }
}
