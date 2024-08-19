import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:puppid/screens/home/settings/caredprofile.dart';
import 'package:puppid/screens/home/settings/dogprofile.dart';
import 'package:puppid/screens/home/settings/help.dart';
import 'package:puppid/screens/home/settings/photovideo.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
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
                size: 25,
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text("Account",
                style: GoogleFonts.robotoFlex(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                )),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        'Dog Profile',
                        style: GoogleFonts.robotoFlex(
                          fontSize: 16.sp,
                          color: Colors.black45,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AccountProfile(
                title: 'Tom',
                subtitle: 'Labrador',
                onfun: () {
                  Navigator.of(context).push(PageTransition(
                      child: DogProfilePage(),
                      type: PageTransitionType.leftToRight));
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        'Cared Profile',
                        style: GoogleFonts.robotoFlex(
                          fontSize: 16.sp,
                          color: Colors.black45,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AccountProfile(
                title: 'Mr. XXXX',
                subtitle: 'Area, District',
                onfun: () {
                  Navigator.of(context).push(PageTransition(
                      child: CaretakerProfilePage(),
                      type: PageTransitionType.leftToRight));
                },
              ),
              SizedBox(
                height: 5.h,
              ),
              HelpItem(icon: Icons.mail, onfun: () {}, title: 'Change Email'),
              SizedBox(
                height: 5.h,
              ),
              HelpItem(
                  icon: Icons.lock, onfun: () {}, title: 'Change Password'),
              SizedBox(
                height: 5.h,
              ),
              HelpItem(
                  icon: Icons.phone,
                  onfun: () {},
                  title: 'Change Phone Number'),
              SizedBox(
                height: 5.h,
              ),
              HelpItem(
                  icon: Icons.delete,
                  onfun: () {},
                  title: 'Delete Your Account'),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountProfile extends StatefulWidget {
  AccountProfile(
      {super.key,
      required this.subtitle,
      required this.onfun,
      required this.title});
  String title;
  String subtitle;
  VoidCallback onfun;
  @override
  State<AccountProfile> createState() => _AccountProfileState();
}

class _AccountProfileState extends State<AccountProfile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
            color: Color.fromRGBO(185, 243, 192, 0.425),
            border: Border.all(color: Color(0xff3AB648), width: 2.0),
            borderRadius: BorderRadius.circular(10)),
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onDoubleTap: () {
                Navigator.of(context).push(PageTransition(
                    child: PhotosAndVideosPage(),
                    type: PageTransitionType.leftToRight));
              },
              child: CircleAvatar(
                backgroundColor: Color(0xff3AB648),
                radius: 43,
                child: CircleAvatar(
                  backgroundColor: Color(0xffF0F9F1),
                  radius: 39,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${widget.title}',
                  style: GoogleFonts.robotoFlex(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Text(
                  '${widget.subtitle}',
                  style: GoogleFonts.robotoFlex(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black45),
                ),
              ],
            ),
            IconButton(
                color: Color(0xff3AB648),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Color(0xff3AB648))),
                onPressed: widget.onfun,
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                ))
          ],
        ),
      ),
    );
  }
}
