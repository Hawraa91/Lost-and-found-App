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
                    final timestamp = data['itemLostDate'];
                    final DateTime date = timestamp != null ? (timestamp as Timestamp).toDate()
                        : DateTime.now();
                    // Retrieve the receiverUserEmail and receiverUserID from the document
                    final String receiverUserID = data['userId'] ?? '';
                    final bool isPublic = data['isPublic'] ?? false;
                    final bool isResolved = data['isResolved'] ?? false;
                    final String imageUrl = data['imageUrl'] ?? '';

                    //if it is public and not resolved then print
                    if (isPublic && !isResolved) {
                      return Column(
                        children: [
                          const SizedBox(height: 20),
                          CustomContainer(
                            title: title,
                            desc: description,
                            category: category,
                            date: date,
                            receiverUserID: receiverUserID,
                            imageUrl: imageUrl,
                          )
                        ],
                      );
                    }
                    else {
                      return const Center(
                        child: Text('No lost items for this category'),
                      );
                    }
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
