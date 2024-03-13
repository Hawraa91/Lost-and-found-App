import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../post/model/search.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getCurrentUserID(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          final currentUserID = snapshot.data;
          if (currentUserID == null) {
            return const Scaffold(
              body: Center(
                child: Text('User is not logged in.'),
              ),
            );
          } else {
            searchLostItemsForCurrentUser(currentUserID);
            return buildMainScreen(currentUserID);
          }
        }
      },
    );
  }

  Widget buildMainScreen(String currentUserID) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              // Blue green
                              color: Color.fromRGBO(22, 19, 85, 1.0),
                            ),
                          ),
                          const Icon(
                            CupertinoIcons.person_fill,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Report your lost or found item",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,

                            ),
                          ),
                          Text(
                            "Welcome to FindMyThing",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,

                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 40, // Adjust width as needed
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(CupertinoIcons.bell),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Row(
                children: [
                  Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          cardIcon(Icons.key,
                              const Color.fromRGBO(237, 245, 246, 1.0), "Keys"),
                          cardIcon(Icons.headset,
                              const Color.fromRGBO(237, 245, 246, 1.0), "Devices"),
                          cardIcon(Icons.diamond,
                              const Color.fromRGBO(237, 245, 246, 1.0), "Jewels"),
                          cardIcon(Icons.book,
                              const Color.fromRGBO(237, 245, 246, 1.0), "Books"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Row(
                children: [
                  Text(
                    "Lost Items",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              //the blue container
              StreamBuilder<QuerySnapshot>(
                //taking the data from the collection
                stream: FirebaseFirestore.instance.collection('lost').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    //the loading icon
                    return const CircularProgressIndicator();
                  }

                  /* "snapshot.data": This retrieves the data snapshot from
                  the snapshot object. It represents the latest data snapshot of the stream.*/
                  final List<DocumentSnapshot> documents = snapshot.data!.docs; //making sure the doc is not null by using data!
                  return Column(
                    children: documents.map((doc) {
                      /*documents.map((doc) { ... }): This iterates over each DocumentSnapshot in
                      the documents list using the map method*/
                      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                      //TODO: Add the other details of the
                      final String title = data['itemTitle'] ?? ''; // Use default value if null
                      final String description = data['description'] ?? '';
                      final String category = data['category'] ?? '';// Use default value if null
                      final String dateStr = data['itemLostDate'] ?? ''; // Fetch date as string
                      final DateTime date = DateTime.tryParse(dateStr) ?? DateTime.now(); // Convert string to DateTime, fallback to current time if conversion fails


                      return Column(
                        children: [
                          const SizedBox(height: 20), // Add space before the container
                          containerPost(context, title, description, category, date),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  //The category icons method
  Widget cardIcon(IconData icon, Color backgroundColor,String type) {
    return Container(
      height: 65,
      width: 100,
      child: Card(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.5),
              child: Container(
                color: backgroundColor,
                child: Icon(icon),
              ),
            ),
            Text(
              type, // Add your text here
              style: const TextStyle(
                fontSize: 12, // Set the font size as per your requirement
                fontWeight: FontWeight.bold, // Set the font weight as per your requirement
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget containerPost(BuildContext context, String title, String desc, String category, DateTime date) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.grey.shade300,
            offset: const Offset(5, 5),
          )
        ],
        // Dark blue
        color: const Color.fromRGBO(96, 173, 183, 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0), // Adjust padding as needed
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center items vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center items horizontally
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              desc,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Category: $category',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Date: ${DateFormat('yyyy-MM-dd').format(date)}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  //a function to retrieve the current user's ID
  Future<String?> getCurrentUserID() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return null; // User is not logged in
    }
  }
}
