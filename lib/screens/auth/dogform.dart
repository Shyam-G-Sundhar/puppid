import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:puppid/screens/auth/dogphoto.dart';

class DogFormPage extends StatefulWidget {
  final String uid;
  DogFormPage({required this.uid});

  @override
  _DogFormPageState createState() => _DogFormPageState();
}

class _DogFormPageState extends State<DogFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();

  String _selectedAge = 'Age';
  String _selectedGender = 'Gender';
  String _selectedColor = 'Select Color';
  String _selectedBreed = 'Select Breed';
  String _selectedVaccinationStatus = 'Select Vaccination Status';
  String _selectedHealthStatus = 'Select Health Status';
  String _selectedBehavior = 'Select Behavior';

  File? _selectedImage;
  File? _selectedDocument;
  Color? _pickedColor;
  double _uploadProgress = 0.0;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      // Simulate upload progress
      for (int i = 0; i <= 100; i++) {
        await Future.delayed(Duration(milliseconds: 50));
        setState(() {
          _uploadProgress = i / 100;
        });
      }
      setState(() {
        _selectedDocument = file;
      });
    }
  }

  List<String> ageOptions = [
    'Age',
    '4 Mon',
    '5 Mon',
    '6 Mon',
    '7 Mon',
    '8 Mon',
    '9 Mon',
    '10 Mon',
    '11 Mon',
    '1 Yr',
    '1 Yr 6 Mon',
    '2 Yrs',
    '2 Yrs 6 Mon',
    '3 Yrs',
    '3 Yrs 6 Mon',
    '4 Yrs',
    '4 Yrs 6 Mon',
    '5 Yrs',
    '5 Yrs 6 Mon',
    '6 Yrs',
    '6 Yrs 6 Mon',
    '7 Yrs',
    '7 Yrs 6 Mon',
    '8 Yrs',
    '8 Yrs 6 Mon',
    '9 Yrs',
    '9 Yrs 6 Mon',
    '10 Yrs',
    '10 Yrs 6 Mon',
    '11 Yrs',
    '11 Yrs 6 Mon',
    '12 Yrs',
    '12 Yrs 6 Mon',
    '13 Yrs',
    '13 Yrs 6 Mon',
    '14 Yrs',
    '14 Yrs 6 Mon',
    '15 Yrs'
  ];

  Future<void> _pickColor() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _pickedColor ?? Colors.black,
              onColorChanged: (color) {
                setState(() {
                  _pickedColor = color;
                });
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Select'),
              onPressed: () {
                setState(() {
                  _selectedColor = 'Other';
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        User? user = FirebaseAuth.instance.currentUser;
        String uid = user!.uid;

        // Convert color to hex code
        String colorHexCode;
        if (_selectedColor == 'Black') {
          colorHexCode = '000000'; // Black
        } else if (_selectedColor == 'White') {
          colorHexCode = 'FFFFFF'; // White
        } else if (_selectedColor == 'Brown') {
          colorHexCode = 'A52A2A'; // Brown
        } else if (_selectedColor == 'Other' && _pickedColor != null) {
          colorHexCode = _pickedColor!.value.toRadixString(16).padLeft(6, '0');
        } else {
          colorHexCode = '000000'; // Default to Black if no color is selected
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('Dog')
            .doc(uid)
            .set({
          'name': nameController.text,
          'age': _selectedAge,
          'gender': _selectedGender,
          'color': colorHexCode, // Store hex code
          'breed': _selectedBreed,
          'vaccination_status': _selectedVaccinationStatus,
          'document_path': _selectedDocument?.path ?? '',
          'health_status': _selectedHealthStatus,
          'behavior': _selectedBehavior,
          'about': aboutController.text,
          'image_path': _selectedImage?.path ?? '',
        });

        Navigator.of(context).pushReplacement(
            PageTransition(child: DogPhoto(), type: PageTransitionType.fade));
      } catch (e) {
        // Handle errors here
        print("Error saving data: $e");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        elevation: 0,
        title: Text(
          "Dog Profile",
          style: GoogleFonts.robotoFlex(
            fontSize: 20.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Image.asset('assets/whitepaw.png'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: IconButton(
              icon: Icon(Icons.check, color: Colors.white, size: 30),
              onPressed: _isLoading ? null : _saveData,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.green,
                              backgroundImage: _selectedImage != null
                                  ? FileImage(_selectedImage!)
                                  : null,
                              child: _selectedImage == null
                                  ? Icon(Icons.camera_alt,
                                      size: 50, color: Colors.white)
                                  : null,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            'Upload Photo',
                            style: GoogleFonts.robotoFlex(
                              fontSize: 16.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        _buildSectionTitle('Primary'),
                        _buildTextFieldWithIcon(
                          Icons.person,
                          'Name',
                          controller: nameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        _buildLabelText('Age'),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdownWithIcon(
                                Icons.calendar_today,
                                _selectedAge,
                                ageOptions,
                                (newValue) {
                                  setState(() {
                                    _selectedAge = newValue!;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: _buildDropdownWithIcon(
                                Icons.wc,
                                _selectedGender,
                                ['Gender', 'Male', 'Female'],
                                (newValue) {
                                  setState(() {
                                    _selectedGender = newValue!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        _buildDropdownWithIcon(
                          Icons.color_lens,
                          _selectedColor,
                          ['Select Color', 'Black', 'White', 'Brown', 'Other'],
                          (newValue) {
                            setState(() {
                              _selectedColor = newValue!;
                              if (_selectedColor == 'Other') {
                                _pickColor();
                              }
                            });
                          },
                        ),
                        _buildDropdownWithIcon(
                          Icons.pets,
                          _selectedBreed,
                          ['Select Breed', 'Labrador', 'Beagle', 'Bulldog'],
                          (newValue) {
                            setState(() {
                              _selectedBreed = newValue!;
                            });
                          },
                        ),
                        _buildDropdownWithIcon(
                          Icons.medical_services,
                          _selectedVaccinationStatus,
                          ['Select Vaccination Status', 'Completed', 'Pending'],
                          (newValue) {
                            setState(() {
                              _selectedVaccinationStatus = newValue!;
                            });
                          },
                        ),
                        _buildDropdownWithIcon(
                          Icons.health_and_safety,
                          _selectedHealthStatus,
                          ['Select Health Status', 'Healthy', 'Sick'],
                          (newValue) {
                            setState(() {
                              _selectedHealthStatus = newValue!;
                            });
                          },
                        ),
                        _buildDropdownWithIcon(
                          Icons.mood,
                          _selectedBehavior,
                          ['Select Behavior', 'Friendly', 'Aggressive'],
                          (newValue) {
                            setState(() {
                              _selectedBehavior = newValue!;
                            });
                          },
                        ),
                        SizedBox(height: 10),
                        _buildLabelText('About'),
                        _buildTextFieldWithIcon(
                          Icons.info,
                          'About',
                          controller: aboutController,
                        ),
                        SizedBox(height: 10),
                        _buildLabelText('Upload Document'),
                        ElevatedButton(
                          onPressed: _pickDocument,
                          child: Text('Upload Document'),
                        ),
                        if (_uploadProgress > 0)
                          LinearProgressIndicator(
                            value: _uploadProgress,
                          ),
                        SizedBox(height: 10),
                        if (_selectedDocument != null)
                          Text(
                              'Document Selected: ${_selectedDocument!.path.split('/').last}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildTextFieldWithIcon(IconData icon, String labelText,
      {TextEditingController? controller,
      String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.green),
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
      validator: validator,
    );
  }

  Widget _buildDropdownWithIcon(IconData icon, String value, List<String> items,
      void Function(String?)? onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.green),
        border: OutlineInputBorder(),
      ),
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildLabelText(String text) {
    return Text(
      text,
      style: GoogleFonts.robotoFlex(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: GoogleFonts.robotoFlex(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
