import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AdminDashboard(),
    );
  }
}

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Map<String, dynamic>> posts = [
    {
      'id': 1,
      'title': 'Exploring Ancient Temples: Unveiling the Mysteries of History',
      'description':
      'Embark on a journey through time as we delve into the rich history of ancient temples,',
      'date': DateTime(2021, 9, 29),
      'coverImageUrl': 'http://example.com/ancient-temples.jpg',
      'postMobileUrl': 'http://example.com/exploring-ancient-temples-mobile'
    },
    // Add the rest of the post data here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/login.png', // Replace with your app icon
              width: 30,
              height: 30,
            ),
            SizedBox(width: 8),
            Text('Super Admin'),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('All Post'),
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add Post'),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Select Date'),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Handle date selection
                  },
                  child: Text('2023-12-16'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Handle max date selection
                  },
                  child: Text('30'),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    // Handle get posts by date
                  },
                  child: Text('Get Posts By Date'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Type to filter post',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Title')),
                        DataColumn(label: Text('Description')),
                        DataColumn(label: Text('Date')),
                        DataColumn(label: Text('Cover Image Url')),
                        DataColumn(label: Text('Post Mobile Url')),
                      ],
                      rows: posts
                          .map(
                            (post) => DataRow(
                          cells: [
                            DataCell(Text(post['id'].toString())),
                            DataCell(Text(post['title'])),
                            DataCell(Text(post['description'])),
                            DataCell(Text(
                                "${post['date'].year}-${post['date'].month.toString().padLeft(2, '0')}-${post['date'].day.toString().padLeft(2, '0')}")),
                            DataCell(Text(post['coverImageUrl'])),
                            DataCell(Text(post['postMobileUrl'])),
                          ],
                        ),
                      )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}