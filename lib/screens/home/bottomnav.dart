import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // Add this import
import 'package:puppid/screens/home/mainhome/home.dart';
import 'package:puppid/screens/home/mainhome/locat.dart';
import 'package:puppid/screens/home/mainhome/message.dart';
import 'package:puppid/screens/home/notification.dart';
import 'package:puppid/screens/home/settings/settings.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late PageController _pageController;
  int _currentIndex = 0;
  String _address = '''
Locating ... ,
Please wait...''';

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _checkInternetAndSetup();
    _requestNotificationPermission();
    _pageController = PageController(initialPage: _currentIndex);
  }

  Future<void> _checkInternetAndSetup() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Navigator.of(context).pushReplacement(
        PageTransition(
          child: NoInternetPage(),
          type: PageTransitionType.rightToLeft,
        ),
      );
    } else {
      // Proceed with location and address setup if there's internet
      _getUserLocationAndAddress();
    }
  }

  Future<void> _getUserLocationAndAddress() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
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
          setState(() {
            _address = 'Permissions,Denied';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _address = 'permissions,permanently denied.';
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      String address = await getAddressFromCoordinates(position);
      setState(() {
        _address = address;
      });
    } catch (e) {
      setState(() {
        _address = 'Try Again, ';
      });
    }
  }

  Future<void> _requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      await Permission.locationWhenInUse.request();
    }
  }

  Future<String> getAddressFromCoordinates(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    return "${place.locality}, ${place.administrativeArea}";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          toolbarHeight: 100,
          leadingWidth: 450,
          leading: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 5.0),
                      child: InkWell(
                        onTap: () async {
                          print(_address);
                          final selectedLocation =
                              await Navigator.of(context).push(
                            PageTransition(
                              child: LocationSelectionPage(),
                              type: PageTransitionType.bottomToTop,
                            ),
                          );
                          if (selectedLocation != null) {
                            setState(() {
                              _address = selectedLocation;
                            });
                          }
                        },
                        child: Container(
                          height: 75,
                          width: 250,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(217, 217, 217, 34),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.location_on,
                                  size: 40,
                                  color: Color(0xff737373),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      " ${_address.split(',').first}\n${_address.split(',').last}",
                                      style: GoogleFonts.robotoFlex(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                      overflow: TextOverflow.visible,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              PageTransition(
                                child: HomeNotificationPage(),
                                type: PageTransitionType.bottomToTop,
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.diversity_1,
                            size: 30,
                            color: Colors.grey,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              PageTransition(
                                child: SettingsPage(),
                                type: PageTransitionType.rightToLeft,
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Color(0xff3AB648),
                            backgroundImage: NetworkImage(
                              'https://cdn.pixabay.com/photo/2023/08/18/15/02/dog-8198719_640.jpg',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: PageView(
          controller: _pageController,
          children: _pages,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 5.0,
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xff3AB648),
          unselectedItemColor: Colors.grey,
          currentIndex: _currentIndex,
          onTap: (index) {
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          items: [
            BottomNavigationBarItem(
              icon: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: _currentIndex == 0
                    ? Icon(Icons.home, key: ValueKey<int>(0))
                    : Icon(Icons.home_outlined, key: ValueKey<int>(1)),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: _currentIndex == 1
                    ? Icon(Icons.chat_rounded, key: ValueKey<int>(0))
                    : Icon(Icons.chat_bubble_outline, key: ValueKey<int>(1)),
              ),
              label: 'Chats',
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _pages = [Home(), MessagePage()];
}

class NoInternetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('No Internet')),
      body: Center(
        child: Text(
          'No Internet Connection',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
