import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/* i grab the lost items with the current users ID, then i save them in variables,
* then i get all the docs that are active
* The i do the matching */
Future<void> searchLostItemsForCurrentUser(String currentUserID) async
{
  try {
    // Perform a query to find lost items that match the current user's information
    QuerySnapshot lostItemsSnapshot = await FirebaseFirestore.instance
        .collection('lost')
        .where('userId', isEqualTo: currentUserID)
        .get();

    //perform query to grab all the found items info
    QuerySnapshot foundItemsSnapshot =
    await FirebaseFirestore.instance.collection('found').get();

    //save all the fields of the lost item
    for (var lostDoc in lostItemsSnapshot.docs) {
      // Extract information from the lost document
      String? lostTitle = (lostDoc.data() as Map<String, dynamic>?)?['itemTitle'];
      String? lostName = (lostDoc.data() as Map<String, dynamic>?)?['itemName'];
      String? lostCateg = (lostDoc.data() as Map<String, dynamic>?)?['category'];

      // Iterate through the found items
      for (var foundDoc in foundItemsSnapshot.docs) {
        // Extract information from the found document
        String? foundTitle = (foundDoc.data() as Map<String, dynamic>?)?['itemTitle'];
        String? foundName = (foundDoc.data() as Map<String, dynamic>?)?['itemName'];
        String? secondCateg = (foundDoc.data() as Map<String, dynamic>?)?['category'];

        // Check if the titles of the lost and found items match
        if (lostTitle == foundTitle && lostName == foundName && lostCateg == secondCateg)
        {
          // Found a match, you can take further action here
          if (kDebugMode) {
            print(
              'Match found! Lost item title: $lostTitle, Found item title: $foundTitle');
          }
        }
      }
    }
  }
  catch (error)
  {
    print('Error searching for lost items: $error');
  }
}

// void main() {
//
//   searchLostItemsForCurrentUser();
// }
