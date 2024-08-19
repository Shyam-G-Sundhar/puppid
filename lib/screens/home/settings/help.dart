import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return SafeArea(
      child: Scaffold(
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
                size: 30,
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text("Help",
                style: GoogleFonts.robotoFlex(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ),
        body: Column(
          children: [
            HelpItem(
                icon: Icons.help_center_rounded,
                onfun: () {},
                title: 'Help Center'),
            HelpItem(icon: Icons.phone, onfun: () {}, title: 'Contact us'),
            HelpItem(icon: Icons.policy, onfun: () {}, title: 'Privacy Policy'),
            HelpItem(icon: Icons.info, onfun: () {}, title: 'App Info')
          ],
        ),
      ),
    );
  }
}

class HelpItem extends StatefulWidget {
  HelpItem(
      {super.key,
      required this.icon,
      required this.onfun,
      required this.title});
  IconData icon;
  String title;

  VoidCallback onfun;
  @override
  State<HelpItem> createState() => _HelpItemState();
}

class _HelpItemState extends State<HelpItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: InkWell(
        onTap: widget.onfun,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(widget.icon, size: 30, color: Colors.black),
                    ),
                    SizedBox(
                      width: 25.w,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.title}',
                          style: GoogleFonts.robotoFlex(
                            fontSize: 16.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  child: IconButton(
                    onPressed: widget.onfun,
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                      size: 22,
                    ),
                  ),
                )
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
