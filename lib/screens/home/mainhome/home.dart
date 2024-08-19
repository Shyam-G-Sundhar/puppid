import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:puppid/screens/home/mainhome/dogpage.dart';
import 'package:puppid/screens/home/settings/settings.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double _currentSliderValue = 10; // Initial slider value
  final List<Map<String, dynamic>> _dogs = [
    {
      'name': 'Tom',
      'distance': 1.5,
      'age': '6 Months +',
      'color': 'Black & White',
      'imageUrl':
          'https://images.pexels.com/photos/1108099/pexels-photo-1108099.jpeg'
    },
    {
      'name': 'Max',
      'distance': 5,
      'age': '1 Year +',
      'color': 'Brown',
      'imageUrl':
          'https://images.pexels.com/photos/356378/pexels-photo-356378.jpeg'
    },
    {
      'name': 'Buddy',
      'distance': 3,
      'age': '8 Months',
      'color': 'Golden',
      'imageUrl':
          'https://images.pexels.com/photos/4587997/pexels-photo-4587997.jpeg'
    },
    {
      'name': 'Charlie',
      'distance': 8,
      'age': '2 Years',
      'color': 'White & Brown',
      'imageUrl':
          'https://images.pexels.com/photos/4587997/pexels-photo-4587997.jpeg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(360, 690));
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Search . . .',
                    hintStyle: GoogleFonts.robotoFlex(
                        color: Color(0xff737373), fontWeight: FontWeight.w600),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    filled: true,
                    fillColor: Color(0xffE2EBE3),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xff3AB648), width: 2.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xff3AB648), width: 2.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: _currentSliderValue,
                        min: 0,
                        max: 100,
                        divisions: 20,
                        activeColor: Colors.green,
                        label: _currentSliderValue.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            _currentSliderValue = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "${_currentSliderValue.round()} Km",
                      style: GoogleFonts.robotoFlex(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'For You',
                    style: GoogleFonts.roboto(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: _dogs
                    .where((dog) => dog['distance'] <= _currentSliderValue)
                    .length,
                itemBuilder: (context, index) {
                  final filteredDogs = _dogs
                      .where((dog) => dog['distance'] <= _currentSliderValue)
                      .toList();
                  final dog = filteredDogs[index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(PageTransition(
                          child: DogPage(),
                          type: PageTransitionType.rightToLeft));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(dog['imageUrl']),
                          fit: BoxFit.cover,
                        ),
                        border:
                            Border.all(color: Color(0xff3AB648), width: 3.0),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      margin: const EdgeInsets.all(5),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          color: Color(0x99E2EBE3),
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    dog['name'],
                                    style: GoogleFonts.robotoFlex(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.black,
                                        size: 22,
                                      ),
                                      Text(
                                        '${dog['distance']} Km',
                                        style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${dog['age']}',
                                style: GoogleFonts.robotoFlex(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Text(
                                '${dog['color']}',
                                style: GoogleFonts.robotoFlex(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
