import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
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

  Widget _buildDateTimePickerFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: TextEditingController(text: _selectedDate.toString()),
        decoration: InputDecoration(
          labelText: 'Date',
          border: OutlineInputBorder(),
        ),
        readOnly: true,
        onTap: () => _selectDate(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Report'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInputField('Title', _titleController),
            _buildInputField('Description', _descriptionController),
            _buildInputField('Category', _categoryController),
            _buildDateTimePickerFormField(),
            ElevatedButton(
              onPressed: _updateReport,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(46, 61, 95, 1.0), // Dark blue color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                minimumSize: Size(double.infinity, 50), // Set the height to 50
              ),
              child: const Text('Update Report', style: TextStyle(color: Colors.white)),
            ),


          ],
        ),
      ),
    );
  }
}
