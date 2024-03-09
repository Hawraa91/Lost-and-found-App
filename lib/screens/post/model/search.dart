// import 'package:cloud_firestore/cloud_firestore.dart';
//
// /*
// *********** Lost Report ***********
// step 1 : retrieve the data from the documents in found collection
// step 2: check if the lost item is in the lost collection
//         - if yes, provide the probable match
//           * contact with the user who found it (create a chat between them) (do that for the founder as well)
//         - if not, print a message saying no match found yet, and add it in the lost collection
// */
//
// void fetchDataAndCompare() async {
//   // Fetch documents from the lost collection
//   QuerySnapshot firstCollectionSnapshot =
//   await FirebaseFirestore.instance.collection('lost').get();
//
//   // Fetch documents from the found collection
//   QuerySnapshot secondCollectionSnapshot =
//   await FirebaseFirestore.instance.collection('found').get();
//
//   // Compare documents from both collections
//   firstCollectionSnapshot.docs.forEach((firstDoc) {
//     secondCollectionSnapshot.docs.forEach((secondDoc) {
//       // Compare documents based on your criteria (e.g., title, description)
//       if (areDocumentsSimilar(firstDoc, secondDoc)) {
//         // Documents are similar, take action or display them
//         print('Similar documents found:');
//         print('First document: ${firstDoc.data()}');
//         print('Second document: ${secondDoc.data()}');
//       }
//     });
//   });
// }
//
// bool areDocumentsSimilar(DocumentSnapshot firstDoc, DocumentSnapshot secondDoc) {
//   // Implement your comparison logic here
//   // For example, compare titles or descriptions
//   String firstTitle = firstDoc.data()['title'];
//   String secondTitle = secondDoc.data()['title'];
//
//   // Perform string comparison or other matching techniques
//   // Return true if the documents are similar, false otherwise
//   return firstTitle == secondTitle;
// }
//
// void main() {
//   fetchDataAndCompare();
// }
