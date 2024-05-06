import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
                      !isResolved && (title.contains(searchLower) ||
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
                    final date = data['date'] != null ? data['date'].toDate() : DateTime.now();
                    final receiverUserEmail = data['receiverUserEmail'] ?? '';
                    final receiverUserID = data['receiverUserID'] ?? '';

                    return ListTile(
                      title: Text(title),
                      subtitle: Text('$category - $description'),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CustomContainer(
                              title: title,
                              desc: description,
                              category: category,
                              date: date,
                              receiverUserEmail: receiverUserEmail,
                              receiverUserID: receiverUserID,
                            );
                          },
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

class CustomContainer extends StatelessWidget {
  final String title;
  final String desc;
  final String category;
  final DateTime date;
  final String receiverUserEmail;
  final String receiverUserID;

  const CustomContainer({
    Key? key,
    required this.title,
    required this.desc,
    required this.category,
    required this.date,
    required this.receiverUserEmail,
    required this.receiverUserID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * 5 / 7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color.fromRGBO(46, 61, 95, 1.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              Text(
                'Description: $desc',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              Text(
                'Category: $category',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              Text(
                'Date: ${DateFormat('yyyy-MM-dd').format(date)}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
                textAlign: TextAlign.left,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  width: 125,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(246, 245, 243, 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            receiverUserEmail: receiverUserEmail,
                            receiverUserID: receiverUserID,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Contact',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
