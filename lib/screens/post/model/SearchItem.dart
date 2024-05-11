import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../components/bottomNavBar.dart';
import '../../../components/customContainer.dart';
import '../../chat/chat_page.dart';

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
                  final isPublic = data['isPublic'] ?? true; // Assuming isPublic is true by default
                  final isResolved = data['isResolved'] ?? false; // Assuming isResolved is false by default

                  return isPublic &&
                      !isResolved &&
                      (title.contains(searchLower) ||
                          description.contains(searchLower) ||
                          category.contains(searchLower));
                }).toList();

                return ListView.builder(
                  itemCount: filteredDocuments.length,
                  itemBuilder: (context, index) {
                    final doc = filteredDocuments[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final title = data['itemTitle'] ?? '';
                    final description = data['description'] ?? '';
                    final category = data['category'] ?? '';
                    final date = data['date'] != null
                        ? data['date'].toDate()
                        : DateTime.now();
                    final receiverUserEmail = data['receiverUserEmail'] ?? '';
                    final receiverUserID = data['receiverUserID'] ?? '';
                    final String imageUrl = data['imageUrl'] ?? '';

                    return ListTile(
                      title: GestureDetector(
                        onTap: () {
                          print('i was clicked');
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

class SearchItemResultPage extends StatelessWidget {
  final String title;
  final String desc;
  final String category;
  final DateTime date;
  final String receiverUserID;
  final String imageUrl;

  SearchItemResultPage({
    Key? key,
    required this.category,
    required this.title,
    required this.desc,
    required this.date,
    required this.receiverUserID,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            CustomContainer(
              title: title,
              desc: desc, // Corrected variable name from 'description' to 'desc'
              category: category,
              date: date,
              receiverUserID: receiverUserID,
              imageUrl: imageUrl,
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
