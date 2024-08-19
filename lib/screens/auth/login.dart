import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:puppid/screens/auth/register.dart';
import 'package:puppid/screens/home/bottomnav.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  bool isShow = true;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Color(0xff3AB648),
          actions: [
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(PageTransition(
                          child: BottomNav(), type: PageTransitionType.fade));
                    },
                    child: Text(
                      'Skip',
                      style: GoogleFonts.atma(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ))
              ],
            ),
          ],
        ),
        body: Align(
            child: Container(
          height: MediaQuery.of(context).size.height,
          color: Color(0xff3AB648),
          child: Padding(
            padding: EdgeInsets.only(top: 25.sp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset('assets/biglogo.png')),
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 1.8,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Color(0xffEBF3EC),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(52),
                              topRight: Radius.circular(52))),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 20.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Welcome Back',
                                  style: GoogleFonts.robotoFlex(
                                      color: Color(0xff3AB648),
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Image.asset('assets/paw.png')
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.sp),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 1.1,
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                          filled: true,
                                          labelText: 'Email Id',
                                          labelStyle: GoogleFonts.robotoFlex(),
                                          alignLabelWithHint: true,
                                          prefixIcon: const Icon(
                                            Icons.email,
                                            size: 25,
                                            color: Colors.black,
                                          ),
                                          fillColor: Colors.grey[100],
                                          hintText: 'Enter Your Email Id',
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  strokeAlign: 1.5,
                                                  width: 2,
                                                  color: Color(0xff3AB648))),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  strokeAlign: 1.5,
                                                  width: 2,
                                                  color: Color(0xff3AB648)))),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your email';
                                        }
                                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                            .hasMatch(value)) {
                                          return 'Please enter a valid email';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 20.sp),
                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: isShow,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      decoration: InputDecoration(
                                          filled: true,
                                          labelText: 'Password',
                                          labelStyle: GoogleFonts.robotoFlex(),
                                          alignLabelWithHint: true,
                                          suffixIcon: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isShow = !isShow;
                                                });
                                              },
                                              child: isShow
                                                  ? Icon(
                                                      Icons.visibility_outlined,
                                                      size: 25)
                                                  : Icon(
                                                      Icons
                                                          .visibility_off_outlined,
                                                      size: 25),
                                            ),
                                          ),
                                          prefixIcon: const Icon(
                                            Icons.lock,
                                            size: 25,
                                            color: Colors.black,
                                          ),
                                          fillColor: Colors.grey[100],
                                          hintText: 'Enter Your Password',
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  strokeAlign: 1.5,
                                                  width: 2,
                                                  color: Color(0xff3AB648))),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  strokeAlign: 1.5,
                                                  width: 2,
                                                  color: Color(0xff3AB648)))),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        if (value.length < 6) {
                                          return 'Password must be at least 6 characters long';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.only(top: 5.sp, right: 8.sp),
                              child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Forgot Password?',
                                    style: GoogleFonts.robotoFlex(
                                        color: Color(0xff3AB648),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  )),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.sp),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 1.3,
                              height: 55,
                              decoration: BoxDecoration(
                                  color: Color(0xff3AB648),
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        isLoading = true;
                                      });

                                      try {
                                        await _auth.signInWithEmailAndPassword(
                                          email: _emailController.text.trim(),
                                          password:
                                              _passwordController.text.trim(),
                                        );

                                        Navigator.of(context).pushReplacement(
                                            PageTransition(
                                                child: BottomNav(),
                                                type: PageTransitionType.fade));
                                      } on FirebaseAuthException catch (e) {
                                        String message;
                                        if (e.code == 'user-not-found') {
                                          message =
                                              'No user found for that email.';
                                        } else if (e.code == 'wrong-password') {
                                          message =
                                              'Wrong password provided for that user.';
                                        } else {
                                          message =
                                              'Login failed. Please try again.';
                                        }

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(message),
                                          backgroundColor: Colors.red,
                                        ));
                                      } finally {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    }
                                  },
                                  child: isLoading
                                      ? CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Login',
                                              style: GoogleFonts.robotoFlex(
                                                  color: Colors.white,
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            SizedBox(
                                              width: 3.w,
                                            ),
                                            Image.asset(
                                              'assets/whitepaw.png',
                                              height: 50,
                                              width: 50,
                                            )
                                          ],
                                        )),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.sp),
                            child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(PageTransition(
                                      child: RegisterPage(),
                                      type: PageTransitionType.leftToRight));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'New Registration',
                                      style: GoogleFonts.robotoFlex(
                                          color: Color(0xff3AB648),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      width: 2.w,
                                    ),
                                    Image.asset('assets/greendog.png')
                                  ],
                                )),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}
