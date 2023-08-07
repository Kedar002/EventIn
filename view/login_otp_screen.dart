// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:async';

import 'package:eventin/constants/theme.dart';
import 'package:eventin/controllers/postApiController.dart';
import 'package:eventin/view/event_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../widgets/dark_blue_button.dart';

// import 'package:internet_popup/internet_popup.dart';

class Otp extends StatefulWidget {
  final String phoneNumber;
  Otp({required this.phoneNumber});
  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  // ConstantImages constant = ConstantImages();
  TextEditingController otpController = TextEditingController();
  String currentText = "";

  // late StreamSubscription internetCheck;
  // bool isDeviceConnected = false;

  int selectedValue = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.secondaryColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: false,
        child: Container(
          height: MediaQuery.of(context).size.height * 1,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40.0),
              ),
              color: Colors.white),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    }, // Handle your on tap here.
                    icon: Icon(Icons.arrow_back_ios)),
                SizedBox(
                  height: 25,
                ),
                Text(
                  'Enter authentication code',
                  style: GoogleFonts.manrope(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff112950)),
                ),
                SizedBox(
                  height: 4,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            'Enter the 6-digit that we have sent via the phone number',
                        style: GoogleFonts.manrope(
                            fontSize: 14,
                            color: Color(0xffB7BFCA),
                            height: 1.5),
                      ),
                      TextSpan(
                        text: ' +${widget.phoneNumber}',
                        style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff0C5CBA)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
                PinCodeTextField(
                  keyboardType: TextInputType.number,
                  textStyle: GoogleFonts.manrope(
                    fontSize: 32,
                    color: Color(0xff112950),
                  ),
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    inactiveColor: Color(0xffB7BFCA),
                    activeColor: Color(0xff0C5CBA),
                    shape: PinCodeFieldShape.underline,
                    fieldHeight: 50,
                    fieldWidth: 50,
                    // activeFillColor: Color(0xff0C5CBA),
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.white,
                  // enableActiveFill: true,
                  controller: otpController,
                  onCompleted: (v) {
                    debugPrint("Completed");
                  },
                  onChanged: (value) {
                    debugPrint(value);
                    setState(() {
                      currentText = value;
                    });
                  },
                  beforeTextPaste: (text) {
                    return true;
                  },
                  appContext: context,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Don\'t have a code?',
                      style: GoogleFonts.manrope(
                          fontSize: 15, color: Color(0xff112950)),
                    ),
                    TextButton(
                      onPressed: () {
                        _resendOtp();
                      },
                      child: Text(
                        ' Re-send',
                        style: GoogleFonts.manrope(
                            decoration: TextDecoration.underline,
                            decorationThickness: 2,
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: Color(0xff0C5CBA)),
                      ),
                    ),
                    Spacer(),
                    // Text(
                    //   '01:58',
                    //   style: GoogleFonts.manrope(
                    //       fontWeight: FontWeight.w600,
                    //       fontSize: 15,
                    //       color: Color(0xff112950)),
                    // ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 60.0, bottom: 16),
                  child: BlueButton(
                    onPressed: _verifyMobileNumber,
                    title: 'Login',
                  ),
                ),
                Center(
                  child: Text(
                    '*Terms & Conditions Applied',
                    style: GoogleFonts.manrope(
                        fontSize: 14, color: Color(0xffB7BFCA), height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _verifyMobileNumber() {
    String mobileNumber = widget.phoneNumber;
    String otp = otpController.text;

    if (mobileNumber.length != 10 || otp.length != 6) {
      return; // Do nothing if the input lengths are invalid
    }

    verify(
      context: context,
      phoneNumber: mobileNumber,
      otp: otp,
      navigateToScreen: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventListScreen(),
          ),
        );
      },
    );
  }

  verify(
      {required BuildContext context,
      required String phoneNumber,
      required String otp,
      required Function navigateToScreen}) async {
    var response = await PostApiController().signInPostApi(
        context,
        "VerifyOtp",
        "VerifyOtp",
        "@Otp='$otp',@UserMobile='$phoneNumber'",
        "",
        "",
        navigateToScreen);
  }

  void _resendOtp() {
    resendOtp(
      context: context,
      phoneNumber: widget.phoneNumber,
      navigateToScreen: () {},
    );
  }

  resendOtp(
      {required BuildContext context,
      required String phoneNumber,
      required Function navigateToScreen}) async {
    var response = await PostApiController().login(context, "SendOtp",
        "SendOtp", "@USerMobile='$phoneNumber'", "", "", navigateToScreen);
  }
}
