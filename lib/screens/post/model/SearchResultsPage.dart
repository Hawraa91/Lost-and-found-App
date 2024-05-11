import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../components/bottomNavBar.dart';
import '../../../components/customContainer.dart';
import '../../chat/chat_page.dart';

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
        child: SingleChildScrollView(
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
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}