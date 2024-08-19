import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:puppid/screens/auth/userloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();
  bool isShow = true;
  bool _isLoading = false; // Loading state flag

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Start loading
      });

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .collection('Caretaker')
            .doc(userCredential.user!.uid)
            .set({
          'uid': userCredential.user!.uid,
          'name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'email': _emailController.text.trim(),
        });

        Navigator.of(context).pushReplacement(PageTransition(
            child: UserLocation(
              uid: userCredential.user!.uid,
            ),
            type: PageTransitionType.fade));
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Registration failed')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred')),
        );
      } finally {
        setState(() {
          _isLoading = false; // Stop loading
        });
      }
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters';
    } else if (!RegExp(r'^(?=.*[A-Z])(?=.*[!@#$&*])').hasMatch(value)) {
      return 'Password must contain at least one capital letter and one symbol';
    }
    return null;
  }

  String? _validateRepeatPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Color(0xff3AB648),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                color: Color(0xff3AB648),
                child: Padding(
                  padding: EdgeInsets.only(top: 2.sp),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Image.asset('assets/biglogo.png'),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 1.3,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Color(0xffEBF3EC),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(52),
                                  topRight: Radius.circular(52))),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 10.sp),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Welcome ',
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
                                    width:
                                        MediaQuery.of(context).size.width / 1.1,
                                    child: TextFormField(
                                      controller: _nameController,
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                          filled: true,
                                          labelStyle: GoogleFonts.robotoFlex(),
                                          labelText: 'Name',
                                          alignLabelWithHint: true,
                                          prefixIcon: const Icon(
                                            Icons.person,
                                            size: 25,
                                            color: Colors.black,
                                          ),
                                          fillColor: Colors.grey[100],
                                          hintText: 'Enter Your Name',
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
                                      validator: _validateName,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 20.sp),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.1,
                                    child: TextFormField(
                                      controller: _phoneController,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                          filled: true,
                                          labelText: 'Phone Number',
                                          labelStyle: GoogleFonts.robotoFlex(),
                                          alignLabelWithHint: true,
                                          prefixIcon: const Icon(
                                            Icons.phone,
                                            size: 25,
                                            color: Colors.black,
                                          ),
                                          fillColor: Colors.grey[100],
                                          hintText: 'Enter Your Phone Number',
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
                                      validator: _validatePhone,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 20.sp),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.1,
                                    child: TextFormField(
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
                                      validator: _validateEmail,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 20.sp),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.1,
                                    child: TextFormField(
                                      controller: _passwordController,
                                      obscureText: isShow,
                                      decoration: InputDecoration(
                                          filled: true,
                                          labelText: 'Password',
                                          labelStyle: GoogleFonts.robotoFlex(),
                                          alignLabelWithHint: true,
                                          prefixIcon: const Icon(
                                            Icons.lock,
                                            size: 25,
                                            color: Colors.black,
                                          ),
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                isShow = !isShow;
                                              });
                                            },
                                            icon: isShow
                                                ? const Icon(Icons.visibility)
                                                : const Icon(
                                                    Icons.visibility_off),
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
                                      validator: _validatePassword,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 20.sp),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.1,
                                    child: TextFormField(
                                      controller: _repeatPasswordController,
                                      obscureText: isShow,
                                      decoration: InputDecoration(
                                          filled: true,
                                          labelText: 'Repeat Password',
                                          labelStyle: GoogleFonts.robotoFlex(),
                                          alignLabelWithHint: true,
                                          prefixIcon: const Icon(
                                            Icons.lock,
                                            size: 25,
                                            color: Colors.black,
                                          ),
                                          fillColor: Colors.grey[100],
                                          hintText: 'Enter Your Password Again',
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
                                      validator: _validateRepeatPassword,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 50.sp,right:50.sp,left:50.sp),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Color(0xff3AB648)),
                                        minimumSize: MaterialStateProperty.all(
                                            Size(350.w, 50.h)),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        30)))),
                                    onPressed: _isLoading
                                        ? null
                                        : () {
                                            _registerUser();
                                          },
                                    child: _isLoading
                                        ? CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : Text(
                                            'Register',
                                            style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 22),
                                          ),
                                  ),
                                ),
                                ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
