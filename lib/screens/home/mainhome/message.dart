import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:puppid/screens/home/mainhome/chat.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final TextEditingController _searchController = TextEditingController();
  bool isMsg = false;
  @override
  @override
  void initState() {
    isMsg = false;
    super.initState();
  }

  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search . . .',
                  hintStyle: GoogleFonts.robotoFlex(
                    color: Color(0xff737373),
                    fontWeight: FontWeight.w600,
                  ),
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
            Expanded(
              child: ListView(
                children: [
                  MessageCard(
                    avatarColor: Colors.green,
                    avatarIcon: Icons.pets,
                    name: 'Mr. XXXXX',
                    message: 'XX: I\'m Interested',
                    time: '11:11',
                    unreadCount: 1,
                  ),
                  MessageCard(
                    avatarColor: Colors.green,
                    avatarIcon: Icons.pets,
                    name: 'Mr. YYYYY',
                    message: 'You: Hello',
                    time: '',
                    unreadCount: 0,
                  ),
                  MessageCard(
                    avatarColor: Colors.blue,
                    avatarIcon: Icons.pets,
                    name: 'Mr. ZZZZZ',
                    message: 'You: Hello',
                    time: '',
                    unreadCount: 0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageCard extends StatelessWidget {
  final Color avatarColor;
  final IconData avatarIcon;
  final String name;
  final String message;
  final String time;
  final int unreadCount;

  const MessageCard({
    Key? key,
    required this.avatarColor,
    required this.avatarIcon,
    required this.name,
    required this.message,
    required this.time,
    required this.unreadCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(PageTransition(
              child: MessageChat(), type: PageTransitionType.leftToRight));
        },
        child: Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: avatarColor,
                child: Icon(
                  avatarIcon,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.robotoFlex(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Text(
                      message,
                      style: GoogleFonts.robotoFlex(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    time,
                    style: GoogleFonts.robotoFlex(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  if (unreadCount > 0)
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.green,
                      child: Text(
                        unreadCount.toString(),
                        style: GoogleFonts.robotoFlex(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
