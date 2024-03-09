import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../components/bottomNavBar.dart';

void main() {
  runApp(const MaterialApp(
    home: FoundItem(),
  ));
}

class FoundItem extends StatefulWidget {
  const FoundItem({Key? key}) : super(key: key);

  @override
  _FoundItemState createState() => _FoundItemState();
}

class _FoundItemState extends State<FoundItem> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _itemTitleController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemFoundDateController =
  TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  XFile? _imageFile;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _itemTitleController.dispose();
    _itemNameController.dispose();
    _itemFoundDateController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
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
              _buildTextFormField('Item Title', _itemTitleController),
              _buildTextFormField('Item Name', _itemNameController),
              _buildDateTimePickerFormField('Item Found Date'),
              _buildTextFormField('Category', _categoryController),
              _buildTextFormField('Description', _descriptionController),
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
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save(); // Save form data
                    try {
                      await FirebaseFirestore.instance.collection('found').add({
                        'itemTitle': _itemTitleController.text,
                        'itemName': _itemNameController.text,
                        'itemFoundDate': _itemFoundDateController.text,
                        'category': _categoryController.text,
                        'description': _descriptionController.text,
                        // Add more fields as needed
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Form submitted successfully'),
                        ),
                      );
                      // Clear form fields and image selection
                      _itemTitleController.clear();
                      _itemNameController.clear();
                      _itemFoundDateController.clear();
                      _categoryController.clear();
                      _descriptionController.clear();
                      _imageFile = null;
                    } catch (e) {
                      print('Error saving form data: $e');
                    }
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildTextFormField(
      String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Enter $label',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        onSaved: (value) {
          controller.text = value!;
        },
      ),
    );
  }

  Widget _buildDateTimePickerFormField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () {
          DatePicker.showDatePicker(
            context,
            showTitleActions: true,
            minTime: DateTime(2000, 1, 1),
            maxTime: DateTime(2100, 12, 31),
            onConfirm: (date) {
              setState(() {
                _itemFoundDateController.text = date.toString();
              });
            },
            currentTime: DateTime.now(),
            locale: LocaleType.en,
          );
        },
        child: AbsorbPointer(
          child: TextFormField(
            controller: _itemFoundDateController,
            decoration: InputDecoration(
              labelText: label,
              hintText: 'Select $label',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select $label';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}

