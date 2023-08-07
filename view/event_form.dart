import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:eventin/view/map_location.dart';
import 'package:path/path.dart' as dartPath;
import 'package:eventin/constants/constants.dart';
import 'package:eventin/controllers/postApiController.dart';
import 'package:eventin/services/open_maps.dart';
import 'package:eventin/view/event_details.dart';
import 'package:eventin/view/event_list.dart';
import 'package:eventin/widgets/dark_blue_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../constants/theme.dart';

class EventFormScreen extends StatefulWidget {
  @override
  _EventFormScreenState createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  TextEditingController eventNameController = TextEditingController();
  TextEditingController eventDateFromController = TextEditingController();
  TextEditingController eventDateToController = TextEditingController();
  TextEditingController eventTimeFromController = TextEditingController();
  TextEditingController eventTimeToController = TextEditingController();
  TextEditingController eventAddressController = TextEditingController();
  TextEditingController eventDescriptionController = TextEditingController();
  TextEditingController eventLocationController = TextEditingController();
  TextEditingController eventDateRangeController = TextEditingController();
  double eventLatitude = 0;
  double eventLongitude = 0;
  String eventlocation = "Event Location";
  bool isLocationSelected = false;
  DateTimeRange dateRange = DateTimeRange(
      start: DateTime.now(), end: DateTime.now().add(Duration(days: 1)));
  DateTime? _selectedTimeFrom;
  DateTime? _selectedTimeTo;
  String formattedTime = '';
  List<XFile>? _imagesFileList = [];
  final ImagePicker imagePicker = ImagePicker();
  String imageBase64 = '';
  String imageExtension = '';

  @override
  void initState() {
    _checkLocationPermission();
    super.initState();
  }

