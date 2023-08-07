import 'package:eventin/controllers/postApiController.dart';
import 'package:eventin/controllers/volunteer_list_controller.dart';
import 'package:eventin/view/event_details.dart';
import 'package:eventin/view/get_volunteer_list.dart';
import 'package:eventin/view/home_page.dart';
import 'package:eventin/widgets/dark_blue_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddVolunteerScreen extends StatefulWidget {
  String eventName;
  int eventIdNo;
  String lat;
  String long;
  AddVolunteerScreen(
      {required this.eventName,
      required this.eventIdNo,
      required this.lat,
      required this.long});
  @override
  _AddVolunteerScreenState createState() => _AddVolunteerScreenState();
}

class _AddVolunteerScreenState extends State<AddVolunteerScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _designationController.dispose();
    super.dispose();
  }

  void getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // var userToken = prefs.getString('token');
    var userId = prefs.getString('userId') ?? "";
    print(userId);
  }

  void _saveVolunteer() {
    if (_formKey.currentState!.validate()) {
      // Perform saving logic here

      // Get the form values
      String name = _nameController.text;
      String email = _emailController.text;
      String mobile = _mobileController.text;
      String designation = _designationController.text;

      // Print the form values
      print('Name: $name');
      print('Email: $email');
      print('Mobile: $mobile');
      print('Designation: $designation');

      // Clear the form fields
      // _nameController.clear();
      // _emailController.clear();
      // _mobileController.clear();
      // _designationController.clear();

      // Show a success message or navigate to another screen
      saveVolunteer(
        context: context,
        volunteerIdNumber: 0,
        userType: 'VOLUNTEER',
        volunteerName: name,
        volunteerEmail: email,
        volunteerMobile: mobile,
        eventIdNumber: widget.eventIdNo,
        navigateToScreen: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => EventDetailsScreen(
                      eventIdno: widget.eventIdNo,
                      eventName: widget.eventName,
                      lat: widget.lat,
                      long: widget.long,
                    )),
            (Route<dynamic> route) => false,
          );
        },
      );
    }
  }

  saveVolunteer({
    required BuildContext context,
    required int volunteerIdNumber,
    required String userType,
    required String volunteerName,
    required String volunteerEmail,
    required String volunteerMobile,
    required int eventIdNumber,
    required Function navigateToScreen,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId') ?? "";
    var response = await PostApiController().postApi(
      context,
      "SaveVolunteer",
      "SaveVolunteer",
      "@VolunteerIdNo=$volunteerIdNumber,@UserType='$userType',@VolunteerName='$volunteerName',@VolunteerEMail='$volunteerEmail',@VolunteerMobile='$volunteerMobile',@EventIdNo=$eventIdNumber,@LoginUserIdNo=$userId",
      "",
      "",
      navigateToScreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.eventName),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VolunteerListScreen(
                    eventId: widget.eventIdNo,
                    eventName: widget.eventName,
                    lat: widget.lat,
                    long: widget.long,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            "Add Volunteer",
            style:
                GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an email';
                      }
                      // Add email validation logic if required
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _mobileController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Mobile',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a mobile number';
                      }
                      // Add mobile number validation logic if required
                      return null;
                    },
                  ),
                  // SizedBox(height: 16.0),
                  // TextFormField(
                  //   controller: _designationController,
                  //   decoration: InputDecoration(labelText: 'Designation'),
                  //   validator: (value) {
                  //     if (value!.isEmpty) {
                  //       return 'Please enter a designation';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  SizedBox(height: 24.0),
                  BlueButton(
                    onPressed: _saveVolunteer,
                    title: 'Save',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Note : Volunteer will be notified by SMS.\nVolunteer should download app from Playstore and Login with the registered mobile number. ',
                    style:
                        GoogleFonts.manrope(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
