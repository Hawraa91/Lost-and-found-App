import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../screens/chat/chat_page.dart';

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
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width *5/7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.grey.shade300,
            offset: const Offset(5, 5),
          )
        ],
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
              padding: const EdgeInsets.only(top: 30),
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
                          receiverUserID: receiverUserID
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
    );
  }
}

// Usage example
Widget build(BuildContext context) {
  final lostItems = [
    {
      'itemTitle': 'Keychain',
      'description': 'small white bag keychain',
      'category': 'Keys',
      'itemLostDate': '2024-03-11 00:00:00.000',
      'receiverUserEmail': 'finder@example.com',
      'userId': 'cY3TSi5qgvhpTFbOp4nMeA7W1qui',
    },
    // Add more lost items here
  ];

  return ListView.builder(
    itemCount: lostItems.length,
    itemBuilder: (context, index) {
      final item = lostItems[index];
      return CustomContainer(
        title: item['itemTitle']!,
        desc: item['description']!,
        category: item['category']!,
        date: DateTime.parse(item['itemLostDate']!),
        receiverUserEmail: item['receiverUserEmail']!,
        receiverUserID: item['userId']!,
      );
    },
  );
}