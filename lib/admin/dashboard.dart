import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mishwar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int numberOfUsers = 0;
  int numberOfLostItems = 0;
  int numberOfFoundItems = 0;

  @override
  void initState() {
    super.initState();
    fetchStatistics();
  }

  Future<void> fetchStatistics() async {
    QuerySnapshot<Map<String, dynamic>> usersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isNotEqualTo: 'admin')
        .get();
    numberOfUsers = usersSnapshot.size;

    QuerySnapshot<Map<String, dynamic>> lostItemsSnapshot = await FirebaseFirestore.instance
        .collection('lost')
        .get();
    numberOfLostItems = lostItemsSnapshot.size;

    QuerySnapshot<Map<String, dynamic>> foundItemsSnapshot = await FirebaseFirestore.instance
        .collection('found')
        .get();
    numberOfFoundItems = foundItemsSnapshot.size;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'MSHWAR',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            CircleAvatar(
              backgroundImage: AssetImage('assets/profile.jpg'),
              backgroundColor: Colors.white,
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: Colors.grey[200],
            unselectedIconTheme: IconThemeData(color: Colors.grey),
            selectedIconTheme: IconThemeData(color: Colors.blue),
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.insert_chart_outlined),
                label: Text('Reports'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.request_page),
                label: Text('Request'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people),
                label: Text('Users'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.store),
                label: Text('Shops'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text('Profile'),
              ),
            ], selectedIndex: null,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatisticCard(
                          icon: Icons.store,
                          value: numberOfFoundItems.toString(),
                          label: 'Number of Found Item',
                        ),
                        StatisticCard(
                          icon: Icons.person,
                          value: numberOfLostItems.toString(),
                          label: 'Number of Lost Item',
                        ),
                        StatisticCard(
                          icon: Icons.shopping_cart,
                          value: '2',
                          label: 'Number of Claim this month',
                        ),
                        StatisticCard(
                          icon: Icons.attach_money,
                          value: numberOfUsers.toString(),
                          label: 'Number of Users',
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            height: 200,
                            color: Colors.grey[300],
                            child: Center(
                              child: Text(
                                'Monthly Summary Chart',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            height: 200,
                            color: Colors.grey[300],
                            child: Center(
                              child: Text(
                                'Monthly Order Summary Chart',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatisticCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  StatisticCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
