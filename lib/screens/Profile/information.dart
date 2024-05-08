import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InformationPage extends StatelessWidget {
  const InformationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Information'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Instructions:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Welcome to our Lost and Found app! Here are some instructions to help you get started:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                '1. Reporting a Lost Item:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '- Tap the "Report Lost Item" button on the home screen.\n- Fill in the details of the lost item, including its description, category, and the location where it was lost.\n- Upload a photo of the item to help others identify it.\n- Submit the report, and your lost item will be listed for others to see.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              const Text(
                '2. Reporting a Found Item:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '- Tap the "Report Found Item" button on the home screen.\n- Fill in the details of the found item, including its description, category, and the location where it was found.\n- Upload a photo of the item to help others identify it.\n- Submit the report, and your found item will be listed for others to see.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              const Text(
                '3. Searching for Items:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '- Use the search bar to search for lost or found items based on keywords or categories.\n- Filter the results by location or date to narrow down your search.\n- Tap on an item to view its details and contact information.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('role', isEqualTo: 'admin')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  final supportEmail = snapshot.data!.docs.first.get('email');

                  return Text(
                    'If you have any questions or need further assistance, please contact our support team at $supportEmail.',
                    style: const TextStyle(fontSize: 14),
                  );
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Admin Emails:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('role', isEqualTo: 'admin')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  final adminEmails = snapshot.data!.docs
                      .map((doc) => doc.get('email'))
                      .toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: adminEmails.map((email) => Text(email)).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}