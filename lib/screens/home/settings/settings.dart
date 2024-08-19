import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:puppid/screens/home/settings/account.dart';
import 'package:puppid/screens/home/settings/help.dart';
import 'package:puppid/screens/home/settings/notification.dart';
import 'package:puppid/screens/home/settings/privacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:puppid/screens/auth/login.dart'; // Import the LoginPage

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedLanguage = 'English';
  bool _isLoading = false; // Loading state variable

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  void _loadSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
    });
  }

  void _saveSelectedLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', language);
    setState(() {
      selectedLanguage = language;
    });
  }

  void _logout() async {
    // Show confirmation dialog
    bool? shouldLogout = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout',
              style: GoogleFonts.robotoFlex(
                fontSize: 14.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              )),
          content: Text('Are you sure you want to logout?',
              style: GoogleFonts.robotoFlex(
                fontSize: 12.sp,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              )),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('No',
                  style: GoogleFonts.robotoFlex(
                    fontSize: 10.sp,
                    color: Colors.green,
                    fontWeight: FontWeight.w700,
                  )),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Yes',
                  style: GoogleFonts.robotoFlex(
                    fontSize: 10.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  )),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      setState(() {
        _isLoading = true; // Set loading to true
      });

      try {
        // Perform the logout operation
        await FirebaseAuth.instance.signOut();

        // Navigate to the login page
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false,
        );
      } catch (e) {
        // Handle logout error if needed
        print("Error logging out: $e");
      } finally {
        setState(() {
          _isLoading = false; // Set loading to false
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                weight: 800,
                size: 30,
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 68,
                      backgroundColor: Color(0xff3AB648),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://cdn.pixabay.com/photo/2023/08/18/15/02/dog-8198719_640.jpg'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    'XXXX',
                    style: GoogleFonts.atma(
                      fontSize: 22.sp,
                      color: Color(0xff3AB648),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SettingsItem(
                    icon: Icons.key,
                    title: 'Account',
                    subtitle: 'Change Email, Change Number',
                    onfun: () {
                      Navigator.of(context).push(PageTransition(
                          child: AccountPage(),
                          type: PageTransitionType.leftToRight));
                    },
                  ),
                  SettingsItem(
                    icon: Icons.lock,
                    title: 'Privacy',
                    subtitle: 'Block Contacts, Read recipient',
                    onfun: () {
                      Navigator.of(context).push(PageTransition(
                          child: PrivacyPage(),
                          type: PageTransitionType.leftToRight));
                    },
                  ),
                  SettingsItem(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    subtitle: 'Messages',
                    onfun: () {
                      Navigator.of(context).push(PageTransition(
                          child: NotificationPage(),
                          type: PageTransitionType.leftToRight));
                    },
                  ),
                  SettingsItem(
                    icon: Icons.language,
                    title: 'App Language',
                    subtitle: selectedLanguage,
                    onfun: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              children: [
                                _buildLanguageListTile('Language 1'),
                                _buildLanguageListTile('Language 2'),
                                _buildLanguageListTile('Language 3'),
                                _buildLanguageListTile('Language 4'),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SettingsItem(
                    icon: Icons.help,
                    title: 'Help',
                    subtitle: 'Contact us, Privacy Policy',
                    onfun: () {
                      Navigator.of(context).push(PageTransition(
                          child: HelpPage(),
                          type: PageTransitionType.leftToRight));
                    },
                  ),
                  SettingsItem(
                    icon: Icons.smartphone,
                    title: 'Invite a Friend',
                    subtitle: 'Invite through Link',
                    onfun: () {},
                  ),
                  SettingsItem(
                    icon: Icons.logout,
                    title: 'Logout',
                    subtitle: 'Logout from the app',
                    onfun: _logout, // Call _logout method
                  ),
                ],
              ),
            ),
            if (_isLoading) // Show loading indicator if loading
              Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageListTile(String language) {
    return ListTile(
      leading: Icon(Icons.language),
      title: Text(language),
      trailing: selectedLanguage == language
          ? Icon(Icons.check, color: Color(0xff3AB648))
          : null,
      onTap: () {
        _saveSelectedLanguage(language);
        Navigator.of(context).pop();
      },
    );
  }
}

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onfun;

  const SettingsItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onfun,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: InkWell(
        onTap: onfun,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xffF0F9F1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(icon, size: 25, color: Colors.black),
                    ),
                    SizedBox(
                      width: 25.w,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.robotoFlex(
                            fontSize: 16.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            subtitle,
                            style: GoogleFonts.robotoFlex(
                              fontSize: 10.sp,
                              color: Colors.black45,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                  size: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
