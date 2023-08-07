import 'package:eventin/controllers/guestType_controller.dart';
import 'package:eventin/controllers/postApiController.dart';
import 'package:eventin/view/event_details.dart';
import 'package:eventin/view/event_list.dart';
import 'package:eventin/view/get_guest_list.dart';
import 'package:eventin/view/get_volunteer_list.dart';
import 'package:eventin/view/qr_generator_screen.dart';
import 'package:eventin/widgets/dark_blue_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class EditParticipantScreen extends StatefulWidget {
  String eventName;
  int eventIdNo;
  int guestIdNo;
  int guestTypeIdNo;
  String name;
  String mobileNo;
  String email;
  String address;
  String paidAmount;
  String companyName;
  String guestType;
  EditParticipantScreen(
      {required this.eventName,
      required this.eventIdNo,
      required this.guestIdNo,
      required this.guestTypeIdNo,
      required this.name,
      required this.mobileNo,
      required this.email,
      required this.address,
      required this.paidAmount,
      required this.guestType,
      required this.companyName});
  @override
  _EditParticipantScreenState createState() => _EditParticipantScreenState();
}

class _EditParticipantScreenState extends State<EditParticipantScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  String? participantType;
  String? paymentType;
  bool isCashSelected = false;
  int sGuestType = 0;
  int guestId = 0;
  List<String> participantOptions = [];
  List guestType = [];

  @override
  void initState() {
    // TODO: implement initState
    _nameController.text = widget.name;
    _emailController.text = widget.email;
    _mobileController.text = widget.mobileNo;
    _amountController.text = widget.paidAmount;
    _addressController.text = widget.address;
    _cityController.text = widget.companyName;
    participantType = widget.guestType;
    sGuestType = widget.guestTypeIdNo;
    guestId = widget.guestIdNo;
    getData();
    super.initState();
  }

  getData() async {
    guestType = [];
    participantOptions = [];
    var response = await GuestType().getGuestTypeList();
    guestType.addAll(response.data);
    for (int i = 0; i < guestType.length; i++) {
      participantOptions.add(guestType[i].guesttypename);
      setState(() {});
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _amountController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _saveParticipant() {
    if (!isCashSelected) {
      showTopSnackBar(
        dismissType: DismissType.onTap,
        displayDuration: const Duration(seconds: 2),
        context,
        CustomSnackBar.info(
          message: 'Please fill all data',
        ),
      );
    } else {
      if (_formKey.currentState!.validate()) {
        // Perform saving logic here

        // Get the form values
        String name = _nameController.text;
        String email = _emailController.text;
        String mobile = _mobileController.text;
        double amount = double.parse(_amountController.text);
        String address = _addressController.text;
        String city = _cityController.text;

        // Print the form values
        print('Name: $name');
        print('Email: $email');
        print('Mobile: $mobile');
        print('Amount: $amount');
        print('Address: $address');
        print('City: $city');
        print('Participant Type: $participantType');
        print('Payment Type: $paymentType');

        // Clear the form fields
        // _nameController.clear();
        // _emailController.clear();
        // _mobileController.clear();
        // _amountController.clear();
        // _addressController.clear();
        // _cityController.clear();

        // Show a success message or navigate to another screen
        saveGuest(
          context: context,
          guestIdNumber: guestId,
          guestTypeIdNumber: sGuestType,
          guestName: name,
          guestMobile: mobile,
          guestEmail: email,
          guestAddress: address,
          guestCity: city,
          guestPaidAmount: amount,
          eventIdNumber: widget.eventIdNo,
          navigateToScreen: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => QrScreen(
                        eventIdNo: widget.eventIdNo,
                        eventName: widget.eventName,
                        guestId: guestId,
                      )),
            );
          },
        );
      }
    }
  }

  saveGuest({
    required BuildContext context,
    required int guestIdNumber,
    required int guestTypeIdNumber,
    required String guestName,
    required String guestMobile,
    required String guestEmail,
    required String guestAddress,
    required String guestCity,
    required double guestPaidAmount,
    required int eventIdNumber,
    required Function navigateToScreen,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId') ?? "";
    var response = await PostApiController().postApi(
      context,
      "SaveGuest",
      "SaveGuest",
      "@GuestIdno=$guestIdNumber,@GuestTypeIdno=$guestTypeIdNumber,@GuestName='$guestName',@GuestMobile='$guestMobile',@GuestEmail='$guestEmail',@GuestAdrs='$guestAddress',@GuestCity='$guestCity',@GuestPaidAmt=$guestPaidAmount,@EventIdNo=$eventIdNumber,@LoginUserIdNo=$userId",
      "",
      "",
      navigateToScreen,
    );
  }

  List<Widget> buildRadioButtons(List<String> options) {
    return options.map((option) {
      return Row(
        children: [
          Radio<String>(
            value: option,
            groupValue: participantType,
            onChanged: (value) {
              setState(() {
                participantType = value;
                for (int i = 0; i < guestType.length; i++) {
                  if (guestType[i].guesttypename == value) {
                    sGuestType = guestType[i].guesttypeidno;
                  }
                }
                print(sGuestType);
              });
            },
          ),
          Text(option),
        ],
      );
    }).toList();
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
                  builder: (context) => GuestListScreen(
                    eventId: widget.eventIdNo,
                    eventName: widget.eventName,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 5,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Edit Guest",
                style: GoogleFonts.manrope(
                    fontSize: 24, fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Text('Select Guest Type'),
                  value: participantType,
                  onChanged: (newValue) {
                    setState(() {
                      participantType = newValue;
                      participantType = newValue.toString();
                      for (int i = 0; i < guestType.length; i++) {
                        if (guestType[i].guesttypename == newValue.toString()) {
                          sGuestType = guestType[i].guesttypeidno;
                        }
                      }
                      print(sGuestType);
                    });
                  },
                  items: participantOptions.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24.0,
                  isExpanded: true,
                ),
              ),
            ),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Column(
            //       children: buildRadioButtons(participantOptions),
            //     ),
            //   ],
            // ),
            SizedBox(height: 16.0),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
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
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a city';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _amountController,
                    onTap: () {
                      if (_amountController.text.isNotEmpty) {
                        isCashSelected = true;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an amount';
                      }
                      // Add amount validation logic if required
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Cash',
                        groupValue: paymentType,
                        onChanged: (value) {
                          setState(() {
                            paymentType = value;
                            isCashSelected = true;
                          });
                        },
                      ),
                      Text('Cash'),
                      SizedBox(width: 16.0),
                      Radio<String>(
                        value: 'Invited',
                        groupValue: paymentType,
                        onChanged: (value) {
                          setState(() {
                            paymentType = value;
                            isCashSelected = true;
                          });
                        },
                      ),
                      Text('Invited'),
                    ],
                  ),
                  SizedBox(height: 24.0),
                  BlueButton(
                    onPressed: _saveParticipant,
                    title: 'Save',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
