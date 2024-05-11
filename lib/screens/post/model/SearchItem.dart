import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../components/bottomNavBar.dart';
import '../../../components/customContainer.dart';
import '../../chat/chat_page.dart';
import 'SearchResultsPage.dart';

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
                  _searchQuery = value.toLowerCase(); // Convert to lowercase for case-insensitive search
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
              stream: FirebaseFirestore.instance.collection('lost').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final List<DocumentSnapshot> documents = snapshot.data!.docs;
                final filteredDocuments = documents.where((doc) {
                  final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                  final String title = data['itemTitle']?.toString().toLowerCase() ?? '';
                  final String description = data['description']?.toString().toLowerCase() ?? '';
                  final String category = data['category']?.toString().toLowerCase() ?? '';

                  return data['isPublic'] == true &&
                      data['isResolved'] == false &&
                      (title.contains(_searchQuery) ||
                          description.contains(_searchQuery) ||
                          category.contains(_searchQuery));
                }).toList();

                return ListView.builder(
                  itemCount: filteredDocuments.length,
                  itemBuilder: (context, index) {
                    final doc = filteredDocuments[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final title = data['itemTitle'] ?? '';
                    final description = data['description'] ?? '';
                    final category = data['category'] ?? '';
                    final date = data['itemLostDate'] != null
                        ? (data['itemLostDate'] as Timestamp).toDate()
                        : DateTime.now();
                    final receiverUserEmail = data['receiverUserEmail'] ?? '';
                    final receiverUserID = data['userId'] ?? '';
                    final String imageUrl = data['imageUrl'] ?? '';

                    return ListTile(
                      title: GestureDetector(
                        onTap: () {
                          print('I was clicked');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchItemResultPage(
                                title: title,
                                desc: description,
                                category: category,
                                date: date,
                                receiverUserID: receiverUserID,
                                imageUrl: imageUrl,
                              ),
                            ),
                          );
                        },
                        child: Text(title),
                      ),
                      subtitle: Text('$category - $description'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
