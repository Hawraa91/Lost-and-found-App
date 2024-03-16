import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../components/bottomNavBar.dart';
import 'founditem.dart';

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
  bool isPublic = true;
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

  //TODO: add the public or private reports
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      //takes the current user's ID
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        Map<String, dynamic> data = {
          'userId': userId,
          'itemTitle': _itemTitleController.text,
          'itemName': _itemNameController.text,
          'itemLostDate': _itemLostDateController.text,
          'category': _categoryController.text,
          'description': _descriptionController.text,
          'isPublic': isPublic, // Add the isPublic field
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
          _imageFile = null;
          setState(() {
            isPublic = true; // Reset the radio button to default value after submission
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
            Row(
              children: [
                Radio(
                  value: true,
                  groupValue: isPublic,
                  onChanged: (value) {
                    setState(() {
                      isPublic = value as bool;
                    });
                  },
                ),
                const Text('Public'),
                Radio(
                  value: false,
                  groupValue: isPublic,
                  onChanged: (value) {
                    setState(() {
                      isPublic = value as bool;
                    });
                  },
                ),
                const Text('Private'),
              ],
            ),
            Container(
              width: double.infinity,
              child: ToggleButton(),
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
        controller: _itemLostDateController,
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
          hintText: 'Select $label', // Add the hintText here
          border: OutlineInputBorder(),
        ),
        value: controller.text.isNotEmpty ? controller.text : null, // Change default value to null
        onChanged: (String? value) {
          setState(() {
            controller.text = value ?? ''; // Use null-aware operator to handle null value
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

  //TODO: we want to add the searchLostItemsForCurrentUser function
  //i want to see if the reported item is in the found collection
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

class ToggleButton extends StatefulWidget {
  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

const double width = 300.0;
const double height = 60.0;
const double loginAlign = -1;
const double signInAlign = 1;
final Color selectedColor = const Color.fromRGBO(96, 172, 182, 1.0);
final Color normalColor = Colors.black54;

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
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(
          Radius.circular(50.0),
        ),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: Alignment(xAlign, 0),
            duration: Duration(milliseconds: 300),
            child: Container(
              width: width * 0.5,
              height: height,
              decoration: BoxDecoration(
                color: selectedColor, // Change background color here
                borderRadius: BorderRadius.all(
                  Radius.circular(50.0),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FoundItem()),
              );
            },
            child: Align(
              alignment: Alignment(-1, 0),
              child: Container(
                width: width * 0.5,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: const Text(
                  'Lost',
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FoundItem()),
              );
            },
            child: Align(
              alignment: Alignment(1, 0),
              child: Container(
                width: width * 0.5,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  'Found',
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
