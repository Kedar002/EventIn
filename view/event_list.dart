import 'dart:convert';
import 'dart:io';

import 'package:eventin/constants.dart';
import 'package:eventin/constants/constants.dart';
import 'package:eventin/constants/theme.dart';
import 'package:eventin/controllers/event_list_controller.dart';
import 'package:eventin/view/edit_event_form.dart';
import 'package:eventin/view/eventShare.dart';
import 'package:eventin/view/event_details.dart';
import 'package:eventin/view/event_form.dart';
import 'package:eventin/view/home_page.dart';
import 'package:eventin/view/login.dart';
import 'package:eventin/view/profile.dart';
import 'package:eventin/widgets/dark_blue_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class EventListScreen extends StatefulWidget {
  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  List eventList = [];
  String dataToBeShared = "";
  double? appVersionOnServerIOS;
  double? appVersionOnServer;
  static const APP_STORE_URL = '';
  // 'https://apps.apple.com/us/app/rakshan/id1643447299?platform=iphone';
  static const PLAY_STORE_URL =
      'https://play.google.com/store/apps/details?id=com.bsky.qrpass';

  @override
  void initState() {
    getVersion();
    getData();
    // TODO: implement initState
  }

  getData() async {
    eventList = [];
    var response = await EventList().getEventListList();
    eventList.addAll(response.data);
    setState(() {});
  }

  getVersion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userToken = prefs.getString('token');
    final header = {'Authorization': 'Bearer $userToken'};
    var res = await http.get(
        Uri.parse(
            '$BASE_URL/api/Common/GetRequest?ModuleName=GetVersion&TaskName=GetVersion'),
        headers: header);
    var data = jsonDecode(res.body.toString());
    print(data);
    if (res.statusCode == 200) {
      print('API HIT');
      appVersionOnServerIOS = data["data"][0]["IOSVersion"];
      appVersionOnServer = data["data"][0]["AndroidVersion"];
      print('sever version saved');
      final PackageInfo info = await PackageInfo.fromPlatform();
      print('current build version=${info.version}');
      double currentVersion = double.parse(info.version.split('.').first);
      print('current version after parse=$currentVersion');
      var newVersion = appVersionOnServer!;
      var newVersionIOS = appVersionOnServerIOS!;
      print('New Version for andriod = $newVersion');
      print('New Version for IOS = $newVersionIOS');
      if (Platform.isAndroid) {
        print('IsAndriod');
        if (newVersion > currentVersion) {
          print('New veriosn for andriod is available');
          _showVersionDialog(context);
        }
      }
      if (Platform.isIOS) {
        print('IsIOS');
        if (newVersionIOS > currentVersion) {
          print('New veriosn for IOS is available');
          // ignore: use_build_context_synchronously
          _showVersionDialog(context);
        }
      }
      // return GetVersion.fromJson(data);
    } else {
      throw Exception('Failed to Get Version from Server');
    }
  }

  _showVersionDialog(context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "New App Update Available";
        String message =
            "There is a newer version of app available please update the app.";
        String btnLabel = "Update Now";
        // String btnLabelCancel = "Later";
        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  TextButton(
                    child: Text(btnLabel),
                    onPressed: () => _launchURL(APP_STORE_URL),
                  ),
                  // TextButton(
                  //   child: Text(btnLabelCancel),
                  //   onPressed: () => Navigator.pop(context),
                  // ),
                ],
              )
            : AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  TextButton(
                    child: Text(btnLabel),
                    onPressed: () => _launchURL(PLAY_STORE_URL),
                  ),
                  // TextButton(
                  //   child: Text(btnLabelCancel),
                  //   onPressed: () => Navigator.pop(context),
                  // ),
                ],
              );
      },
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.secondaryColor,
      // appBar: AppBar(
      //   title: Text('Event List'),
      //   leading: GestureDetector(
      //     onTap: () {
      //       Navigator.pushAndRemoveUntil(
      //         context,
      //         MaterialPageRoute(builder: (context) => HomePage()),
      //         (Route<dynamic> route) => false,
      //       );
      //     },
      //     child: Icon(Icons.arrow_back_ios),
      //   ),
      // ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: Row(
                children: [
                  // SizedBox(
                  //   height: 50,
                  //   width: 100,
                  //   child: ClipRRect(
                  //       child: Image.asset('assets/eventin_logo.jpg')),
                  // ),
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
                    child: Row(
                      children: [
                        if (!isSignedIn)
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileScreen(),
                                  ),
                                );
                              },
                              child: !isSignedIn
                                  ? Icon(
                                      Icons.person,
                                      size: 30,
                                      color: MyTheme.white,
                                    )
                                  : SizedBox.shrink()),
                        SizedBox(
                          width: 15,
                        ),
                        InkWell(
                          onTap: () {
                            !isSignedIn
                                ? clearSharedPreferences(context)
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Login(),
                                    ),
                                  );
                          },
                          child: !isSignedIn
                              ? Icon(
                                  Icons.logout_outlined,
                                  size: 30,
                                  color: MyTheme.white,
                                )
                              : Icon(
                                  Icons.login_outlined,
                                  size: 30,
                                  color: MyTheme.white,
                                ),
                        ),
                      ],
                    ),
                  ),
                  // Center(
                  //   child: ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //         elevation: 0,
                  //         backgroundColor: MyTheme.white,
                  //       ),
                  //       onPressed: () {
                  //         !isSignedIn
                  //             ? clearSharedPreferences(context)
                  //             : Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                   builder: (context) => Login(),
                  //                 ),
                  //               );
                  //       },
                  //       child: !isSignedIn
                  //           ? Text(
                  //               'Sign Out',
                  //               style: GoogleFonts.manrope(
                  //                 fontSize: 14,
                  //                 fontWeight: FontWeight.w700,
                  //                 color: MyTheme.primaryColor,
                  //               ),
                  //             )
                  //           : Text(
                  //               'Sign In',
                  //               style: GoogleFonts.manrope(
                  //                 fontSize: 14,
                  //                 fontWeight: FontWeight.w700,
                  //                 color: MyTheme.primaryColor,
                  //               ),
                  //             )),
                  // ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.width * 0.5),
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  color: Colors.white),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 5),
                child: Column(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        "Event List",
                        style: GoogleFonts.manrope(
                            fontSize: 24, fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: eventList.length,
                        itemBuilder: (context, index) {
                          final event = eventList[index];
                          String fromDate = formatDate(
                              event.eventDateFrom.toString().split(" ").first);
                          String toDate = formatDate(
                              event.eventDateTo.toString().split(" ").first);
                          return ListTile(
                            title: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EventDetailsScreen(
                                        eventName: event.eventName,
                                        eventIdno: event.eventIdNo,
                                        lat: event.eventLat,
                                        long: event.eventLong,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(event.eventName)),
                            subtitle: Row(
                              children: [
                                Text("$fromDate to $toDate"),
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
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditEventFormScreen(
                                                          eventIdNo:
                                                              event.eventIdNo,
                                                          eventName:
                                                              event.eventName,
                                                          eventAddress: event
                                                              .eventAddress,
                                                          eventDateFrom: event
                                                              .eventDateFrom
                                                              .toIso8601String(),
                                                          eventDateTo: event
                                                              .eventDateTo
                                                              .toIso8601String(),
                                                          eventDescription:
                                                              event.eventAbout,
                                                          eventLat:
                                                              event.eventLat,
                                                          eventLong:
                                                              event.eventLong,
                                                          eventTimeFrom: event
                                                              .eventTimeFrom,
                                                          eventTimeTo:
                                                              event.eventTimeTo,
                                                          eventImage:
                                                              event.eventImage,
                                                        )),
                                              );
                                            },
                                          ),
                                          ListTile(
                                            leading: Icon(
                                              Icons.info,
                                              color: MyTheme.primaryColor,
                                            ),
                                            title: Text('Details'),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EventDetailsScreen(
                                                    eventName: event.eventName,
                                                    eventIdno: event.eventIdNo,
                                                    lat: event.eventLat,
                                                    long: event.eventLong,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          ListTile(
                                            leading: Icon(
                                              Icons.share,
                                              color: MyTheme.primaryColor,
                                            ),
                                            title: Text('Share'),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EventShare(
                                                    eventName: event.eventName,
                                                    eventIdNo: event.eventIdNo,
                                                    imageUrl:
                                                        event.eventImage ?? '',
                                                  ),
                                                ),
                                              );
                                              // _shareEventInfo(event.eventIdNo);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            onTap: () {},
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: BlueIconButton(
          onPressed: _newForm,
          title: "Add   Event",
          iconImage: 'assets/Plus.png',
        ),
      ),
    );
  }

  _newForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventFormScreen()),
    );
  }

  void _shareEventInfo(int eventIdNo) async {
    List temp = [];
    var response = await EventList().getEventShare(eventIdNo);
    temp.addAll(response.data);
    dataToBeShared = temp[0].headerText.toString().replaceAll("\r", " ");
    Share.share(dataToBeShared);
    print(dataToBeShared);
    setState(() {});
  }

  // shareImage(urlImage) async {
  //   final url = Uri.parse(urlImage);
  //   final response = await http.get(url);
  //   final bytes = response.bodyBytes;

  //   final temp = await getTemporaryDirectory();
  //   final path = '${temp.path}/image.jpg';
  //   File(path).writeAsBytesSync(bytes);

  //   await Share.shareFiles([path],
  //       text: 'https://www.google.com/maps/search/?api=1&query=25.454,75.23');
  // }

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
}
