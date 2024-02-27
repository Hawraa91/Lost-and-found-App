import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Form Validation Demo';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const LostItemForm(),
      ),
    );
  }
}

class LostItemForm extends StatefulWidget {
  const LostItemForm({Key? key}) : super(key: key);

  @override
  LostItemFormState createState() {
    return LostItemFormState();
  }
}

class LostItemFormState extends State<LostItemForm> {
  final _formKey = GlobalKey<FormState>();
  String itemName = '';
  String date = '';
  String category = '';
  String title = '';
  String description = '';
  File? image;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  itemName = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Item Name',
              ),
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  date = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Date',
              ),
            ),
            DropdownButtonFormField(
              value: category,
              onChanged: (value) {
                setState(() {
                  category = value.toString();
                });
              },
              items: [
                DropdownMenuItem(
                  child: Text('Category 1'),
                  value: 'Category 1',
                ),
                DropdownMenuItem(
                  child: Text('Category 2'),
                  value: 'Category 2',
                ),
                // Add more categories as needed
              ],
              decoration: InputDecoration(
                labelText: 'Category',
              ),
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  title = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  description = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final pickedFile =
                await _picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    image = File(pickedFile.path);
                  });
                }
              },
              child: Text('Upload Image'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                    // Add code to handle form submission and image upload
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}