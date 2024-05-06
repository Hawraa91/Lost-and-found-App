import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../components/bottomNavBar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    home: FoundItem(),
  ));
}

class FoundItem extends StatefulWidget {
  const FoundItem({Key? key}) : super(key: key);

  @override
  _FoundItemPageState createState() => _FoundItemPageState();
}

class _FoundItemPageState extends State<FoundItem> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _itemTitleController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemFoundDateController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void dispose() {
    _itemTitleController.dispose();
    _itemNameController.dispose();
    _itemFoundDateController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          await FirebaseFirestore.instance.collection('found').add({
            'userId': user.uid,
            'itemTitle': _itemTitleController.text,
            'itemName': _itemNameController.text,
            'itemFoundDate': _itemFoundDateController.text,
            'category': _categoryController.text,
            'description': _descriptionController.text,
            'location': _locationController.text,
            'isResolved': false, // Add the 'isResolved' field with a default value of false
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Item details saved successfully'),
            ),
          );

          _itemTitleController.clear();
          _itemNameController.clear();
          _itemFoundDateController.clear();
          _categoryController.clear();
          _descriptionController.clear();
          _locationController.clear();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User not logged in'),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error saving item details'),
          ),
        );
      }
    }
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Enter $label',
          border: OutlineInputBorder(),
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
        controller: _itemFoundDateController,
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Select $label',
          border: OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setState(() {
                  _itemFoundDateController.text = picked.toString();
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

  Future<List<String>> _fetchCategories() async {
    List<String> categories = [];
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('categories').get();
    snapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> doc) {
      categories.add(doc.data()?['name']);
    });
    return categories;
  }

  Widget _buildCategoryDropdown(String label, TextEditingController controller, List<String> categories) {
    List<String> allCategories = [ 'Devices', 'Jewels', 'Keys', 'Wallet','Others'];
    allCategories.addAll(categories);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Select $label',
          border: OutlineInputBorder(),
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
        items: allCategories.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
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
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Found Item Form'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildInputField('Item Title', _itemTitleController),
              _buildInputField('Item Name', _itemNameController),
              _buildDateTimePickerFormField('Item Found Date'),
              FutureBuilder<List<String>>(
                future: _fetchCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error loading categories: ${snapshot.error}');
                  } else {
                    return _buildCategoryDropdown('Category', _categoryController, snapshot.data ?? []);
                  }
                },
              ),
              _buildInputField('Description', _descriptionController),
              _buildInputField('Location Found', _locationController),
              const SizedBox(height: 10),
              _buildButton('Submit', _submitForm),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
      resizeToAvoidBottomInset: false,
    );
  }
}
