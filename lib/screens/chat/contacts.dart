import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../components/bottomNavBar.dart';
import 'chat_page.dart';

class ContactsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Messages'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        //taking the data from the collection
        stream: FirebaseFirestore.instance
            .collection("users")
            .where(FieldPath.documentId, isNotEqualTo: currentUserID)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            //the loading icon
            return const CircularProgressIndicator();
          }
          else {
            if (kDebugMode) {
              print('it came here');
            }
            // Return the ListView.builder with your data
            return ListView.builder(
              itemCount: snapshot.data!.docs.length, // Use the length of documents in the snapshot
              itemBuilder: (context, index) {

                // Access each document using snapshot.data!.docs[index]
                final document = snapshot.data!.docs[index];
                // Access firstName and lastName fields from the document's data
                final firstName = document['firstName'];
                final lastName = document['lastName'];
                final email = document['email'];

                return ListTile(
                  title: Text('$firstName $lastName'), // Use document id or other fields
                  leading: const Icon(Icons.account_circle), // Change this to the leading widget you want
                  onTap: () {
                    // Add any onTap functionality here
                    if (kDebugMode) {
                      print('Tapped on item ${document.id}');
                    }
                    navigateToChat(context, document.id, email); // Pass context, userId, and userEmail to navigateToChat
                  },
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  // Function to navigate to ChatPage
  void navigateToChat(BuildContext context, String userId, String userEmail) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          receiverUserID: userId,
          receiverUserEmail: userEmail,
        ),
      ),
    );
  }
}
