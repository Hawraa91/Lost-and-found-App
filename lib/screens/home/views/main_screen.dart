import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../components/customContainer.dart';
import '../../post/model/searchAlgo.dart';
import '../modelView/CategoryItemsPage.dart';
import '../../../components/bottomSheetPopUp.dart';
import 'UserReport.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key});

  @override
  //fetching the current user's id
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getCurrentUserID(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          final currentUserID = snapshot.data;
          if (currentUserID == null) {
            return const Scaffold(
              body: Center(
                child: Text('User is not logged in.'),
              ),
            );
          } else {
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUserID) // Fetch the document corresponding to the current user ID
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                final Map<String, dynamic>? userData =
                snapshot.data?.data() as Map<String, dynamic>?;

                // Extract imageUrl from userData
                final String? imageUrl = userData?['imageUrl'];

                //Searching for items and pop up message
                searchLostItemsForCurrentUser(currentUserID).then((matchedTitles) {
                  if (kDebugMode) {
                    print(matchedTitles);
                  }
                  if (matchedTitles.isNotEmpty) {
                    bottomSheetPopUp.show(context, matchedTitles);
                  }
                });

                return buildMainScreen(context, currentUserID, imageUrl!);
              },
            );
          }
        }
      },
    );
  }
}



Widget buildMainScreen(BuildContext context, String currentUserID, String imageUrl) {
  return SafeArea(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(22, 19, 85, 1.0),
                          ),
                        ),
                        Container(
                          height: 60, // Adjust the height as per your requirement
                          width: 60, // Adjust the width as per your requirement
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black, // You can change the border color if needed
                              width: 2, // You can adjust the border width if needed
                            ),
                          ),
                          child: ClipOval(
                            child: imageUrl != null
                                ? Image.network(
                              imageUrl!,
                              fit: BoxFit.cover,
                            )
                                : const Icon(
                              Icons.person, // Placeholder icon in case image URL is null
                              size: 60, // Size of the placeholder icon
                              color: Colors.grey, // Color of the placeholder icon
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Report your lost or found item",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            const Text(
                              "Welcome to FindMyThing",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 5), // Add spacing between text and icon
                            IconButton(
                              onPressed: () => Navigator.pushNamed(context, "/location"),
                              icon: const Icon(Icons.location_on),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Row(
              children: [
                Text(
                  "Categories",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        CardIcon(
                          Icons.key,
                          const Color.fromRGBO(215, 225, 238, 1),
                          "Keys",
                              () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CategoryItemPage(category: 'Keys'),
                              ),
                            );
                          },
                        ),
                        CardIcon(
                          Icons.headset,
                          const Color.fromRGBO(215, 225, 238, 1),
                          "Devices",
                              () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CategoryItemPage(category: 'Devices'),
                              ),
                            );
                          },
                        ),
                        CardIcon(
                          Icons.diamond,
                          const Color.fromRGBO(215, 225, 238, 1),
                          "Jewels",
                              () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CategoryItemPage(category: 'Jewels'),
                              ),
                            );
                          },
                        ),
                        CardIcon(
                          Icons.account_balance_wallet,
                          const Color.fromRGBO(215, 225, 238, 1),
                          "Wallet",
                              () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CategoryItemPage(category: 'Wallet'),
                              ),
                            );
                          },
                        ),
                        CardIcon(
                          Icons.question_mark_rounded,
                          const Color.fromRGBO(215, 225, 238, 1),
                          "Others",
                              () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CategoryItemPage(category: 'Others'),
                              ),
                            );
                          },
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('categories')
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }

                            final List<DocumentSnapshot> documents =
                                snapshot.data!.docs;

                            // Debugging print statement
                            if (kDebugMode) {
                              print(
                                  'Number of documents: ${documents.length}');
                            }

                            return Container(
                              width: 100,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: documents.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final Map<String, dynamic> data =
                                  documents[index].data()
                                  as Map<String, dynamic>;
                                  final String category =
                                  data['name'] as String;

                                  return CardIcon(
                                    Icons.category, // Set your desired icon
                                    const Color.fromRGBO(215, 225, 238, 1),
                                    category,
                                        () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CategoryItemPage(
                                                  category: category),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // User Report Container
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserReport(),
                    ),
                  );
                },
                child: Container(
                  width: 350,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(
                        46, 61, 95, 1.0), // Dark blue color
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const Center(
                    // Center the text horizontally and vertically
                    child: Text(
                      'My Report',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )),
            const SizedBox(height: 30),
            const Row(
              children: [
                Text(
                  "Lost Items",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            //the blue container and fetching the data
            StreamBuilder<QuerySnapshot>(
              //taking the data from the collection
              stream: FirebaseFirestore.instance.collection('lost').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  //the loading icon
                  return const CircularProgressIndicator();
                }
                /* "snapshot.data": This retrieves the data snapshot from
                  the snapshot object. It represents the latest data snapshot of the stream.*/
                final List<DocumentSnapshot> documents = snapshot.data!
                    .docs; //making sure the doc is not null by using data!
                return Column(
                  children: documents.map((doc) {
                    final Map<String, dynamic> data =
                    doc.data() as Map<String, dynamic>;
                    final String title = data['itemTitle'] ?? '';
                    final String description = data['description'] ?? '';
                    final String category = data['category'] ?? '';
                    final timestamp = data['itemLostDate'];
                    final DateTime date = timestamp != null
                        ? (timestamp as Timestamp).toDate()
                        : DateTime.now();
                    final String receiverUserID = data['userId'] ?? '';
                    final bool isPublic = data['isPublic'] ?? false;
                    final bool isResolved = data['isResolved'] ?? false;
                    final String imageUrl = data['imageUrl'] ?? '';

                    if (isPublic && !isResolved) {
                      return Column(
                        children: [
                          const SizedBox(height: 20),
                          CustomContainer(
                            title: title,
                            desc: description,
                            category: category,
                            date: date,
                            receiverUserID: receiverUserID,
                            imageUrl: imageUrl,
                          )
                        ],
                      );
                    } else {
                      return Container(); // Return an empty Container if isPublic is false
                    }
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}

//a function to retrieve the current user's ID
Future<String?> getCurrentUserID() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;
  if (user != null) {
    return user.uid;
  } else {
    return null; // User is not logged in
  }
}

//The category icons method
Widget CardIcon(
    IconData icon, Color backgroundColor, String type, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 65,
      width: 100,
      child: Card(
        color: backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon),
            const SizedBox(height: 5), // Added SizedBox for spacing
            Text(
              type,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

