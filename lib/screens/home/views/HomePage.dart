import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lost_and_found/screens/home/views/main_screen.dart'; // Import CupertinoIcons

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: ClipRRect( // Corrected ClipRRect
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)), // Corrected BorderRadius
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 3,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
              label: 'Stats',
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
      FloatingActionButton (
        onPressed: (){
          //new post action
        },
        shape: const CircleBorder(),
        child: const Icon(CupertinoIcons.add),
      ),
      body: const MainScreen(),
    );
  }
}
