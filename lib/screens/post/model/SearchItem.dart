import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../home/views/ReportDetailsPage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Items'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Search Items',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('lost')
                  .snapshots()
                  .handleError((error) {
                print('Error fetching data: $error');
                return null;
              }),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error fetching data'),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final documents = snapshot.data!.docs;
                final filteredDocuments = documents.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final title = data['itemTitle']?.toLowerCase() ?? '';
                  final description = data['description']?.toLowerCase() ?? '';
                  final category = data['category']?.toLowerCase() ?? '';
                  final searchLower = _searchQuery.toLowerCase();

                  return title.contains(searchLower) ||
                      description.contains(searchLower) ||
                      category.contains(searchLower);
                }).toList();

                return ListView.builder(
                  itemCount: filteredDocuments.length,
                  itemBuilder: (context, index) {
                    final doc = filteredDocuments[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final title = data['itemTitle'] ?? '';
                    final description = data['description'] ?? '';
                    final category = data['category'] ?? '';

                    return ListTile(
                      title: Text(title),
                      subtitle: Text('$category - $description'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReportDetailsPage(
                              documentId: doc.id,
                              collectionName: 'lost',
                              title: title,
                              description: description,
                              category: category,
                              date: data['date'] != null ? data['date'].toDate() : DateTime.now(), // Provide a valid DateTime value
                              receiverUserEmail: data['receiverUserEmail'] ?? '',
                              receiverUserID: data['receiverUserID'] ?? '',
                              isResolved: data['isResolved'] ?? false,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}