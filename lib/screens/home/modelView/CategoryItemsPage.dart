import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../components/bottomNavBar.dart';
import '../../../components/customContainer.dart';

class CategoryItemPage extends StatelessWidget {
  final String category;

  CategoryItemPage({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('Category: $category');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('$category Filter'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('lost')
              .where('category', isEqualTo: category)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              if (kDebugMode) {
                print('Waiting for data...');
              }
              return const CircularProgressIndicator();
            }

            final List<DocumentSnapshot> documents = snapshot.data!.docs;
            if (kDebugMode) {
              print('Number of documents: ${documents.length}');
            }

            if (documents.isEmpty) {
              return const Center(
                child: Text('No lost items for this category'),
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: documents.map((doc) {
                    final Map<String, dynamic> data =
                    doc.data() as Map<String, dynamic>;
                    final String title = data['itemTitle'] ?? '';
                    final String description = data['description'] ?? '';
                    final String category = data['category'] ?? '';
                    final String dateStr = data['itemLostDate'] ?? '';
                    final DateTime date =
                        DateTime.tryParse(dateStr) ?? DateTime.now();

                    // Retrieve the receiverUserEmail and receiverUserID from the document
                    final String receiverUserEmail = data['receiverUserEmail'] ?? '';
                    final String receiverUserID = data['userId'] ?? '';

                    return Column(
                      children: [
                        const SizedBox(height: 20),
                        CustomContainer(
                          title: title,
                          desc: description,
                          category: category,
                          date: date,
                          receiverUserEmail: receiverUserEmail,
                          receiverUserID: receiverUserID,
                          isResolved: false, // Assuming isResolved is false by default
                        )
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