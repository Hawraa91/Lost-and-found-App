import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lost_and_found/screens/home/views/main_screen.dart';
import 'package:lost_and_found/screens/home/views/profilePage.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    MainScreen(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: BottomNavigationBar(
          backgroundColor: const Color.fromRGBO(237, 245, 246, 1.0),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 3,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // New post action
        },
        backgroundColor: const Color.fromRGBO(22, 19, 85, 1.0),
        shape: const CircleBorder(),
        child: const Icon(CupertinoIcons.add, color: Colors.white),
      ),
      body: _pages[_selectedIndex],
    );
  }
}