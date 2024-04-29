import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditReportPage extends StatefulWidget {
  final String documentId;
  final String collectionName;
  final String initialTitle;
  final String initialDescription;
  final String initialCategory;
  final DateTime initialDate;

  const EditReportPage({
    Key? key,
    required this.documentId,
    required this.collectionName,
    required this.initialTitle,
    required this.initialDescription,
    required this.initialCategory,
    required this.initialDate,
  }) : super(key: key);

  @override
  _EditReportPageState createState() => _EditReportPageState();
}

class _EditReportPageState extends State<EditReportPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _descriptionController = TextEditingController(text: widget.initialDescription);
    _categoryController = TextEditingController(text: widget.initialCategory);
    _selectedDate = widget.initialDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _updateReport() async {
    final String title = _titleController.text.trim();
    final String description = _descriptionController.text.trim();
    final String category = _categoryController.text.trim();

    if (title.isNotEmpty && description.isNotEmpty && category.isNotEmpty) {
      final DocumentReference docRef = FirebaseFirestore.instance
          .collection(widget.collectionName)
          .doc(widget.documentId);

      await docRef.update({
        'itemTitle': title,
        'description': description,
        'category': category,
        'itemLostDate': _selectedDate.toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Report updated successfully'),
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter all fields'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Category',
              ),
            ),
            const SizedBox(height: 16.0),
            ListTile(
              title: Text(
                  'Date: ${_selectedDate.toString().split(' ')[0]}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _updateReport,
              child: const Text('Update Report'),
            ),
          ],
        ),
      ),
    );
  }
}