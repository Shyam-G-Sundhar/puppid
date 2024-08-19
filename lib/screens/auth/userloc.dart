import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:puppid/screens/auth/dogform.dart';

Future<void> showMapPickerDialog(
    BuildContext context, Function(LatLng) onLocationSelected) async {
  final Location location = Location();
  LocationData? userLocation;
  LatLng? selectedLocation;
  bool isLoading = true;

  try {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return; // User did not enable location services
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return; // User did not grant location permissions
      }
    }

    userLocation = await location.getLocation();
  } catch (e) {
    print('Could not get location: $e');
  }

  isLoading = false;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Select Location'),
        content: SizedBox(
          height: 400,
          width: double.maxFinite,
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: userLocation != null
                      ? LatLng(
                          userLocation!.latitude!, userLocation!.longitude!)
                      : LatLng(0, 0),
                  zoom: 15,
                ),
                onMapCreated: (controller) {},
                onTap: (location) {
                  selectedLocation = location;
                  onLocationSelected(selectedLocation!);
                  (context as Element).reassemble();
                },
                markers: selectedLocation != null
                    ? {
                        Marker(
                          markerId: MarkerId('selected-location'),
                          position: selectedLocation!,
                        ),
                      }
                    : {},
              ),
              if (isLoading)
                Center(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                ),
              Positioned(
                bottom: 10,
                left: 10,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedLocation != null) {
                      onLocationSelected(selectedLocation!);
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please select a location')),
                      );
                    }
                  },
                  child: Text('Select'),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: ElevatedButton(
                  onPressed: () {
                    if (userLocation != null) {
                      selectedLocation = LatLng(
                          userLocation!.latitude!, userLocation!.longitude!);
                      onLocationSelected(selectedLocation!);
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Current location not available')),
                      );
                    }
                  },
                  child: Text('Use Current Location'),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );
}

class UserLocation extends StatefulWidget {
  final String uid;
  UserLocation({required this.uid});

  @override
  State<UserLocation> createState() => _UserLocationState();
}

class _UserLocationState extends State<UserLocation> {
  File? _selectedImage;
  final _formKey = GlobalKey<FormState>();
  final _homeController = TextEditingController();
  final _streetController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _districtController = TextEditingController();
  final _pinCodeController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  bool _isLoading = false;
  late String _userUid;
  LatLng? _selectedLocation;
  final Completer<GoogleMapController> _mapController = Completer();

  @override
  void initState() {
    super.initState();
    _userUid = widget.uid;
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _storeData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(_userUid)
          .collection('Caretaker')
          .doc(_userUid);

      String address = _homeController.text +
          ',' +
          _streetController.text +
          ',' +
          _landmarkController.text +
          ',' +
          _districtController.text +
          ',' +
          _pinCodeController.text +
          ',' +
          _stateController.text +
          ',' +
          _countryController.text +
          '.';

      await userRef.set(
        {
          'address': address,
          'location': _selectedLocation != null
              ? GeoPoint(
                  _selectedLocation!.latitude, _selectedLocation!.longitude)
              : null,
        },
        SetOptions(merge: true),
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DogFormPage(
            uid: _userUid,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save data: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _openMapPicker() async {
    await showMapPickerDialog(context, (location) {
      setState(() {
        _selectedLocation = location;
      });
      _updateMapLocation();
    });
  }

  Future<void> _updateMapLocation() async {
    if (_selectedLocation != null && _mapController.isCompleted) {
      final controller = await _mapController.future;
      controller.animateCamera(
        CameraUpdate.newLatLng(_selectedLocation!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User Profile",
          style: GoogleFonts.robotoFlex(
            fontSize: 20.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Icon(
          Icons.person,
          color: Colors.white,
        ),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: Colors.white),
            onPressed: _storeData,
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    SizedBox(height: 5),
                    GestureDetector(
                      onTap: _openMapPicker,
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Color(0xffE2EBE3),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.green, width: 1.5),
                        ),
                        child: _selectedLocation == null
                            ? Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Map',
                                        style: GoogleFonts.robotoFlex(
                                            fontSize: 20)),
                                    SizedBox(width: 5),
                                    Icon(Icons.my_location,
                                        color: Colors.green),
                                  ],
                                ),
                              )
                            : GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: _selectedLocation!,
                                  zoom: 15,
                                ),
                                markers: {
                                  Marker(
                                    markerId: MarkerId('selected-location'),
                                    position: _selectedLocation!,
                                  ),
                                },
                                onMapCreated: (controller) {
                                  _mapController.complete(controller);
                                },
                              ),
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildTextField(Icons.home, 'Door no.', _homeController),
                    SizedBox(height: 10),
                    _buildTextField(Icons.apartment, 'Street Name, Area Name',
                        _streetController),
                    SizedBox(height: 10),
                    _buildTextField(
                        Icons.landscape, 'Landmark', _landmarkController),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                            child: _buildTextField(Icons.location_city,
                                'District', _districtController)),
                        SizedBox(width: 10),
                        Expanded(
                            child: _buildTextField(Icons.location_on, 'Pincode',
                                _pinCodeController)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                            child: _buildTextField(
                                Icons.map, 'State', _stateController)),
                        SizedBox(width: 10),
                        Expanded(
                            child: _buildTextField(
                                Icons.map, 'Country', _countryController)),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    IconData icon,
    String labelText,
    TextEditingController controller,
  ) {
    return TextFormField(
      controller: controller,
      style: GoogleFonts.robotoFlex(fontSize: 15.sp),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.robotoFlex(fontSize: 15.sp),
        prefixIcon: Icon(icon, color: Colors.green),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green, width: 1.5),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }
}
