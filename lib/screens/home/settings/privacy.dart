import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  bool isReadReci = true;
  String _isLastSeen = 'Nobody';
  String _isOnline = 'Nobody';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isReadReci = prefs.getBool('isReadReci') ?? true;
      _isLastSeen = prefs.getString('lastSeen') ?? 'Nobody';
      _isOnline = prefs.getString('online') ?? 'Nobody';
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isReadReci', isReadReci);
    prefs.setString('lastSeen', _isLastSeen);
    prefs.setString('online', _isOnline);
  }

  void _toggleReadReci(bool value) {
    setState(() {
      isReadReci = value;
      _savePreferences();
    });
  }

  void _setLastSeen(String value) {
    setState(() {
      _isLastSeen = value;
      _savePreferences();
    });
  }

  void _setOnline(String value) {
    setState(() {
      _isOnline = value;
      _savePreferences();
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back_ios,
              weight: 800,
              size: 25,
            ),
          ),
          title: Text(
            "Privacy",
            style: GoogleFonts.robotoFlex(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Row(
                  children: [
                    Text(
                      'Who can see my personal info',
                      style: GoogleFonts.robotoFlex(
                        fontSize: 16.sp,
                        color: Colors.black45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              PrivacyItem(
                title: 'Last Seen',
                subtitle: _isLastSeen,
                onfun: () {
                  _showPrivacyDialog(
                    context,
                    title: 'Last Seen',
                    groupValue: _isLastSeen,
                    onChanged: (value) {
                      _setLastSeen(value);
                    },
                  );
                },
              ),
              PrivacyItem(
                title: 'Online',
                subtitle: _isOnline,
                onfun: () {
                  _showPrivacyDialog(
                    context,
                    title: 'Online',
                    groupValue: _isOnline,
                    onChanged: (value) {
                      _setOnline(value);
                    },
                  );
                },
              ),
              _buildReadReceiptsToggle(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Row(
                  children: [
                    Text(
                      'Blocked Profiles',
                      style: GoogleFonts.robotoFlex(
                        fontSize: 16.sp,
                        color: Colors.black45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              PrivacyItem(
                title: 'Blocked Profiles',
                subtitle: '2',
                onfun: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context,
      {required String title,
      required String groupValue,
      required Function(String) onChanged}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: GoogleFonts.robotoFlex(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text(
                  'Nobody',
                  style: GoogleFonts.robotoFlex(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                value: 'Nobody',
                groupValue: groupValue,
                activeColor: Colors.green,
                onChanged: (value) {
                  onChanged(value!);
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<String>(
                title: Text(
                  'Everyone',
                  style: GoogleFonts.robotoFlex(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                value: 'Everyone',
                groupValue: groupValue,
                activeColor: Colors.green,
                onChanged: (value) {
                  onChanged(value!);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: GoogleFonts.robotoFlex(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff3AB648),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReadReceiptsToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xffF0F9F1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Read Receipts',
                    style: GoogleFonts.robotoFlex(
                      fontSize: 18.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Switch(
                    value: isReadReci,
                    onChanged: _toggleReadReci,
                    activeTrackColor: Color(0xff3AB648),
                    activeColor: Colors.white,
                  ),
                ],
              ),
              SizedBox(
                height: 3.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  'If turned off, you won’t send or receive Read receipt.',
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.robotoFlex(
                    fontSize: 15.sp,
                    color: Colors.black45,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrivacyItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onfun;

  const PrivacyItem({
    Key? key,
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
                    SizedBox(width: 10.w),
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
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            subtitle,
                            style: GoogleFonts.robotoFlex(
                              fontSize: 12.sp,
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
