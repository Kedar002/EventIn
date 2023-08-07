import 'package:eventin/controllers/guestType_controller.dart';
import 'package:eventin/controllers/postApiController.dart';
import 'package:eventin/view/event_details.dart';
import 'package:eventin/view/event_list.dart';
import 'package:eventin/view/get_guest_list.dart';
import 'package:eventin/view/get_volunteer_list.dart';
import 'package:eventin/view/qr_generator_screen.dart';
import 'package:eventin/widgets/dark_blue_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AddParticipantScreen extends StatefulWidget {
  String eventName;
  int eventIdNo;
  AddParticipantScreen({required this.eventName, required this.eventIdNo});
  @override
  _AddParticipantScreenState createState() => _AddParticipantScreenState();
}

class _AddParticipantScreenState extends State<AddParticipantScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  String? participantType;
  String? paymentType;
  int sGuestType = 0;
  List<String> participantOptions = [];
  List guestType = [];

  // List<String> _dropdownItems = [
  //   'Item 1',
  //   'Item 2',
  //   'Item 3',
  //   'Item 4',
  //   'Item 5',
  // ];

  @override
  void initState() {
    // TODO: implement initState
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
    if (_amountController.text.isEmpty && paymentType == "Cash") {
      showTopSnackBar(
        dismissType: DismissType.onTap,
        displayDuration: const Duration(seconds: 2),
        context,
        CustomSnackBar.info(
          message: 'Please enter amount',
        ),
      );
    } else {
      if (_formKey.currentState!.validate()) {
        // Perform saving logic here

        // Get the form values
        String name = _nameController.text;
        String email = _emailController.text;
        String mobile = _mobileController.text;
        double amount = _amountController.text.isEmpty
            ? 0
            : double.parse(_amountController.text);
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
          guestIdNumber: 0,
          guestTypeIdNumber: sGuestType,
          guestName: name,
          guestMobile: mobile,
          guestEmail: email,
          guestAddress: address,
          guestCity: city,
          guestPaidAmount: amount,
          eventIdNumber: widget.eventIdNo,
          navigateToScreen: () {},
          eventIdno: widget.eventIdNo,
          eventName: widget.eventName,
        );
      }
    }
  }

  bool _isEmailValid(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
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
    required int eventIdno,
    required String eventName,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId') ?? "";
    var response = await PostApiController().shareQr(
      context,
      "SaveGuest",
      "SaveGuest",
      "@GuestIdno=$guestIdNumber,@GuestTypeIdno=$guestTypeIdNumber,@GuestName='$guestName',@GuestMobile='$guestMobile',@GuestEmail='$guestEmail',@GuestAdrs='$guestAddress',@GuestCity='$guestCity',@GuestPaidAmt=$guestPaidAmount,@EventIdNo=$eventIdNumber,@LoginUserIdNo=$userId",
      "",
      "",
      navigateToScreen,
      eventName,
      eventIdno,
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
                "Add Guest",
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
                  Form(
                    autovalidateMode: AutovalidateMode.always,
                    child: TextFormField(
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
                        if (!_isEmailValid(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Form(
                    autovalidateMode: AutovalidateMode.always,
                    child: TextFormField(
                      controller: _mobileController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Mobile',
                        border: OutlineInputBorder(),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      maxLength: 10, // Restricts the input to 10 characters
                      // validator: (value) {
                      //   if (value?.length != 10) {
                      //     return 'Mobile number should be 10 digits long';
                      //   }
                      //   return null;
                      // },
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _addressController,
                    textInputAction: TextInputAction.next,
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
                    textInputAction: TextInputAction.next,
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
                  Form(
                    autovalidateMode: AutovalidateMode.always,
                    child: TextFormField(
                      controller: _amountController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder(),
                      ),
                    ),
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
                            print(paymentType);
                            // isCashSelected = true;
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
