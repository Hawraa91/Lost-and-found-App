import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Forms',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LostItemForm(),
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

  @override
  void dispose() {
    _itemTitleController.dispose();
    _itemNameController.dispose();
    _itemLostDateController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lost and Found Form'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _itemTitleController,
                decoration: InputDecoration(
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
              SizedBox(height: 10),
              TextFormField(
                controller: _itemNameController,
                decoration: InputDecoration(
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
              SizedBox(height: 10),
              TextFormField(
                controller: _itemLostDateController,
                decoration: InputDecoration(
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
              SizedBox(height: 10),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
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
              SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
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
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Form submitted successfully'),
                      ),
                    );
                    // Clear form fields
                    _itemTitleController.clear();
                    _itemNameController.clear();
                    _itemLostDateController.clear();
                    _categoryController.clear();
                    _descriptionController.clear();
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
