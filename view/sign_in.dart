import 'package:eventin/controllers/event_list_controller.dart';
import 'package:eventin/controllers/get_event_List_conntroller.dart';
import 'package:eventin/controllers/postApiController.dart';
import 'package:eventin/view/event_list.dart';
import 'package:eventin/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  /// V E R I F Y   O T P
  void _verifyMobileNumber() {
    String mobileNumber = mobileNumberController.text;
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

  /// G E T   O T P
  void _getOtp() {
    String mobileNumber = mobileNumberController.text;

    if (mobileNumber.length != 10) {
      return; // Do nothing if the input length is invalid
    }

    getOtp(
      context: context,
      phoneNumber: mobileNumber,
      navigateToScreen: () {},
    );
  }

  getOtp(
      {required BuildContext context,
      required String phoneNumber,
      required Function navigateToScreen}) async {
    var response = await PostApiController().postApi(context, "SendOtp",
        "SendOtp", "@USerMobile='$phoneNumber'", "", "", navigateToScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Sign In'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (Route<dynamic> route) => false,
            );
          },
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sign In with Mobile Number',
              style: GoogleFonts.manrope(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: mobileNumberController,
              keyboardType: TextInputType.phone,
              maxLength: 10, // Set the maximum length for phone number input
              decoration: InputDecoration(
                labelText: 'Mobile Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getOtp,
              child: Text('Send OTP'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6, // Set the maximum length for OTP input
              decoration: InputDecoration(
                labelText: 'OTP',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyMobileNumber,
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
