// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:async';

import 'package:eventin/controllers/postApiController.dart';
import 'package:eventin/view/home_page.dart';
import 'package:eventin/view/login_otp_screen.dart';
import 'package:eventin/widgets/dark_blue_button%20copy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

// import 'package:internet_popup/internet_popup.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? _selectedImage;
  // List<Map<String, dynamic>> _imageOptions = [
  //   {'value': 'assets/flags/India.png', 'label': 'Image 1'},
  //   {'value': 'assets/flags/Japan.png', 'label': 'Image 2'},
  //   {'value': 'assets/flags/USA.png', 'label': 'Image 3'},
  //   {'value': 'assets/flags/Russia.png', 'label': 'Image 3'},
  //   {'value': 'assets/flags/UK.png', 'label': 'Image 3'},
  // ];

  final TextEditingController mobileNumberController = TextEditingController();

  RegExp digitValidator = RegExp("[0-9]+");
  bool isANumber = true;
  bool isChecked = true;
  int phoneNumberLength = 0;

  // late StreamSubscription internetCheck;
  // bool isDeviceConnected = false;

  int selectedValue = -1;

  @override
  void initState() {
    // _selectedImage = _imageOptions[0]['value'];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            // top: 65,
            top: MediaQuery.of(context).size.width * 0.10,

            // left: MediaQuery.of(context).size.width * 0.25,
            // height: MediaQuery.of(context).size.width * 0.80,
            width: MediaQuery.of(context).size.width,
            child: Image(
              fit: BoxFit.contain,
              image: AssetImage('assets/login_banner.jpeg'),
            ),
          ),
          Positioned(
            // top: 345,
            top: MediaQuery.of(context).size.height * 0.344,
            // bottom: 30,
            height: MediaQuery.of(context).size.height * 0.65,
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: MediaQuery.of(context).size.height * 1,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(24),
                ),
              ),
              child: Opacity(
                opacity: 0.1,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                  height: MediaQuery.of(context).size.height * 1,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(24),
                      ),
                      color: Colors.black),
                ),
              ),
            ),
          ),
          Positioned(
            // top: 345,
            top: MediaQuery.of(context).size.height * 0.35,
            // bottom: 30,
            height: MediaQuery.of(context).size.height * 0.65,
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: MediaQuery.of(context).size.height * 1,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(24),
                  ),
                  color: Colors.white),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                height: MediaQuery.of(context).size.height * 1,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(24),
                    ),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 8),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Insert your phone number \n',
                              style: GoogleFonts.manrope(
                                  fontSize: 15, color: const Color(0xffB7BFCA)),
                            ),
                            TextSpan(
                              text: 'to Login',
                              style: GoogleFonts.manrope(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff0C5CBA)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        // Container(
                        //   width: MediaQuery.of(context).size.width * 0.14,
                        //   child: DropdownButtonFormField<String>(
                        //     value: _selectedImage,
                        //     onChanged: (value) {
                        //       setState(() {
                        //         _selectedImage = value;
                        //       });
                        //     },
                        //     items: _imageOptions
                        //         .map((item) => DropdownMenuItem<String>(
                        //               value: item['value'],
                        //               child: Image.asset(
                        //                 item['value'],
                        //                 width: 25,
                        //                 height: 25,
                        //               ),
                        //             ))
                        //         .toList(),
                        //   ),
                        // ),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.phone,
                            controller: mobileNumberController,
                            onChanged: (inputValue) {
                              if ((inputValue.isEmpty ||
                                  RegExp(r'^[0-9]*$').hasMatch(inputValue))) {
                                if (inputValue.length > 10) {
                                  mobileNumberController.text =
                                      inputValue.substring(0, 10);
                                  mobileNumberController.selection =
                                      TextSelection.fromPosition(
                                    TextPosition(
                                        offset:
                                            mobileNumberController.text.length),
                                  );
                                  setValidator(false);
                                }
                                setValidator(true);
                              } else {
                                setValidator(false);
                                // Remove the excess characters if the length exceeds 10
                                if (inputValue.length > 10) {
                                  mobileNumberController.text =
                                      inputValue.substring(0, 10);
                                  mobileNumberController.selection =
                                      TextSelection.fromPosition(
                                    TextPosition(
                                        offset:
                                            mobileNumberController.text.length),
                                  );
                                }
                              }
                              phoneNumberLength = inputValue.length;
                            },
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffB7BFCA)),
                              ),
                              hintText: "10 Digit Mobile Number",
                              hintStyle: const TextStyle(
                                color: Color(0xffB7BFCA),
                              ),
                              errorText:
                                  isANumber ? null : "Invalid phone number",
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                              activeColor: Color(0xff0C5CBA),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    5), // You can set the radius value as per your need.
                              ),
                              checkColor: Colors.white,
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),
                            Text(
                              'I agree to ',
                              style: GoogleFonts.manrope(
                                  fontSize: 15, color: Color(0xffB7BFCA)),
                            ),
                            Text(
                              'Terms ',
                              style: GoogleFonts.manrope(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff0C5CBA)),
                            ),
                            Text(
                              '& ',
                              style: GoogleFonts.manrope(
                                  fontSize: 15, color: Color(0xffB7BFCA)),
                            ),
                            Text(
                              'Privacy Policy',
                              style: GoogleFonts.manrope(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff0C5CBA)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: BlueButton(onPressed: _getOtp, title: 'Next'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Don\'t have an account?',
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            )),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                            );
                          },
                          child: Text(
                            'Register',
                            style: GoogleFonts.manrope(
                                fontSize: 17, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void setValidator(valid) {
    setState(() {
      isANumber = valid;
    });
  }

  /// G E T   O T P
  void _getOtp() {
    print(phoneNumberLength);
    if (isChecked == false) {
      showTopSnackBar(
          dismissType: DismissType.onTap,
          displayDuration: const Duration(seconds: 2),
          context,
          CustomSnackBar.info(
            message: "Please Agree to the Terms and Privacy Policy",
          ));
    } else if (phoneNumberLength < 10 || !isANumber) {
      showTopSnackBar(
          dismissType: DismissType.onTap,
          displayDuration: const Duration(seconds: 2),
          context,
          CustomSnackBar.info(
            message: "Please enter valid phone number",
          ));
    } else {
      String mobileNumber = mobileNumberController.text;

      if (mobileNumber.length != 10) {
        return; // Do nothing if the input length is invalid
      }

      getOtp(
        context: context,
        phoneNumber: mobileNumber,
        navigateToScreen: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Otp(
                      phoneNumber: mobileNumberController.text,
                    )),
          );
        },
      );
    }
  }

  getOtp(
      {required BuildContext context,
      required String phoneNumber,
      required Function navigateToScreen}) async {
    var response = await PostApiController().login(context, "SendOtp",
        "SendOtp", "@USerMobile='$phoneNumber'", "", "", navigateToScreen);
  }
}
