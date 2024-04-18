import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../components/bottomNavBar.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
  final TextEditingController _locationFoundController = TextEditingController(); // Location found controller
  bool isPublic = true;

  @override
  void dispose() {
    _itemTitleController.dispose();
    _itemNameController.dispose();
    _itemLostDateController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _locationFoundController.dispose(); // Dispose location found controller
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        Map<String, dynamic> data = {
          'userId': userId,
          'itemTitle': _itemTitleController.text,
          'itemName': _itemNameController.text,
          'itemLostDate': _itemLostDateController.text,
          'category': _categoryController.text,
          'description': _descriptionController.text,
          'locationFound': _locationFoundController.text, // Save location found
          'isPublic': isPublic,
        };

        try {
          await FirebaseFirestore.instance.collection('lost').add(data);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Form submitted successfully'),
            ),
          );
          _itemTitleController.clear();
          _itemNameController.clear();
          _itemLostDateController.clear();
          _categoryController.clear();
          _descriptionController.clear();
          _locationFoundController.clear(); // Clear location found
          setState(() {
            isPublic = true;
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to submit form. Please try again later.'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not authenticated. Please log in.'),
          ),
        );
      }
    }
  }

  void _selectLocationFoundOnMap() {
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
                _locationFoundController.text = '${latLng.latitude}, ${latLng.longitude}';
              });
              Navigator.pop(context); // Close the modal bottom sheet
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lost and Found Form'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: ToggleButton(
                onToggle: (value) {
                  setState(() {
                    isPublic = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildInputField('Item Title', _itemTitleController),
                  _buildInputField('Item Name', _itemNameController),
                  _buildDateTimePickerFormField('Item Lost Date'),
                  _buildCategoryDropdown('Category', _categoryController),
                  _buildInputField('Description', _descriptionController),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _locationFoundController,
                          readOnly: true, // Make the field read-only
                          decoration: InputDecoration(
                            labelText: 'Location Found',
                            hintText: 'Tap to select location',
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.map),
                              onPressed: _selectLocationFoundOnMap, // Show map when icon is pressed
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
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
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
          border: const OutlineInputBorder(),
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
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today),
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

  Widget _buildCategoryDropdown(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Select $label',
          border: const OutlineInputBorder(),
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
        items: <String>['Devices', 'Jewels', 'Keys', 'Personal document', 'Others']
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
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class ToggleButton extends StatefulWidget {
  final Function(bool) onToggle;

  const ToggleButton({required this.onToggle, Key? key}) : super(key: key);

  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

const double width = 300.0;
const double height = 60.0;
const double loginAlign = -1;
const double signInAlign = 1;
const Color selectedColor = Color.fromRGBO(96, 172, 182, 1.0);
const normalColor = Colors.black54;

class _ToggleButtonState extends State<ToggleButton> {
  late double xAlign;
  late Color loginColor;
  late Color signInColor;

  @override
  void initState() {
    super.initState();
    xAlign = loginAlign;
    loginColor = selectedColor;
    signInColor = normalColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(
          Radius.circular(50.0),
        ),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: Alignment(xAlign, 0),
            duration: const Duration(milliseconds: 300),
            child: Container(
              width: width * 0.5,
              height: height,
              decoration: BoxDecoration(
                color: selectedColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(50.0),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                xAlign = loginAlign;
                loginColor = selectedColor;
                signInColor = normalColor;
              });
              widget.onToggle(true); // Call callback with true for Public
            },
            child: Align(
              alignment: const Alignment(-1, 0),
              child: Container(
                width: width * 0.5,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: const Text(
                  'Private',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                xAlign = signInAlign;
                signInColor = selectedColor;
                loginColor = normalColor;
              });
              widget.onToggle(false); // Call callback with false for Private
            },
            child: Align(
              alignment: const Alignment(1, 0),
              child: Container(
                width: width * 0.5,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  'Public',
                  style: TextStyle(
                    color: signInColor == selectedColor ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
