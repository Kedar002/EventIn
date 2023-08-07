import 'package:eventin/controllers/volunteer_list_controller.dart';
import 'package:eventin/view/edit_participants.dart';
import 'package:eventin/view/qr_generator_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/theme.dart';

class GuestListScreen extends StatefulWidget {
  final int eventId;
  final String eventName;

  GuestListScreen({required this.eventId, required this.eventName});

  @override
  _GuestListScreenState createState() => _GuestListScreenState();
}

class _GuestListScreenState extends State<GuestListScreen> {
  List guestList = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    guestList = [];
    var response = await VolunteerList().getGuestList(eventId: widget.eventId);
    guestList.addAll(response.data);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.eventName),
        backgroundColor: MyTheme.secondaryColor,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              "Guest List",
              style: GoogleFonts.manrope(
                  fontSize: 24, fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: guestList.length,
              itemBuilder: (context, index) {
                final guest = guestList[index];
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      guest.guestname,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${guest.guesttypename}'),
                        Text('${guest.guestMobileNo}'),
                        Text('${guest.guestemAil}'),
                        Text('${guest.guestadrs}'),
                        Text('${guest.guestpaidamt.toStringAsFixed(2)}'),
                        Text('${guest.compname}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: MyTheme.primaryColor,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                          ),
                          builder: (context) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: Icon(
                                      Icons.edit,
                                      color: MyTheme.primaryColor,
                                    ),
                                    title: Text('Edit'),
                                    onTap: () {
                                      _editGuest(index);
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.share,
                                      color: MyTheme.primaryColor,
                                    ),
                                    title: Text('Share'),
                                    onTap: () {
                                      _shareGuest(index);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
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

  void _editGuest(int index) {
    final guest = guestList[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditParticipantScreen(
          mobileNo: guest.guestMobileNo,
          email: guest.guestemAil,
          address: guest.guestadrs,
          paidAmount: guest.guestpaidamt.toStringAsFixed(2),
          companyName: guest.compname,
          guestType: guest.guesttypename,
          eventIdNo: widget.eventId,
          eventName: widget.eventName,
          guestIdNo: guest.guestidno,
          guestTypeIdNo: guest.guesttypeidno,
          name: guest.guestname,
        ),
      ),
    );
  }

  void _shareGuest(int index) {
    final guest = guestList[index];
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => QrScreen(
                eventIdNo: widget.eventId,
                eventName: widget.eventName,
                guestId: guest.guestidno,
              )),
    );
  }
}
