import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found/screens/home/views/main_screen.dart';
import '../../../components/bottomNavBar.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(36, 42, 61, 1),
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.pushNamed(context, '/lost');
        },
        child: const Icon(CupertinoIcons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomNavBar(),
      body: const MainScreen(),
    );
  }
}
