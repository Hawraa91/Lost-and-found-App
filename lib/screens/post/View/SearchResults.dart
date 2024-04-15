import 'package:flutter/material.dart';
import '../../../components/bottomNavBar.dart';
class SearchResultsPage extends StatelessWidget {
  final List<String> matchedTitles;

  const SearchResultsPage({Key? key, required this.matchedTitles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the matchedTitles to display search results
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: ListView.builder(
        itemCount: matchedTitles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(matchedTitles[index]),
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
