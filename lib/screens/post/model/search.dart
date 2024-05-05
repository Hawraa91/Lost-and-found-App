import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SearchResults {
  final List<String> matchedTitles;
  final bool found;

  SearchResults({required this.matchedTitles, required this.found});
}

/* i grab the lost items with the current users ID, then i save them in variables,
* then i get all the docs that are active
* The i do the matching */
Future<List<String>> searchLostItemsForCurrentUser(String currentUserID) async {
  //store the matched in this list
  List<String> matchedTitles = [];
  try {
    // Perform a query to find lost items that match the current user's information
    QuerySnapshot lostItemsSnapshot = await FirebaseFirestore.instance
        .collection('lost')
        .where('userId', isEqualTo: currentUserID)
        .get();
    //perform query to grab all the found items information
    QuerySnapshot foundItemsSnapshot =
        await FirebaseFirestore.instance.collection('found').get();

    //save all the fields of the lost item
    for (var lostDoc in lostItemsSnapshot.docs) {
      // Extract information from the lost document
      //String? lostTitle = (lostDoc.data() as Map<String, dynamic>?)?['itemTitle'];
      String? lostName = (lostDoc.data() as Map<String, dynamic>?)?['itemName'];
      String? lostName2 = lostName?.toLowerCase();
      if (kDebugMode) {
        print('object in lower case --> $lostName2');
      }
      String? lostCateg =
          (lostDoc.data() as Map<String, dynamic>?)?['category'];
      bool? lostResolved =
          (lostDoc.data() as Map<String, dynamic>?)?['isResolved'];

      // Iterate through the found items
      for (var foundDoc in foundItemsSnapshot.docs) {
        // Extract information from the found document
        String? foundTitle =
            (foundDoc.data() as Map<String, dynamic>?)?['itemTitle'];
        String? foundName =
            (foundDoc.data() as Map<String, dynamic>?)?['itemName'];
        String? foundName2 = foundName?.toLowerCase();
        String? secondCateg =
            (foundDoc.data() as Map<String, dynamic>?)?['category'];
        String? foundItemId = foundDoc.id;

        // Check if the titles of the lost and found items match (only if it was not resolved)
        if (lostResolved != true) {
          if (lostName2 == foundName2 && lostCateg == secondCateg) {
            // Found a match, you can take further action here
            if (kDebugMode) {
              matchedTitles.add(foundItemId);
              print('Match found! Found item title: $foundTitle');
            } else {
              if (kDebugMode) {
                print('No Match Found Yet! ');
              }
            }
          }
        }
      }
    }
  } catch (error) {
    if (kDebugMode) {
      print('Error searching for lost items: $error');
    }
  }
  return matchedTitles;
}
