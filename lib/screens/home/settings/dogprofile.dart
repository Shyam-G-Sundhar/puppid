import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DogProfilePage extends StatefulWidget {
  @override
  _DogProfilePageState createState() => _DogProfilePageState();
}

class _DogProfilePageState extends State<DogProfilePage> {
  String _selectedAge = '0';
  String _selectedGender = 'Male';
  String _selectedColor = 'Black';
  String _selectedBreed = 'Breed';
  String _selectedVaccinationStatus = 'Vaccination Status';
  String _selectedHealthStatus = 'Health Status';
  String _selectedBehavior = 'Behavior';

  final List<String> colors = ['Black', 'White', 'Brown'];
  final List<Color> colorPalette = [Colors.black, Colors.white, Colors.brown];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(360, 690), minTextAdapt: true);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dog Profile',
          style: GoogleFonts.robotoFlex(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Primary'),
              _buildTextFieldWithIcon(Icons.person, 'Name'),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownWithIcon(
                      Icons.calendar_today,
                      _selectedAge,
                      List.generate(100, (index) => index.toString()),
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
                      ['Male', 'Female'],
                      (newValue) {
                        setState(() {
                          _selectedGender = newValue!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              _buildColorPickerWithIcon(
                Icons.color_lens,
                _selectedColor,
                colors,
                (newValue) {
                  setState(() {
                    _selectedColor = newValue!;
                  });
                },
              ),
              _buildDropdownWithIcon(
                Icons.pets,
                _selectedBreed,
                ['Breed', 'Labrador', 'Poodle', 'Bulldog', 'Beagle'],
                (newValue) {
                  setState(() {
                    _selectedBreed = newValue!;
                  });
                },
              ),
              _buildSectionTitle('Secondary'),
              _buildDropdownWithIcon(
                Icons.vaccines,
                _selectedVaccinationStatus,
                ['Vaccination Status', 'Completed'],
                (newValue) {
                  setState(() {
                    _selectedVaccinationStatus = newValue!;
                  });
                },
              ),
              _buildDropdownWithIcon(
                Icons.favorite,
                _selectedHealthStatus,
                ['Health Status', 'Good'],
                (newValue) {
                  setState(() {
                    _selectedHealthStatus = newValue!;
                  });
                },
              ),
              _buildDropdownWithIcon(
                Icons.sentiment_satisfied,
                _selectedBehavior,
                ['Behavior', 'Friendly', 'Aggressive', 'Calm'],
                (newValue) {
                  setState(() {
                    _selectedBehavior = newValue!;
                  });
                },
              ),
              _buildSectionTitle('Tertiary'),
              _buildAboutTextFieldWithIcon(
                Icons.info,
                'About',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: GoogleFonts.robotoFlex(
          fontSize: 18.sp,
          color: Colors.black45,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextFieldWithIcon(IconData icon, String hint,
      {bool isTextArea = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        maxLines: isTextArea ? 3 : 1,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.green[50],
          prefixIcon: Icon(icon, color: Colors.black),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Widget _buildAboutTextFieldWithIcon(IconData icon, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.black),
              SizedBox(width: 8.0),
              Text(
                hint,
                style: GoogleFonts.robotoFlex(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.green, width: 2.0),
            ),
            child: TextFormField(
              minLines: 2,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Write about Dog...',
                hintStyle: TextStyle(color: Colors.black54),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownWithIcon(IconData icon, String value, List<String> items,
      Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.green, width: 2.0),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.black,
              size: 25,
            ),
            SizedBox(width: 10), // Add spacing between the icon and dropdown
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: value,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                    size: 25,
                  ),
                  isExpanded: true,
                  items: items.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: GoogleFonts.robotoFlex(
                            fontSize: 15.sp, fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                  onChanged: onChanged,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPickerWithIcon(IconData icon, String value,
      List<String> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.green, width: 2.0),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.black,
              size: 25,
            ),
            SizedBox(width: 10), // Add spacing between the icon and dropdown
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: value,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                    size: 25,
                  ),
                  isExpanded: true,
                  items: List.generate(items.length, (index) {
                    return DropdownMenuItem<String>(
                      value: items[index],
                      child: Text(
                        items[index],
                        style: GoogleFonts.robotoFlex(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }),
                  onChanged: onChanged,
                ),
              ),
            ),
            if (value.isNotEmpty && items.contains(value))
              Container(
                width: 24,
                height: 24,
                margin: EdgeInsets.only(left: 8.0),
                decoration: BoxDecoration(
                  color: colorPalette[items.indexOf(value)],
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