  Future _selectEventDate() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (newDateRange == null) return;
    setState(() {
      dateRange = newDateRange;
      final start = dateRange.start;
      final end = dateRange.end;
      eventDateFromController.text = start.toString().split(" ").first;
      eventDateToController.text = end.toString().split(" ").first;
      eventDateRangeController.text =
          "${formatDate(eventDateFromController.text)} to ${formatDate(eventDateFromController.text)}";
      print(eventDateRangeController.text);
    });
  }

  void _selectTimeFrom() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      _selectedTimeFrom = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        pickedTime.hour,
        pickedTime.minute,
      );
      setState(() {});

      DateTime? dateTime = _selectedTimeFrom;

      formattedTime = DateFormat("hh:mm a").format(dateTime!);
      eventTimeFromController.text = formattedTime;
    }
  }

  void _selectTimeTo() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      _selectedTimeTo = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        pickedTime.hour,
        pickedTime.minute,
      );
      setState(() {});

      DateTime? dateTime = _selectedTimeTo;

      formattedTime = DateFormat("hh:mm a").format(dateTime!);
      eventTimeToController.text = formattedTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Event Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFormField(
              controller: eventNameController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Event Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: eventDateRangeController,
              onTap: _selectEventDate,
              textInputAction: TextInputAction.next,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Event Date',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: eventTimeFromController,
              textInputAction: TextInputAction.next,
              onTap: _selectTimeFrom,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Event Time From',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: eventTimeToController,
              textInputAction: TextInputAction.next,
              onTap: _selectTimeTo,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Event Time To',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: eventAddressController,
              maxLines: 3,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Event Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: eventDescriptionController,
              textInputAction: TextInputAction.next,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Event Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  _getLatLong();
                  isLocationSelected = true;
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 20),
                        child: Text(
                          eventlocation,
                          style: TextStyle(
                              fontSize: 16.0, color: Colors.grey[600]),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Icon(
                        Icons.location_on,
                        color: MyTheme.secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                print(_imagesFileList!.length);

                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Upload Document'),
                    actions: [
                      SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue),
                              onPressed: () {
                                Navigator.pop(context);
                                selectImage(ImageSource.camera);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 28,
                                  ),
                                  Text(
                                    'Take a picture',
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue),
                              onPressed: () {
                                selectImage(ImageSource.gallery);

                                Navigator.pop(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.photo_library,
                                    size: 28,
                                  ),
                                  Text(
                                    'Choose from gallery',
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
              child: Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      width: 1.0,
                      color: Colors.grey,
                    ),
                    right: BorderSide(
                      width: 1.0,
                      color: Colors.grey,
                    ),
                    top: BorderSide(
                      width: 1.0,
                      color: Colors.grey,
                    ),
                    bottom: BorderSide(
                      width: 1.0,
                      color: Colors.grey,
                    ),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(3.0),
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Event Photo ',
                        style: GoogleFonts.manrope(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600]),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.image,
                        color: MyTheme.secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            _imagesFileList!.isEmpty
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 20,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.grey.shade200,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(_imagesFileList![0].path),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
            SizedBox(height: 16),
            BlueButton(
              onPressed: () {
                String eventName = eventNameController.text;
                String eventDateFrom = eventDateFromController.text;
                String eventDateTo = eventDateToController.text;
                String eventTimeFrom = eventTimeFromController.text;
                String eventTimeTo = eventTimeToController.text;
                String eventAddress = eventAddressController.text;
                String eventDescription = eventDescriptionController.text;
                String eventLocation = eventLocationController.text;

                if (isLocationSelected) {
                  saveEvent(
                      context: context,
                      eventIdNumber: 0,
                      eventName: eventName,
                      eventDateFrom: eventDateFrom,
                      eventDateTo: eventDateTo,
                      eventTimeFrom: eventTimeFrom,
                      eventTimeTo: eventTimeTo,
                      eventAddress: eventAddress,
                      eventAbout: eventDescription,
                      eventLatitude: double.parse(
                          eventLocationController.text.split(", ").first),
                      eventLongitude: double.parse(
                          eventLocationController.text.split(", ").last),
                      navigateToScreen: () {},
                      imageBase64: imageBase64,
                      imageExtension: imageExtension);
                } else {
                  showTopSnackBar(
                    dismissType: DismissType.onTap,
                    displayDuration: const Duration(seconds: 2),
                    context,
                    CustomSnackBar.success(
                      message: 'Please select location',
                    ),
                  );
                }
              },
              title: 'Save',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkLocationPermission() async {
    final status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
  }

  Future<void> _getLatLong() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      eventLatitude = await position.latitude;
      eventLongitude = await position.longitude;

      print(eventLatitude);
      print(eventLongitude);
      GetAddress result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MapLocation(lat: eventLatitude, lng: eventLongitude),
        ),
      );
      print(result.lat);
      eventLatitude = double.parse(result.lat);
      eventLongitude = double.parse(result.lng);
      eventLocationController.text = result.lat + ', ' + result.lng;
      eventlocation = eventLocationController.text;
      print(eventlocation);
      // MapUtils.openMap(eventLatitude, eventLongitude);
      // eventLocationController.text =
      //     eventLatitude.toString() + ", " + eventLongitude.toString();
      // eventlocation = eventLocationController.text;
      setState(() {});
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  saveEvent({
    required BuildContext context,
    required int eventIdNumber,
    required String eventName,
    required String eventDateFrom,
    required String eventDateTo,
    required String eventTimeFrom,
    required String eventTimeTo,
    required String eventAddress,
    required String eventAbout,
    required double eventLatitude,
    required double eventLongitude,
    required Function navigateToScreen,
    required String imageBase64,
    required String imageExtension,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId') ?? "0";
    var response = await PostApiController().eventForm(
      context,
      "SaveEvent",
      "SaveEvent",
      "@EventIdno =$eventIdNumber,@EventName='$eventName',@EventDtFrom='$eventDateFrom',@EventDtTo='$eventDateTo',@EventTmFrom='$eventTimeFrom',@EventTmTo='$eventTimeTo',@EventAdrs='$eventAddress',@EventAbout='$eventAbout',@EventLat='$eventLatitude',@EventLong='$eventLongitude',@UserIdNo = $userId",
      "$imageBase64",
      "$imageExtension",
      eventName,
      eventLatitude.toString(),
      eventLongitude.toString(),
      navigateToScreen,
    );
  }

  void selectImage(ImageSource source) async {
    final XFile? selectedImage = await imagePicker.pickImage(source: source);
    if (selectedImage != null) {
      if (_imagesFileList!.isEmpty) {
        _imagesFileList!.add(selectedImage);
        Uint8List imageBytes = await _imagesFileList![0].readAsBytes();
        imageBase64 = base64.encode(imageBytes);
        imageExtension = dartPath.extension(_imagesFileList![0].path);
      } else {
        _imagesFileList![0] = selectedImage;
        Uint8List imageBytes = await _imagesFileList![0].readAsBytes();
        imageBase64 = base64.encode(imageBytes);
        imageExtension = dartPath.extension(_imagesFileList![0].path);
      }
      setState(() {});
    }
  }
}
