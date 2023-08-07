import 'dart:convert';

import 'package:eventin/constants/theme.dart';
import 'package:eventin/controllers/postApiController.dart';
import 'package:eventin/controllers/profile_repository.dart';
import 'package:eventin/view/event_list.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as dartPath;
import '../widgets/dark_blue_button copy.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  RegExp digitValidator = RegExp("[0-9]+");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _contactNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _companyNameController = TextEditingController();
  TextEditingController _personNameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _aboutCompanyController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  File? _selectedImage;
  final ImagePicker imagePicker = ImagePicker();
  var base64Image;

  var profileData;
  int compId = 0;

  void _selectImage() {
    // Implement your logic for selecting an image from the gallery or camera
    // and assign it to the '_selectedImage' variable.
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    var response = await ProfileRespository().getProfileData();
    profileData = response.data[0];
    if (profileData != null) {
      _companyNameController.text = profileData.compname.toString();
      _personNameController.text = profileData.username.toString();
      _emailController.text = profileData.email.toString();
      _mobileController.text = profileData.mobile.toString();
      _aboutCompanyController.text = profileData.about.toString();
      _addressController.text = profileData.compadrs.toString();
      compId = profileData.compIdNo;
    }
    setState(() {});
  }

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

  void _saveProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userToken = prefs.getString('token');
    var userId = prefs.getString('userId');
    int uId = int.parse(userId ?? "0");
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

      saveCompany(
        context: context,
        companyId: compId,
        companyName: companyName,
        companyAbout: aboutCompany,
        companyAddress: address,
        userName: personName,
        userEmail: email,
        userMobile: mobileNumber,
        userIdNo: uId,
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
  }

  saveCompany({
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
        "@CompIdNo=$companyId,@CompName='$companyName',@CompAbout='$companyAbout',@CompAdrs='$companyAddress',@UserName ='$userName',@UserEmail='$userEmail',@UserMobile='$userMobile',@UserIdNo=$userIdNo",
        "${_selectedImage == null ? '' : base64Image}",
        "${_selectedImage == null ? '' : dartPath.extension(_selectedImage!.path)}",
        navigateToScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!) as ImageProvider<Object>
                      : AssetImage('assets/default_avatar.png'),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: MyTheme.primaryColor),
                    child: IconButton(
                      icon: Icon(
                        Icons.edit,
                        size: 20,
                      ),
                      onPressed: () async {
                        await _showPicker(context);
                        setState(
                          () {},
                        );
                      },
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Form(
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
                  BlueButton(onPressed: _saveProfile, title: 'Save'),
                  // SizedBox(height: 20),
                  // isSignedIn
                  //     ? BlueButton(onPressed: _navigateToEventList, title: 'Event List')
                  //     : SizedBox.shrink()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showPicker(context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select an option'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Row(
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 28,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Take a picture',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  onTap: () async {
                    pickImage(ImageSource.camera).whenComplete(() => {
                          Navigator.pop(context),
                        });
                  },
                ),
                SizedBox(height: 8),
                GestureDetector(
                  child: Row(
                    children: [
                      Icon(
                        Icons.photo_library,
                        size: 28,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Choose from gallery',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  onTap: () async {
                    pickImage(ImageSource.gallery).whenComplete(() => {
                          Navigator.pop(context),
                        });
                  },
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) => setState(() {}));
  }

  Future pickImage(ImageSource source) async {
    try {
      final pickedImage = await imagePicker.pickImage(
        source: source,
        imageQuality: 20,
      );
      if (pickedImage != null) {
        setState(() {
          _selectedImage = File(pickedImage.path);
          var imageBytes = _selectedImage!.readAsBytesSync();
          base64Image = base64Encode(imageBytes);
          // _compressImage(selectedImage);
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
