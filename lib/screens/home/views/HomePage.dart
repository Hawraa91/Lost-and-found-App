
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lost_and_found/screens/home/views/main_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      bottomNavigationBar: ClipRRect( // Corrected ClipRRect
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)), // Corrected BorderRadius
        child: BottomNavigationBar(
          backgroundColor: const Color.fromRGBO(237, 245, 246, 1.0),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 3,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person)
              ,
              label: 'profile',
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
        backgroundColor: const Color.fromRGBO(22, 19, 85, 1.0),
        shape: const CircleBorder(),
        child: const Icon(CupertinoIcons.add, color: Colors.white),
      ),
      body: const MainScreen(),
    );
  }
}
