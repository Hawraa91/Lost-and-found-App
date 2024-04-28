import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserReport extends StatefulWidget {
  const UserReport({Key? key}) : super(key: key);

  @override
  _UserReportState createState() => _UserReportState();
}

class _UserReportState extends State<UserReport> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Stream<QuerySnapshot> _userItemsStream;

  @override
  void initState() {
    super.initState();
    _getUserItemsStream();
  }

  void _getUserItemsStream() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userID = user.uid;
      _userItemsStream = FirebaseFirestore.instance
          .collection('lost')
          .where('userId', isEqualTo: userID)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Report'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _userItemsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data?.docs.isEmpty ?? true) {
            return const Center(
              child: Text('No items found'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = snapshot.data!.docs[index];
              Map<String, dynamic> data =
              doc.data() as Map<String, dynamic>;
              String title = data['itemTitle'] ?? '';
              String description = data['description'] ?? '';
              String category = data['category'] ?? '';
              String dateStr = data['itemLostDate'] ?? '';
              DateTime date = DateTime.tryParse(dateStr) ?? DateTime.now();

              return Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text('Category: $category'),
                    const SizedBox(height: 5),
                    Text('Date: ${date.toString().split(' ')[0]}'),
                    const SizedBox(height: 5),
                    Text(description),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}