import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../components/bottomNavBar.dart';
import '../../../components/customContainer.dart';

class SearchResultsPage extends StatefulWidget {
  final List<String> matchedTitles;

  const SearchResultsPage({Key? key, required this.matchedTitles})
      : super(key: key);

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  List<DocumentSnapshot<Map<String, dynamic>>> _documents = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    //fetching the data of each document ID
    for (String documentId in widget.matchedTitles) {
      try {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection('found')
            .doc(documentId)
            .get();
        if (snapshot.exists) {
          setState(() {
            _documents.add(snapshot);
          });
        }
      } catch (error) {
        print('Error fetching document: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: ListView.builder(
        itemCount: _documents.length,
        itemBuilder: (context, index) {
          // Extract data from document
          Map<String, dynamic>? data = _documents[index].data();
          // Display data in ListTile
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
            child: SingleChildScrollView(
                child: Column(
                children: _documents.map((doc) {
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
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
