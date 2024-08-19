import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CaretakerProfilePage extends StatefulWidget {
  @override
  _CaretakerProfilePageState createState() => _CaretakerProfilePageState();
}

class _CaretakerProfilePageState extends State<CaretakerProfilePage> {
  String _selectedGender = 'Male';
  String _selectedDate = 'DD/MM/YYYY';
  String _selectedCountry = 'Country';
  String _selectedState = 'State';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now())
      setState(() {
        _selectedDate = DateFormat('dd/MM/yyyy').format(picked);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              weight: 800,
              size: 25,
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text("Caretaker Profile",
              style: GoogleFonts.robotoFlex(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              )),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextFieldWithIcon(Icons.person, 'Name'),
              Row(
                children: [
                  Expanded(
                    child: _buildDatePickerWithIcon(
                      Icons.calendar_today,
                      _selectedDate,
                      () => _selectDate(context),
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
              _buildTextFieldWithIcon(Icons.email, 'Email id'),
              _buildTextFieldWithIcon(Icons.phone, 'Phone Number'),
              _buildTextFieldWithIcon(Icons.home, 'Door no,'),
              _buildTextFieldWithIcon(
                  Icons.location_on, 'Street Name, Area Name'),
              _buildTextFieldWithIcon(Icons.landscape, 'Landmark'),
              Row(
                children: [
                  Expanded(
                    child: _buildTextFieldWithIcon(
                        Icons.location_city, 'District'),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: _buildTextFieldWithIcon(Icons.pin_drop, '000000'),
                  ),
                ],
              ),
              _buildDropdownWithIcon(
                Icons.map,
                _selectedState,
                [
                  'State',
                  'State 1',
                  'State 2',
                  'State 3'
                ], // Add your states here
                (newValue) {
                  setState(() {
                    _selectedState = newValue!;
                  });
                },
              ),
              _buildDropdownWithIcon(
                Icons.public,
                _selectedCountry,
                [
                  'Country',
                  'Country 1',
                  'Country 2',
                  'Country 3'
                ], // Add your countries here
                (newValue) {
                  setState(() {
                    _selectedCountry = newValue!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldWithIcon(IconData icon, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.green[50],
          prefixIcon: Icon(icon, color: Colors.black),
          hintText: hint,
          hintStyle: GoogleFonts.robotoFlex(color: Colors.black),
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
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            icon: Icon(Icons.arrow_drop_down, color: Colors.black),
            isExpanded: true,
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value,
                    style: GoogleFonts.robotoFlex(
                        fontSize: 15.sp, fontWeight: FontWeight.bold)),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerWithIcon(
      IconData icon, String date, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.green, width: 2.0),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.black),
              SizedBox(width: 8.0),
              Text(
                date,
                style: GoogleFonts.robotoFlex(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Spacer(),
              Icon(Icons.arrow_drop_down, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}
