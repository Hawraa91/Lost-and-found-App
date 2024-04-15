import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../components/customContainer.dart';
import '../../post/model/search.dart';
import '../modelView/CategoryItemsPage.dart';
import '../../../components/bottomSheetPopUp.dart';

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
            final Future<List<String>> matchedTitles = searchLostItemsForCurrentUser(currentUserID) ;
            // Show the bottom sheet with the matched titles
            if (matchedTitles !=null){
              bottomSheetPopUp.show(context, matchedTitles);
            }

            return buildMainScreen(context, currentUserID);
          }
        }
      },
    );
  }

  Widget buildMainScreen(BuildContext context, String currentUserID) {
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
                              // Blue green
                              color: Color.fromRGBO(22, 19, 85, 1.0),
                            ),
                          ),
                          const Icon(
                            CupertinoIcons.person_fill,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Report your lost or found item",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "Welcome to FindMyThing",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 40, // Adjust width as needed
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(CupertinoIcons.bell),
                    ),
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
              const SizedBox(height: 30),
              //the blue container and fetching the data
              StreamBuilder<QuerySnapshot>(
                //taking the data from the collection
                stream:
                    FirebaseFirestore.instance.collection('lost').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
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
                      /*documents.map((doc) { ... }): This iterates over each DocumentSnapshot in
                      the documents list using the map method*/
                      final Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;
                      //TODO: Add the other details of the
                      final String title =
                          data['itemTitle'] ?? ''; // Use default value if null
                      final String description = data['description'] ?? '';
                      final String category =
                          data['category'] ?? ''; // Use default value if null
                      final String dateStr =
                          data['itemLostDate'] ?? ''; // Fetch date as string
                      final DateTime date = DateTime.tryParse(dateStr) ??
                          DateTime
                              .now(); // Convert string to DateTime, fallback to current time if conversion fails

                      return Column(
                        children: [
                          const SizedBox(height: 20),
                          //calling the container method from another class (customContainer.dart)
                          CustomContainer(context,
                              title: title,
                              desc: description,
                              category: category,
                              date: date)
                        ],
                      );
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
}
