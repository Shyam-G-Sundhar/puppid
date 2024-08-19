import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool isNotify = true;
  bool isVibrate = true;
  bool isChats = true;
  bool isSuggestion = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isNotify = prefs.getBool('isNotify') ?? true;

      isChats = prefs.getBool('isChats') ?? true;
      isSuggestion = prefs.getBool('isSuggestion') ?? true;
    });
  }

  void _openAppNotificationSettings() {
    final AndroidIntent intent = AndroidIntent(
      action: 'android.settings.APP_NOTIFICATION_SETTINGS',
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      arguments: <String, dynamic>{
        'app_package': 'com.example.puppid',
      },
    );
    intent.launch();
  }

  void _toggleNotify(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isNotify', value);
    setState(() {
      isNotify = value;
      if (!value) {
        _openAppNotificationSettings();
      }
    });
  }

  void _toggleChats(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isChats', value);
    setState(() {
      isChats = value;
    });
  }

  void _toggleSuggestion(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSuggestion', value);
    setState(() {
      isSuggestion = value;
    });
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
                size: 25,
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text("Notifications",
                style: GoogleFonts.robotoFlex(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              NotificationItem(
                title: 'Notifications',
                switchValue: isNotify,
                onSwitchChanged: _toggleNotify,
              ),
              SizedBox(
                height: 5.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Text(
                      'Others',
                      style: GoogleFonts.robotoFlex(
                        fontSize: 14.sp,
                        color: Colors.black45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              NotificationItem(
                title: 'Chats',
                switchValue: isChats,
                onSwitchChanged: _toggleChats,
              ),
              NotificationItem(
                title: 'Suggestions',
                switchValue: isSuggestion,
                onSwitchChanged: _toggleSuggestion,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationItem extends StatefulWidget {
  NotificationItem({
    super.key,
    required this.title,
    required this.switchValue,
    required this.onSwitchChanged,
  });

  final String title;
  final bool switchValue;
  final Function(bool) onSwitchChanged;

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: InkWell(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: GoogleFonts.robotoFlex(
                        fontSize: 16.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: widget.switchValue,
                  onChanged: widget.onSwitchChanged,
                  activeTrackColor: Color(0xff3AB648),
                  activeColor: Colors.white,
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0x99F0F9F1),
          ),
        ),
      ),
    );
  }
}
