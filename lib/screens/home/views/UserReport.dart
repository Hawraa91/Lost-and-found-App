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
  late Stream<QuerySnapshot> _lostItemsStream;
  late Stream<QuerySnapshot> _foundItemsStream;

  @override
  void initState() {
    super.initState();
    _getUserItemsStream();
  }

  void _getUserItemsStream() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userID = user.uid;
      _lostItemsStream = FirebaseFirestore.instance
          .collection('lost')
          .where('userId', isEqualTo: userID)
          .snapshots();
      _foundItemsStream = FirebaseFirestore.instance
          .collection('found')
          .where('userId', isEqualTo: userID)
          .snapshots();
    }
  }

  void _markAsResolved(DocumentReference docRef, String collectionName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Mark as Resolved'),
          content: const Text('Are you sure you want to mark this item as resolved?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                docRef.update({'isResolved': true}).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$collectionName item marked as resolved'),
                    ),
                  );
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error marking as resolved: $error'),
                    ),
                  );
                });
              },
              child: const Text('Resolve'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Report'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _lostItemsStream,
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

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return _buildItemCard(snapshot.data!.docs[index], 'lost');
                  },
                );
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _foundItemsStream,
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

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return _buildItemCard(snapshot.data!.docs[index], 'found');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(DocumentSnapshot doc, String collectionName) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    String title = data['itemTitle'] ?? '';
    String description = data['description'] ?? '';
    String category = data['category'] ?? '';
    final timestamp = data['itemLostDate'];
    final DateTime date = timestamp != null ? (timestamp as Timestamp).toDate() : DateTime.now();
    bool isResolved = data['isResolved'] ?? false;

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
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: isResolved
                    ? null
                    : () {
                  _markAsResolved(doc.reference, collectionName);
                },
                child: Text(isResolved ? 'Resolved' : 'Resolve'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}