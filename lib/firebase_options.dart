// File: firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

const firebaseOptions = FirebaseOptions(
  apiKey: "<your-apikey>",
  appId: "<your-appId>",
  messagingSenderId: "<your-messagingId>",
  projectId: "<your-projectId>",
  storageBucket: "<your-storage-bucket>",
);

//all of these could be found in your firebase console