import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../../components/bottomNavBar.dart';
import '../../login&signup/model/EditReportPage.dart';

class UserReport extends StatefulWidget {
  const UserReport({Key? key}) : super(key: key);

  @override
  _UserReportState createState() => _UserReportState();
}

class _UserReportState extends State<UserReport> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Stream<QuerySnapshot> _itemsStream;
  bool _showLost = true;

  @override
  void initState() {
    super.initState();
    _getUserItemsStream();
  }

  void _getUserItemsStream() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userID = user.uid;
      _itemsStream = FirebaseFirestore.instance
          .collection(_showLost ? 'lost' : 'found')
          .where('userId', isEqualTo: userID)
          .snapshots();
    }
  }

  void _toggleReportType(bool isLost) {
    setState(() {
      _showLost = isLost;
      _getUserItemsStream();
    });
  }

  void _markAsResolved(DocumentReference docRef, String collectionName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Mark as Closed'),
          content: const Text('Are you sure you want to mark this Report as Closed?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                docRef.update({'isResolved': true}).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$collectionName Report Marked as Closed'),
                    ),
                  );
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error marking as Closed: $error'),
                    ),
                  );
                });
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reports'),

      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: ToggleButton(
              onToggle: _toggleReportType,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _itemsStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return _buildItemCard(snapshot.data!.docs[index], _showLost ? 'lost' : 'found');
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(), // Use the BottomNavBar widget
    );
  }

  Widget _buildItemCard(DocumentSnapshot doc, String collectionName) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    String title = data['itemTitle'] ?? '';
    String description = data['description'] ?? '';
    String category = data['category'] ?? '';
    final timestamp = data['itemLostDate'];
    final DateTime date = timestamp != null ? (timestamp as Timestamp).toDate() : DateTime.now();
    bool isResolved = data['isResolved'] ?? false;

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(46, 61, 95, 1.0), // Use the same color as CustomContainer
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white, // Text color
            ),
          ),
          const SizedBox(height: 5),
          Text('Category: $category', style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 5),
          Text('Date: ${date.toString().split(' ')[0]}', style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 5),
          Text(description, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Theme(
                data: ThemeData(
                  buttonTheme: ButtonThemeData(
                    buttonColor: Colors.white, // background color
                    textTheme: ButtonTextTheme.primary, // text color
                  ),
                ),
                child: ElevatedButton(
                  onPressed: isResolved
                      ? null
                      : () {
                    _markAsResolved(doc.reference, collectionName);
                  },
                  child: Text(isResolved ? 'Closed' : 'Close '),
                ),
              ),
              const SizedBox(width: 10),
              Theme(
                data: ThemeData(
                  buttonTheme: ButtonThemeData(
                    buttonColor: Colors.white, // background color
                    textTheme: ButtonTextTheme.primary, // text color
                  ),
                ),
                child: ElevatedButton(
                  onPressed: isResolved ? null : () {
                    // Navigate to the EditReportPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditReportPage(
                          documentId: doc.id,
                          collectionName: collectionName,
                          initialTitle: title,
                          initialDescription: description,
                          initialCategory: category,
                          initialDate: date,
                        ),
                      ),
                    );
                  },
                  child: const Text('Edit'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ToggleButton extends StatefulWidget {
  final Function(bool) onToggle;

  const ToggleButton({required this.onToggle, Key? key}) : super(key: key);

  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

const double width = 300.0;
const double height = 60.0;
const double lostAlign = -1;
const double foundAlign = 1;
const Color selectedColor = Color.fromRGBO(6, 33, 68, 1.0);
const normalColor = Colors.black54;

class _ToggleButtonState extends State<ToggleButton> {
  late double xAlign;
  late Color lostColor;
  late Color foundColor;

  @override
  void initState() {
    super.initState();
    xAlign = lostAlign;
    lostColor = selectedColor;
    foundColor = normalColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(
          Radius.circular(50.0),
        ),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: Alignment(xAlign, 0),
            duration: const Duration(milliseconds: 300),
            child: Container(
              width: width * 0.5,
              height: height,
              decoration: BoxDecoration(
                color: selectedColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(50.0),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                xAlign = lostAlign;
                lostColor = selectedColor;
                foundColor = normalColor;
              });
              widget.onToggle(true); // Call callback with true for Lost
            },
            child: Align(
              alignment: const Alignment(-1, 0),
              child: Container(
                width: width * 0.5,
                color: lostColor,
                child: const Center(
                  child: Text(
                    'Lost',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                xAlign = foundAlign;
                lostColor = normalColor;
                foundColor = selectedColor;
              });
              widget.onToggle(false); // Call callback with false for Found
            },
            child: Align(
              alignment: const Alignment(1, 0),
              child: Container(
                width: width * 0.5,
                color: foundColor,
                child: const Center(
                  child: Text(
                    'Found',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
