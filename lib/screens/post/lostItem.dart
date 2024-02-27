import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/bottomNavBar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LostItemForm(),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class LostItemForm extends StatefulWidget {
  const LostItemForm({Key? key}) : super(key: key);

  @override
  State<LostItemForm> createState() => _LostItemFormState();
}

class _LostItemFormState extends State<LostItemForm> {
  final _formKey = GlobalKey<FormState>();
  final _itemTitleController = TextEditingController();
  final _itemNameController = TextEditingController();
  final _itemLostDateController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  XFile? _imageFile; // To store the selected image

  final ImagePicker _picker = ImagePicker(); // Image picker instance

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
              TextFormField(
                controller: _itemTitleController,
                decoration: const InputDecoration(
                  labelText: 'Item Title',
                  hintText: 'Enter item title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter item title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _itemNameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  hintText: 'Enter item name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter item name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _itemLostDateController,
                decoration: const InputDecoration(
                  labelText: 'Item Lost Date',
                  hintText: 'Enter item lost date',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter item lost date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  hintText: 'Enter category',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter description',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),


              const SizedBox(height: 10),

              // Image upload section
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

              // Submit button (after image upload)
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
    );
  }
}

