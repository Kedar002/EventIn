import 'package:eventin/controllers/event_list_controller.dart';
import 'package:eventin/controllers/get_event_List_conntroller.dart';
import 'package:eventin/view/event_details.dart';
import 'package:eventin/view/event_form.dart';
import 'package:flutter/material.dart';

class EntryList extends StatefulWidget {
  String eventName;
  String guestStaus;
  int eventIdNo;
  int guestTypeIdNo;
  EntryList(
      {required this.eventIdNo,
      required this.eventName,
      required this.guestStaus,
      required this.guestTypeIdNo});
  @override
  State<EntryList> createState() => _EntryListState();
}

class _EntryListState extends State<EntryList> {
  List entryList = [];

  @override
  void initState() {
    getData();
    // TODO: implement initState
  }

  getData() async {
    entryList = [];
    var response = await GuestEntryList().getGuestEntryList(
        eventID: widget.eventIdNo,
        guestStatus: widget.guestStaus,
        guestType: widget.guestTypeIdNo);
    entryList.addAll(response.data);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.eventName),
      ),
      body: ListView.builder(
        itemCount: entryList.length,
        itemBuilder: (context, index) {
          final guest = entryList[index];
          return ListTile(
            title: Text(guest.guestName),
            trailing: Text(guest.paidAmt.toString()),
            subtitle: Text(guest.entryTime.toString() ?? ''),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => EventDetailsScreen(
              //             eventName: event.guestName,
              //             eventIdno: event.paidAmt,
              //           )),
              // );
            },
          );
        },
      ),
    );
  }
}
