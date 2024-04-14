import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  final TextEditingController textEditingController = TextEditingController();
  final CollectionReference collectionReference =
  FirebaseFirestore.instance.collection('messages');

  void sendMessage() async {
    final String text = textEditingController.text;
    FirebaseAuth auth = FirebaseAuth.instance;

    if (auth.currentUser != null && text.isNotEmpty) {
      await collectionReference.add({
        'text': text,
        'from': auth.currentUser!.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      textEditingController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: collectionReference.orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                      return ListTile(
                        title: Text(documentSnapshot['text']),
                        subtitle: Text(documentSnapshot['from']),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                return CircularProgressIndicator();
              },
            ),
          ),
          TextField(
            controller: textEditingController,
            decoration: InputDecoration(
              labelText: "Enter message",
              suffixIcon: IconButton(
                icon: Icon(Icons.send),
                onPressed: sendMessage,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
