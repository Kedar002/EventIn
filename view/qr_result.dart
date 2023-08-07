import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:eventin/constants.dart';
import 'package:eventin/controllers/postApiController.dart';
import 'package:eventin/view/event_details.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class QRResultScreen extends StatefulWidget {
  final String qrCodeResult;
  final String eventName;
  final int eventIdNo;
  final String eventLat;
  final String eventLong;
  QRResultScreen({
    required this.qrCodeResult,
    required this.eventIdNo,
    required this.eventName,
    required this.eventLat,
    required this.eventLong,
  });

  @override
  State<QRResultScreen> createState() => _QRResultScreenState();
}

class _QRResultScreenState extends State<QRResultScreen> {
  int id = 0;
  String message = '';
  @override
  void initState() {
    // TODO: implement initState
    saveEntry(
        context: context,
        entryIdNo: widget.eventIdNo,
        lat: double.parse(widget.eventLat),
        long: double.parse(widget.eventLong),
        qrText: widget.qrCodeResult.toString(),
        navigateToScreen: () {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('QR Result'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          id == 0
              ? SizedBox.shrink()
              : Center(
                  child: Image.asset('assets/approved.jpeg'),
                ),
          SizedBox(height: 40.0),
          Center(
            child: Text(
              // widget.qrCodeResult,
              message,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text('Scan Next'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => EventDetailsScreen(
                          eventIdno: widget.eventIdNo,
                          eventName: widget.eventName,
                          lat: widget.eventLat,
                          long: widget.eventLong,
                        )),
                (Route<dynamic> route) => false,
              );
            },
            child: Text('Dashboard'),
          ),
        ],
      ),
    );
  }

  saveEntry(
      {required BuildContext context,
      required int entryIdNo,
      required double lat,
      required double long,
      required String qrText,
      required Function navigateToScreen}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId') ?? "0";
    var response = await saveEntryOfQr(
        context,
        "SaveEntry",
        "SaveEntry",
        "@EventIdNo =$entryIdNo,@LoginUserIdNo=$userId,@Lat=$lat,@Long=$long,@QRText='$qrText'",
        // "@EventIdNo =37,@LoginUserIdNo=35,@Lat=1,@Long=1,@QRText=44",
        "",
        "",
        navigateToScreen);
    setState(() {});
  }

  Future saveEntryOfQr(
    BuildContext context,
    String moduleName,
    String taskName,
    String postObject,
    String imageBase64,
    String extension,
    Function navigateToScreen,
  ) async {
    print('update prfoile');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userToken = prefs.getString('token');

    final body = jsonEncode({
      "ModuleName": "$moduleName",
      "TaskName": "$taskName",
      "PostObject": "$postObject",
      "ImageBase64": "$imageBase64",
      "Extension": "$extension"
    });
    print(body);

    final header = {
      'Authorization': 'Bearer $userToken',
      HttpHeaders.contentTypeHeader: "application/json"
    };

    http.Response response = await http.post(
        Uri.parse('$BASE_URL/api/Common/PostRequest'),
        body: body,
        headers: header);
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      id = data['id'];
      message = data['message'];
      showTopSnackBar(
        dismissType: DismissType.onTap,
        displayDuration: const Duration(seconds: 2),
        context,
        CustomSnackBar.success(
          message: data['message'],
        ),
      );

      navigateToScreen();
      log(data['message']);
    } else {
      // ignore: use_build_context_synchronously
      showTopSnackBar(
        dismissType: DismissType.onTap,
        displayDuration: const Duration(seconds: 2),
        context,
        CustomSnackBar.info(
          message: data['message'],
        ),
      );
      log(data['message']);
    }
  }
}

///id == 0 fail else sucess show image n msg
///