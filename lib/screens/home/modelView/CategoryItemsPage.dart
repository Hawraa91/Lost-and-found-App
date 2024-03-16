import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../../components/bottomNavBar.dart';

class CategoryItemPage extends StatelessWidget {
  // Retrieving the category from the main_screen page
  final String category;

  CategoryItemPage({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Debugging
    if (kDebugMode) {
      print('Category: $category');
    } // Print the category for debugging

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
        child: StreamBuilder<QuerySnapshot>(
          // Taking the data from the collection
          // Filter items by category
          stream: FirebaseFirestore.instance.collection('lost').where('category', isEqualTo: category).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              // Debugging
              if (kDebugMode) {
                print('Waiting for data...');
              }
              // The loading icon
              return const CircularProgressIndicator();
            }

            final List<DocumentSnapshot> documents = snapshot.data!.docs; // Making sure the doc is not null by using data!

            // Debugging
            if (kDebugMode) {
              print('Number of documents: ${documents.length}');
            } // Print the number of documents for debugging

            if (documents.isEmpty) {
              // Return a message indicating no data found
              return const Center(
                child: Text('No lost items for this category'),
              );
            } else {
              return Column(
                children: documents.map((doc) {
                  final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                  final String title = data['itemTitle'] ?? '';
                  final String description = data['description'] ?? '';
                  final String category = data['category'] ?? '';
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
            }
          },
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
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
