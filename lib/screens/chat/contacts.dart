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
        stream: FirebaseFirestore.instance
            .collection("chat_rooms")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          else {
            if (kDebugMode) {
              print('it came here');
            }

            final chatRooms = snapshot.data!.docs;

            return FutureBuilder<List<DocumentSnapshot>>(
              future: _getMessagesFromChatRooms(chatRooms, currentUserID),
              builder: (context, AsyncSnapshot<List<DocumentSnapshot>> messagesSnapshot) {
                if (messagesSnapshot.hasError) {
                  return Text('Error: ${messagesSnapshot.error}');
                }
                if (messagesSnapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                final messages = messagesSnapshot.data!;

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index].data() as Map<String, dynamic>; // Explicitly cast to Map<String, dynamic>
                    final senderId = message['senderId'] as String; // Access senderId as a String

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(senderId)
                          .get(),
                      builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                        if (userSnapshot.hasError) {
                          return Text('Error: ${userSnapshot.error}');
                        }
                        if (userSnapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        final userData = userSnapshot.data!;
                        final firstName = userData['firstName'];
                        final lastName = userData['lastName'];
                        final email = userData['email'];

                        return ListTile(
                          title: Text('$firstName $lastName'),
                          leading: const Icon(Icons.account_circle),
                          onTap: () {
                            if (kDebugMode) {
                              print('Tapped on item $senderId');
                            }
                            navigateToChat(context, senderId, email);
                          },
                        );
                      },
                    );
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

  Future<List<DocumentSnapshot>> _getMessagesFromChatRooms(List<DocumentSnapshot> chatRooms, String currentUserID) async {
    final List<DocumentSnapshot> messages = [];

    for (final room in chatRooms) {
      final roomID = room.id;
      final messagesSnapshot = await FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(roomID)
          .collection('messages')
          .where('receiverId', isEqualTo: currentUserID)
          .get();

      messages.addAll(messagesSnapshot.docs);
    }

    return messages;
  }

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
