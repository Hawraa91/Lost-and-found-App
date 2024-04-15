import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../components/bottomNavBar.dart';
import '../../../components/customContainer.dart';

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
        title: Text('$category Filter'),
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
            final List<DocumentSnapshot> documents = snapshot.data!.docs; // Making sure the doc is not null by using data!S
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
              return SingleChildScrollView(
                child: Column(
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
                        //containerPost(context, title, description, category, date),
                        CustomContainer(context,
                            title: title,
                            desc: description,
                            category: category,
                            date: date)
                      ],
                    );
                  }).toList(),
                ),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

