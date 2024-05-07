import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../components/bottomNavBar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    home: LostItem(),
  ));
}

class LostItem extends StatefulWidget {
  const LostItem({Key? key}) : super(key: key);

  @override
  _LostItemState createState() => _LostItemState();
}

class _LostItemState extends State<LostItem> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _itemTitleController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemLostDateController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationFoundController =
  TextEditingController(); // Location found controller
  bool isPublic = true; // Hold the toggle state
  String imageUrl = '';

  @override
  void dispose() {
    _itemTitleController.dispose();
    _itemNameController.dispose();
    _itemLostDateController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _locationFoundController.dispose(); // Dispose location found controller
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        Map<String, dynamic> data = {
          'userId': userId,
          'itemTitle': _itemTitleController.text,
          'itemName': _itemNameController.text,
          'itemLostDate': Timestamp.fromDate(DateTime.parse(
              _itemLostDateController.text)), // Convert String to Timestamp
          'category': _categoryController.text,
          'description': _descriptionController.text,
          'locationFound': _locationFoundController.text,
          'isPublic': isPublic,
          'isResolved': false,
          'imageUrl': imageUrl,
        };

        try {
          await FirebaseFirestore.instance.collection('lost').add(data);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Form submitted successfully'),
            ),
          );
          _itemTitleController.clear();
          _itemNameController.clear();
          _itemLostDateController.clear();
          _categoryController.clear();
          _descriptionController.clear();
          _locationFoundController.clear();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to submit form. Please try again later.'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not authenticated. Please log in.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lost and Found Form'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: CheckBoxWidget(
                onCheckedChanged: (value) {
                  setState(() {
                    isPublic = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildInputField('Item Title', _itemTitleController),
                  _buildInputField('Item Name', _itemNameController),
                  _buildDateTimePickerFormField('Item Lost Date'),
                  _buildCategoryDropdown('Category', _categoryController),
                  _buildInputField('Description', _descriptionController),
                  _buildInputField('Location Found', _locationFoundController),
                  //Uploading image
                  IconButton(onPressed: () async {
                    /* Step 1. Pick an image */
                    ImagePicker imagePicker = ImagePicker();
                    XFile? file = await imagePicker.pickImage(
                        source: ImageSource.camera);
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
                    Reference referenceDirImages = referenceRoot.child('lostItemsImages');

                    //Create a reference for the image to be stored
                    Reference referenceImageToUpload = referenceDirImages.child(
                        uniqueFileName);

                    //Handle errors/success
                    try {
                      //Store the file
                      await referenceImageToUpload.putFile(File(file!.path));
                      //Success: get the download URL
                      imageUrl = await referenceImageToUpload.getDownloadURL();

                      if (kDebugMode) {
                        print(imageUrl);
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
                  const SizedBox(height: 10),
                  _buildButton('Submit', _submitForm),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Enter $label',
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDateTimePickerFormField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: _itemLostDateController,
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Select $label',
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setState(() {
                  _itemLostDateController.text = picked.toString();
                });
              }
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCategoryDropdown(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('categories').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          List categories = snapshot.data!.docs.map((doc) => doc['name']).toList();
          categories.addAll(['Devices', 'Wallet', 'Keys', 'Jewels', 'Others']);
          return DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: label,
              hintText: 'Select $label',
              border: const OutlineInputBorder(),
            ),
            value: controller.text.isNotEmpty ? controller.text : null,
            onChanged: (String? value) {
              setState(() {
                controller.text = value ?? '';
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select $label';
              }
              return null;
            },
            items: categories.map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          );
        },
      ),
    );
  }


  Widget _buildButton(String label, Function() onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: 350,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(46, 61, 95, 1.0), // Dark blue color
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class CheckBoxWidget extends StatefulWidget {
  final Function(bool) onCheckedChanged;

  const CheckBoxWidget({required this.onCheckedChanged, Key? key}) : super(key: key);

  @override
  _CheckBoxWidgetState createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Make your post public?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Checkbox(
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value ?? false;
            });
            widget.onCheckedChanged(isChecked);
          },
        ),
      ],
    );
  }
}
