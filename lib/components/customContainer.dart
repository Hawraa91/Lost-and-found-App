//this is a custom container for calling it over and over again
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomContainer extends StatelessWidget {
  final String title;
  final String desc;
  final String category;
  final DateTime date;

  const CustomContainer(BuildContext context, {
    Key? key,
    required this.title,
    required this.desc,
    required this.category,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width*2/3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.grey.shade300,
            offset: const Offset(5, 5),
          )
        ],
        // Dark blue
        color: const Color.fromRGBO(46, 61, 95, 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0), // Adjust padding as needed
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
            // The Button
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
                    // TODO: Navigate to another page to show the details
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
