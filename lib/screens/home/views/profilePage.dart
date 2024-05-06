import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lost_and_found/screens/login&signup/model/editProfile.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../../components/bottomNavBar.dart';
import '../../login&signup/model/setting.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String imageUrl = '';
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _phoneNumber;
  String? _address;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data();
        setState(() {
          _firstName = data?['firstName'];
          _lastName = data?['lastName'];
          _email = data?['email'];
          _phoneNumber = data?['phoneNumber'];
          _address = data?['address'];
          _imageUrl = data?['imageUrl'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          //Show image
          Container(
            height: 120, // Adjust the height as per your requirement
            width: 120, // Adjust the width as per your requirement
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black, // You can change the border color if needed
                width: 2, // You can adjust the border width if needed
              ),
            ),
            child: ClipOval(
              child: _imageUrl != null
                  ? Image.network(
                _imageUrl!,
                fit: BoxFit.cover,
              )
                  : const Icon(
                Icons.person, // Placeholder icon in case image URL is null
                size: 60, // Size of the placeholder icon
                color: Colors.grey, // Color of the placeholder icon
              ),
            ),
          ),
          //Uploading image
        IconButton(onPressed: () async {

          /* Step 1. Pick an image */
          ImagePicker imagePicker = ImagePicker();
          XFile? file = await imagePicker.pickImage(
              source: ImageSource.gallery);
          if (kDebugMode) {
            print('path is ${file?.path}');
          }

          if (file == null) return;

          String uniqueFileName = DateTime
              .now()
              .microsecondsSinceEpoch
              .toString();

          /* Step 2. Upload the image to Firebase Storage*/
          //Get a reference  to storage root
          Reference referenceRoot = FirebaseStorage.instance.ref();
          Reference referenceDirImages = referenceRoot.child('images');

          //Create a reference for the image to be stored
          Reference referenceImageToUpload = referenceDirImages.child(
              uniqueFileName);

          //Handle errors/success
          try {
            //Store the file
            await referenceImageToUpload.putFile(File(file!.path));
            //Success: get the download URL
            imageUrl = await referenceImageToUpload.getDownloadURL();

            //Adding the imageUrl in database for the current logged in user
            String? userId = FirebaseAuth.instance.currentUser?.uid;
            if (userId != null) {
              CollectionReference users = FirebaseFirestore.instance.collection(
                  'users');
              await users.doc(userId).update({'imageUrl': imageUrl});
            }
          }
          catch (error) {
            //Some error occurred
            if (kDebugMode) {
              print('Error uploading image: $error');
            }
          }
        }
        , icon: const Icon(Icons.camera_alt)),


          const SizedBox(height: 20),
          Text(
            '${_firstName ?? ''} ${_lastName ?? ''}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _email ?? 'superAdmin@codingwitht.com',
            style: const TextStyle(
              fontSize: 18, // Increase the font size of the email
            ),
          ),
          const SizedBox(height: 40),
          Container(
            width: 200,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(96, 172, 182, 1.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfilePage()),
                );
              },
              child: const Text(
                'Edit Profile',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListTile(
                        leading: const Icon(Icons.settings),
                        title: const Text('Settings'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SettingsPage()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListTile(
                        leading: const Icon(Icons.phone),
                        title: Text(_phoneNumber ?? 'Phone Number'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListTile(
                        leading: const Icon(Icons.people),
                        title: Text(_address ?? 'Address'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListTile(
                        leading: const Icon(Icons.info),
                        title: const Text('Information'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.pushReplacementNamed(context, '/');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
