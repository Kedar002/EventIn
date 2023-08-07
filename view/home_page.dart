import 'dart:async';

import 'package:eventin/constants/theme.dart';
import 'package:eventin/controllers/postApiController.dart';
import 'package:eventin/view/event_list.dart';
import 'package:eventin/view/login.dart';
import 'package:eventin/view/sign_in.dart';
import 'package:eventin/widgets/dark_blue_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

List applicationNamesList = [];
final PageController _imagepageController =
    PageController(viewportFraction: 1.0);
int activePageIndex = 0;
List bloodGroupList = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
List genderList = [
  'Male',
  'Female',
  'Other',
];

String? gender;
String? bloodGroup;
final TextEditingController mobileNumberController = TextEditingController();
final TextEditingController nameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController dobController = TextEditingController();
bool isANumber = true;
bool isSignedIn = false;
RegExp digitValidator = RegExp("[0-9]+");

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 2), (timer) {
      // Use Timer.periodic to scroll automatically after every 2 seconds
      if (_imagepageController.hasClients) {
        // Check if PageController hasClients to avoid errors
        if (activePageIndex < 3 - 1) {
          // Check if activePageIndex is not the last index
          activePageIndex++;
        } else {
          activePageIndex = 0;
        }
        _imagepageController.animateToPage(
          activePageIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
    isUserSignedIn();
    super.initState();
  }

  isUserSignedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');
    isSignedIn =
        userId == "0" || userId == "null" || userId == "" || userId == null
            ? false
            : true;
    setState(() {});
    print(userId);
    print(isSignedIn);
  }

  void clearSharedPreferences(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    await prefs.remove('userName');
    await prefs.remove('userId');
    print("signedOut");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Login(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xff0C5CBA),
      backgroundColor: MyTheme.secondaryColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'eventin',
                    style: GoogleFonts.manrope(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: MyTheme.white),
                        onPressed: () {
                          isSignedIn
                              ? clearSharedPreferences(context)
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Login(),
                                  ),
                                );
                        },
                        child: isSignedIn
                            ? Text(
                                'Sign Out',
                                style: GoogleFonts.manrope(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: MyTheme.primaryColor,
                                ),
                              )
                            : Text(
                                'Sign In',
                                style: GoogleFonts.manrope(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: MyTheme.primaryColor,
                                ),
                              )),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  color: Colors.white),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Register Your Company',
                      style: GoogleFonts.manrope(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    RegistrationForm(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setValidator(valid) {
    setState(() {
      isANumber = valid;
    });
  }
}

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _companyNameController = TextEditingController();
  TextEditingController _personNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _aboutCompanyController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _companyNameController.dispose();
    _personNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _aboutCompanyController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      String companyName = _companyNameController.text;
      String personName = _personNameController.text;
      String email = _emailController.text;
      String mobileNumber = _mobileController.text;
      String aboutCompany = _aboutCompanyController.text;
      String address = _addressController.text;

      // Print the form data
      print('Company Name: $companyName');
      print('Person Name: $personName');
      print('Email: $email');
      print('Mobile Number: $mobileNumber');
      print('About Company: $aboutCompany');
      print('Address: $address');

      registerCompany(
        context: context,
        companyId: 0,
        companyName: companyName,
        companyAbout: aboutCompany,
        companyAddress: address,
        userName: personName,
        userEmail: email,
        userMobile: mobileNumber,
        userIdNo: 0,
        navigateToScreen: () {
          !isSignedIn
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                )
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventListScreen(),
                  ),
                );
        },
      );
    }
  }

  registerCompany({
    required BuildContext context,
    required int companyId,
    required String companyName,
    required String companyAbout,
    required String companyAddress,
    required String userName,
    required String userEmail,
    required String userMobile,
    required int userIdNo,
    required Function navigateToScreen,
  }) async {
    var response = await PostApiController().postApi(
        context,
        "SaveComp",
        "SaveComp",
        "@CompIdNo=$companyId,@CompName='$companyName',@CompAbout='$companyAbout',@CompAdrs='$companyAddress',@UserName='$userName',@UserEmail='$userEmail',@UserMobile='$userMobile',@UserIdNo=$userIdNo",
        "",
        "",
        navigateToScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _companyNameController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Company Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter company name';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _personNameController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Person Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a person name';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _emailController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Email ID',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter email ID';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _mobileController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Mobile Number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter mobile number';
              }
              if (!digitValidator.hasMatch(value)) {
                return 'Please enter a valid mobile number';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _aboutCompanyController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'About Your Company',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter information about your company';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _addressController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Company Address',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter company address';
              }
              return null;
            },
          ),
          SizedBox(height: 30),
          BlueButton(onPressed: _register, title: 'Register Company'),
          // SizedBox(height: 20),
          // isSignedIn
          //     ? BlueButton(onPressed: _navigateToEventList, title: 'Event List')
          //     : SizedBox.shrink()
        ],
      ),
    );
  }

  _navigateToEventList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventListScreen(),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
