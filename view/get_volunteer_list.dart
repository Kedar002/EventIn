import 'package:eventin/controllers/volunteer_list_controller.dart';
import 'package:eventin/view/edit_volunteer.dart';
import 'package:eventin/view/qr_generator_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class VolunteerListScreen extends StatefulWidget {
  final int eventId;
  final String eventName;
  final String lat;
  final String long;
  VolunteerListScreen(
      {required this.eventId,
      required this.eventName,
      required this.lat,
      required this.long});

  @override
  _VolunteerListScreenState createState() => _VolunteerListScreenState();
}

class _VolunteerListScreenState extends State<VolunteerListScreen> {
  List volunteerList = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    volunteerList = [];
    var response =
        await VolunteerList().getVolunteerList(eventId: widget.eventId);
    volunteerList.addAll(response.data);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.eventName),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              "Volunteer List",
              style: GoogleFonts.manrope(
                  fontSize: 24, fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: volunteerList.length,
              itemBuilder: (context, index) {
                final volunteer = volunteerList[index];
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      volunteer.volunteerName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: GestureDetector(
                        onTap: () async {
                          await canLaunch('tel: ${volunteer.volunteerMobile}')
                              ? await launch(
                                  'tel: ${volunteer.volunteerMobile}')
                              : throw 'Could not launch';
                        },
                        // onTap: () {
                        //   _makePhoneCall(volunteer.volunteerMobile.toString());
                        // },
                        child: Text(volunteer.volunteerMobile)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _editVolunteer(index);
                          },
                        ),
                        // IconButton(
                        //   icon: Icon(Icons.share),
                        //   onPressed: () {
                        //     _shareVolunteer(index);
                        //   },
                        // ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _editVolunteer(int index) {
    final volunteer = volunteerList[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditVolunteerScreen(
          eventIdNo: widget.eventId,
          eventName: widget.eventName,
          Name: volunteer.volunteerName,
          email: volunteer.volunteerEMail,
          mobileNo: volunteer.volunteerMobile,
          volIdNo: volunteer.volunteerIdNo,
          lat: '',
          long: '',
        ),
      ),
    );
  }

  void _shareVolunteer(int index) {
    final volunteer = volunteerList[index];
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => QrScreen(
                eventIdNo: widget.eventId,
                eventName: widget.eventName,
                guestId: volunteer.volunteerIdNo,
              )),
    );
  }

  _makePhoneCall(String phoneNumber) async {
    await FlutterPhoneDirectCaller.callNumber(phoneNumber);
  }
}
