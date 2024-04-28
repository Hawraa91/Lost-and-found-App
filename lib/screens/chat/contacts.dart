import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'chat_page.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final Stream<QuerySnapshot> _contactsStream = FirebaseFirestore.instance.collection('users').snapshots();

  void navigateToChat(String userId, String userEmail) {
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

  @override
  Widget build(BuildContext context) {
    final String currentUserID = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _contactsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return FutureBuilder<List<String>>(
            future: _fetchSenderIDs(currentUserID),
            builder: (BuildContext context, AsyncSnapshot<List<String>> senderIDsSnapshot) {
              if (senderIDsSnapshot.hasData) {
                List<String> senderIDs = senderIDsSnapshot.data!;

                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    // fetching the user email
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    final String contactID = document.id;
                    if(kDebugMode){
                      for(var ids in senderIDs) {
                        print(ids);
                      }
                    }
                    List<String> matchingEmails = [];

                    // Check if the sender IDs list contains the current contact ID
                    if (senderIDs.contains(contactID)) {
                      // Add the email to the matchingEmails list
                      // matchingEmails.add(data['email']);
                    }

                    return ListTile(
                      title: Text(matchingEmails.isNotEmpty ? matchingEmails.join(', ') : data['email']), // Display matching emails or default email
                      onTap: () => navigateToChat(contactID, data['email']),
                    );
                  }).toList(),
                );
              } else if (senderIDsSnapshot.hasError) {
                return Text('Error getting sender IDs: ${senderIDsSnapshot.error}');
              } else {
                return const SizedBox(); // Placeholder widget while loading sender IDs
              }
            },
          );
        },
      ),
    );
  }
}

//fetching the sender id function, to get the contacts
Future<List<String>> _fetchSenderIDs(String currentUserID) async {
  // Initialize a list to store sender IDs
  List<String> senderIDs = [];

  // Get a reference to the chat_room collection
  final chatRoomRef = FirebaseFirestore.instance.collection('chat_room');

  try {
    // Get all documents in the chat_room collection (consider security rules)
    //this document is the chatroom , then i'm fetching the chat rooms
    final chatRoomSnapshot = await chatRoomRef.get();

    //going through the documents (chat rooms)
    for (var chatDoc in chatRoomSnapshot.docs)
    {
      // Get a reference to the messages sub-collection within the current chat document
      final messagesRef = chatDoc.reference.collection('messages');
      // Query the messages sub-collection to find messages where receiverID matches currentID
      final messageSnapshot = await messagesRef.where('receiverId', isEqualTo: currentUserID).get();

      // Iterate through the message documents
      for (var messageDoc in messageSnapshot.docs)
      {
        // Extract the sender ID from the message document
        final email = messageDoc.data()['senderEmail'];
        //debugging
        if (kDebugMode) {
          print('$email');
        }
        if (email != null) {
          senderIDs.add(email); // Add the sender ID to the list
        }
      }
    }
  } catch (error) {
    if (kDebugMode) {
      print('Error getting sender IDs: $error');
    }
  }

  return senderIDs;
}