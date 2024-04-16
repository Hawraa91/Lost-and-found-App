import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final TextEditingController _locationController = TextEditingController(); // Location controller

  XFile? _imageFile;

  final ImagePicker _picker = ImagePicker();

  void _selectLocationOnMap() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(37.77483, -122.41942), // Default location (San Francisco)
              zoom: 12,
            ),
            onTap: (LatLng latLng) {
              setState(() {
                _locationController.text = '${latLng.latitude}, ${latLng.longitude}';
              });
              Navigator.pop(context); // Close the modal bottom sheet
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
    _locationController.dispose(); // Dispose location controller
    super.dispose();
  }

  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _imageFile = pickedFile;
      }
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Form submitted successfully'),
        ),
      );

      // Clear form fields and image file
      _itemTitleController.clear();
      _itemNameController.clear();
      _itemFoundDateController.clear();
      _categoryController.clear();
      _descriptionController.clear();
      _locationController.clear();
      _imageFile = null;
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
                      readOnly: true, // Make the field read-only
                      decoration: InputDecoration(
                        labelText: 'Location Found',
                        hintText: 'Tap to select location',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.map),
                          onPressed: _selectLocationOnMap, // Show map when icon is pressed
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
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.image_outlined),
                    onPressed: _getImage,
                  ),
                  Text(_imageFile?.path ?? 'No image selected'),
                ],
              ),
              const SizedBox(height: 10),
              _buildButton('Submit', _submitForm),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
      resizeToAvoidBottomInset: false, // Prevent keyboard from resizing the screen
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
