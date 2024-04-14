import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found/screens/home/views/main_screen.dart';
import '../../../components/bottomNavBar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: const IconThemeData(size: 22),
        backgroundColor: const Color.fromRGBO(36, 42, 61, 1),
        foregroundColor: Colors.white,
        visible: true,
        curve: Curves.bounceIn,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.find_replace),
            backgroundColor: Colors.red,
            label: 'Lost',
            onTap: () {
              Navigator.pushNamed(context, '/lost');
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.find_in_page),
            backgroundColor: Colors.green,
            label: 'Found',
            onTap: () {
              Navigator.pushNamed(context, '/found');
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomNavBar(),
      body: const MainScreen(),
    );
  }
}