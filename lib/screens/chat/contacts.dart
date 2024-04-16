import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final Stream<QuerySnapshot> _contactsStream =
  FirebaseFirestore.instance.collection('contacts').snapshots();

  navigateToChat(String userId) {
    // Navigate to chat screen with the user ID
    // You can pass the userId to the chat screen and use it to fetch the chat messages
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _contactsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
              document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['name']),
                onTap: () => navigateToChat(document.id),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}