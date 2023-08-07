import 'package:eventin/constants/theme.dart';
import 'package:eventin/view/add_participants.dart';
import 'package:eventin/view/add_volunteer.dart';
import 'package:eventin/view/dashboard.dart';
import 'package:eventin/view/event_list.dart';
import 'package:eventin/view/get_guest_list.dart';
import 'package:eventin/view/get_volunteer_list.dart';
import 'package:eventin/view/home_page.dart';
import 'package:eventin/view/lucky_draw.dart';
import 'package:eventin/view/qr_codeS_scanner.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventDetailsScreen extends StatefulWidget {
  String eventName;
  int eventIdno;
  String lat;
  String long;
  EventDetailsScreen(
      {required this.eventName,
      required this.eventIdno,
      required this.lat,
      required this.long});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.secondaryColor,
        elevation: 0,
        title: Text(widget.eventName),
        leading: GestureDetector(
          onTap: () {
            // Navigator.pushAndRemoveUntil(
            //   context,
            //   MaterialPageRoute(builder: (context) => HomePage()),
            //   (Route<dynamic> route) => false,
            // );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => EventListScreen()),
              (Route<dynamic> route) => false,
            );
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LuckyDraw(
                          eventID: widget.eventIdno,
                        )),
              );
            },
            icon: Icon(Icons.gamepad),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DashboardScreen(
                                    eventName: widget.eventName,
                                    eventIdNo: widget.eventIdno,
                                  )),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xff53B175).withOpacity(0.75),
                            borderRadius: BorderRadius.circular(15),
                            border:
                                Border.all(width: 2, color: Color(0xff53B175)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.dashboard_rounded,
                                  color: Colors.white,
                                  size: 60,
                                ),
                              ),
                              Text(
                                'Dashboard',
                                style: GoogleFonts.manrope(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QRScannerScreen(
                                    eventIdNo: widget.eventIdno,
                                    eventName: widget.eventName,
                                    eventLat: widget.lat,
                                    eventLong: widget.long,
                                  )),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 252, 174, 183),
                            border: Border.all(
                                width: 2,
                                color: Color.fromARGB(255, 250, 132, 146)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.qr_code_2_rounded,
                                  color: Colors.white,
                                  size: 60,
                                ),
                              ),
                              Text(
                                'Scan QR',
                                style: GoogleFonts.manrope(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddParticipantScreen(
                                    eventName: widget.eventName,
                                    eventIdNo: widget.eventIdno,
                                  )),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xff836AF6).withOpacity(0.55),
                            border: Border.all(
                                width: 2,
                                color: Color(0xff836AF6).withOpacity(0.75)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.person_add,
                                  color: Colors.white,
                                  size: 60,
                                ),
                              ),
                              Text(
                                'Add Guest',
                                style: GoogleFonts.manrope(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GuestListScreen(
                              eventId: widget.eventIdno,
                              eventName: widget.eventName,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffF8A44C).withOpacity(0.65),
                            borderRadius: BorderRadius.circular(15),
                            border:
                                Border.all(width: 2, color: Color(0xffF8A44C)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.library_books_outlined,
                                  color: Colors.white,
                                  size: 60,
                                ),
                              ),
                              Text(
                                'Guest List',
                                style: GoogleFonts.manrope(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddVolunteerScreen(
                                    eventName: widget.eventName,
                                    eventIdNo: widget.eventIdno,
                                    lat: widget.lat,
                                    long: widget.long,
                                  )),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, right: 8, left: 8, bottom: 16),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 144, 205, 238),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  width: 2,
                                  color: Color.fromARGB(255, 54, 169, 231))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.add_box,
                                  color: Colors.white,
                                  size: 60,
                                ),
                              ),
                              Text(
                                'Add Volunteer',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.manrope(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VolunteerListScreen(
                              eventId: widget.eventIdno,
                              eventName: widget.eventName,
                              lat: widget.lat,
                              long: widget.long,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, right: 8, left: 8, bottom: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffD73B77).withOpacity(0.65),
                            border:
                                Border.all(width: 2, color: Color(0xffD73B77)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.list_rounded,
                                  color: Colors.white,
                                  size: 60,
                                ),
                              ),
                              Text(
                                'Volunteer\nList',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.manrope(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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

class ContainerButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const ContainerButton({
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
