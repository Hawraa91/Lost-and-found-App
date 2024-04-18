import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../components/bottomNavBar.dart';
import 'lostItem.dart';

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

  void _selectLocationOnMap() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(37.77483, -122.41942),
              zoom: 12,
            ),
            onTap: (LatLng latLng) {
              setState(() {
                _locationController.text = '${latLng.latitude}, ${latLng.longitude}';
              });
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

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
              _buildCategoryDropdown('Category', _categoryController),
              _buildInputField('Description', _descriptionController),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _locationController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Location Found',
                        hintText: 'Tap to select location',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.map),
                          onPressed: _selectLocationOnMap,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a location';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
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

  Widget _buildCategoryDropdown(String label, TextEditingController controller) {
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
        items: <String>['devices', 'jewels', 'keys', 'personal document', 'others']
            .map<DropdownMenuItem<String>>((String value) {
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
        width: 200,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(96, 172, 182, 1.0),
          borderRadius: BorderRadius.circular(8.0),
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
}
