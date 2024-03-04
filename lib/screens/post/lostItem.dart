import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/bottomNavBar.dart';

void main() {
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
  XFile? _imageFile;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _itemTitleController.dispose();
    _itemNameController.dispose();
    _itemLostDateController.dispose();
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
        title: const Text('Lost and Found Form'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextFormField('Item Title', _itemTitleController),
              _buildTextFormField('Item Name', _itemNameController),
              _buildDateTimePickerFormField('Item Lost Date'),
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle form submission with image upload
                    // ...
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Form submitted successfully'),
                      ),
                    );
                    // Clear form fields and image selection
                    _itemTitleController.clear();
                    _itemNameController.clear();
                    _itemLostDateController.clear();
                    _categoryController.clear();
                    _descriptionController.clear();
                    _imageFile = null;
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

  Widget _buildTextFormField(String label, TextEditingController controller) {
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
}
