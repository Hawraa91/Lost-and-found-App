import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../chat/chat_page.dart';

class ReportDetailsPage extends StatelessWidget {
  final String documentId;
  final String collectionName;
  final String title;
  final String description;
  final String category;
  final DateTime? date; // Make the 'date' parameter nullable
  final String receiverUserEmail;
  final String receiverUserID;
  final bool isResolved;

  const ReportDetailsPage({
    Key? key,
    required this.documentId,
    required this.collectionName,
    required this.title,
    required this.description,
    required this.category,
    this.date, // No need to mark it as 'required' since it's nullable
    required this.receiverUserEmail,
    required this.receiverUserID,
    required this.isResolved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomContainer(
              title: title,
              desc: description,
              category: category,
              date: date,
              receiverUserEmail: receiverUserEmail,
              receiverUserID: receiverUserID,
              isResolved: isResolved,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  final String title;
  final String desc;
  final String category;
  final DateTime? date; // Update the 'date' parameter to be nullable
  final String receiverUserEmail;
  final String receiverUserID;
  final bool isResolved;

  const CustomContainer({
    Key? key,
    required this.title,
    required this.desc,
    required this.category,
    this.date, // No need to mark it as 'required' since it's nullable
    required this.receiverUserEmail,
    required this.receiverUserID,
    required this.isResolved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isResolved) {
      return const SizedBox.shrink(); // Don't render anything if isResolved is false
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * 5 / 7,
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
            if (date != null) // Check if date is not null before rendering
              Text(
                'Date: ${DateFormat('yyyy-MM-dd').format(date!)}', // Use ! to access the non-null value
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
    );
  }
}