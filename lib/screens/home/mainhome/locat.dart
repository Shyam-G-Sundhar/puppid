import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationSelectionPage extends StatefulWidget {
  @override
  _LocationSelectionPageState createState() => _LocationSelectionPageState();
}

class _LocationSelectionPageState extends State<LocationSelectionPage> {
  final TextEditingController _searchController = TextEditingController();

  List<String> allLocations = [
    "New York,USA",
    "Los Angeles,USA",
    "Chicago,USA",
    "Houston,USA",
    "Phoenix,USA",
    "Philadelphia,USA",
    "San Antonio,USA",
    "San Diego,USA",
    "Dallas,USA",
    "San Jose,USA"
  ];
  String _address = '  ,Locating';
  List<String> filteredNearbyLocations = [];
  List<String> filteredAllLocations = [];
  List<Map<String, dynamic>> locationsWithDistance = [];
  Position? _userPosition;
  Future<void> _getUserLocationAndAddress() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled, return an appropriate message
        setState(() {
          _address = 'Location services are disabled.';
        });
        return;
      }

      // Check location permission status
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, return an appropriate message
          setState(() {
            _address = 'Permissions,Denied';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle accordingly
        setState(() {
          _address = 'permissions,permanently denied.';
        });
        return;
      }

      // If everything is granted, get the current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Convert the coordinates into an address
      String address = await getAddressFromCoordinates(position);
      setState(() {
        _address = address;
      });
    } catch (e) {
      // Handle any errors that might occur
      setState(() {
        _address = 'Try Again, ';
      });
    }
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      await Permission.locationWhenInUse.request();
    }
  }

  Future<Position> getUserLocation() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<String> getAddressFromCoordinates(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    return "${place.locality}, ${place.administrativeArea}";
  }

  @override
  void initState() {
    super.initState();
    _fetchUserLocation();
  }

  Future<void> _fetchUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _userPosition = position;
      });
      _filterLocations();
    } catch (e) {
      setState(() {
        filteredNearbyLocations = [];
        locationsWithDistance = [];
      });
    }
  }

  void _filterLocations([String query = ""]) {
    if (_userPosition == null) return;

    Map<String, LatLng> locationCoordinates = {
      "New York,USA": LatLng(40.7128, -74.0060),
      "Los Angeles,USA": LatLng(34.0522, -118.2437),
      "Chicago,USA": LatLng(41.8781, -87.6298),
      "Houston,USA": LatLng(29.7604, -95.3698),
      "Phoenix,USA": LatLng(33.4484, -112.0740),
      "Philadelphia,USA": LatLng(39.9526, -75.1652),
      "San Antonio,USA": LatLng(29.4241, -98.4936),
      "San Diego,USA": LatLng(32.7157, -117.1611),
      "Dallas,USA": LatLng(32.7767, -96.7970),
      "San Jose,USA": LatLng(37.3382, -121.8863),
    };

    List<Map<String, dynamic>> tempList = [];
    for (var location in allLocations) {
      LatLng coords = locationCoordinates[location]!;
      double distance = Geolocator.distanceBetween(
        _userPosition!.latitude,
        _userPosition!.longitude,
        coords.latitude,
        coords.longitude,
      );

      tempList.add({'location': location, 'distance': distance});
    }

    tempList.sort((a, b) => a['distance'].compareTo(b['distance']));

    List<String> nearbyFiltered = tempList
        .where((item) =>
            item['location'].toLowerCase().contains(query.toLowerCase()))
        .map((item) => item['location'] as String)
        .toList()
        .take(4)
        .toList();

    setState(() {
      locationsWithDistance = tempList;
      filteredNearbyLocations = nearbyFiltered;
      filteredAllLocations = allLocations
          .where((loc) =>
              loc.toLowerCase().contains(query.toLowerCase()) &&
              !nearbyFiltered.contains(loc))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: TextField(
          controller: _searchController,
          onChanged: (value) {
            _filterLocations(value);
          },
          decoration: InputDecoration(
            hintText: 'Search for your city, area, or locality...',
            hintStyle: GoogleFonts.robotoFlex(color: Colors.grey.shade600),
            prefixIcon: Icon(Icons.search, color: Colors.black54),
            filled: true,
            fillColor: Colors.grey.shade200,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
          style: TextStyle(color: Colors.black87),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.my_location, color: Colors.black54),
            onPressed: () async {
              await _getUserLocationAndAddress();
              Navigator.of(context).pop(_address);
            },
          ),
        ],
      ),
      body: _userPosition == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.height * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Nearby Locations'),
                  SizedBox(height: 10),
                  Expanded(
                      child: _buildLocationList(filteredNearbyLocations, true)),
                  SizedBox(height: 20),
                  _buildSectionTitle('All Locations'),
                  SizedBox(height: 10),
                  Expanded(
                      child: _buildLocationList(filteredAllLocations, false)),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.robotoFlex(
        fontWeight: FontWeight.bold,
        fontSize: MediaQuery.of(context).size.width * 0.05,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildLocationList(List<String> locations, bool isNearby) {
    return ListView.builder(
      itemCount: locations.length,
      itemBuilder: (context, index) {
        String location = locations[index];
        double? distance = isNearby
            ? locationsWithDistance
                .firstWhere((loc) => loc['location'] == location)['distance']
                .toDouble()
            : null;
        return ListTile(
          title: Text(
            location,
            style: GoogleFonts.robotoFlex(fontSize: 16, color: Colors.black87),
          ),
          subtitle: isNearby
              ? Text('${distance!.toStringAsFixed(2)} km away',
                  style: TextStyle(color: Colors.grey.shade600))
              : null,
          onTap: () {
            Navigator.of(context).pop(location);
          },
        );
      },
    );
  }
}

class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);
}
