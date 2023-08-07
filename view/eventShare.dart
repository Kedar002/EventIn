import 'dart:typed_data';

import 'package:eventin/constants.dart';
import 'package:eventin/controllers/event_list_controller.dart';
import 'package:eventin/widgets/dark_blue_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:ui' as ui;

class EventShare extends StatefulWidget {
  final String eventName;
  final int eventIdNo;
  final String imageUrl;

  EventShare({
    required this.eventIdNo,
    required this.eventName,
    required this.imageUrl,
  });

  @override
  State<EventShare> createState() => _EventShareState();
}

class _EventShareState extends State<EventShare> {
  String title = "";
  String data = 'bSkyQr';
  List lQrData = [];
  List lines = [];
  GlobalKey screenKey = GlobalKey();
  String dataToBeShared = "";
  String eventMapLink = "";

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    List temp = [];
    var response = await EventList().getEventShare(widget.eventIdNo);
    temp.addAll(response.data);
    dataToBeShared = temp[0].headerText.toString().replaceAll("\r", " ");
    eventMapLink = temp[0].mapUrl.toString();
    // dataToBeShared = removeHtmlTags(dataToBeShared);
    // Share.share(dataToBeShared);
    print(dataToBeShared);
    setState(() {});
  }

  String removeHtmlTags(String htmlString) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }

  void _shareQRCode(String link) async {
    try {
      // Capture the screen as an image
      RenderRepaintBoundary boundary =
          screenKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image? screenImage = await boundary.toImage();
      ByteData? byteData =
          await screenImage.toByteData(format: ui.ImageByteFormat.png);
      Uint8List screenImageData = byteData!.buffer.asUint8List();

      // Create a temporary directory
      Directory tempDir = await getTemporaryDirectory();

      // Generate a unique file name for the screen image
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String screenImagePath = '${tempDir.path}/screen_$timestamp.png';

      // Write the screen image data to the temporary file
      File screenImageFile = File(screenImagePath);
      await screenImageFile.writeAsBytes(screenImageData);

      // Share the QR code image file with the screen image as the caption
      await Share.shareFiles([screenImagePath], text: link);
    } catch (e) {
      // Handle any errors that occur during sharing
      print('Error sharing QR code: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.eventName),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: RepaintBoundary(
        key: screenKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Center(
                      child: SingleChildScrollView(
                          child: dataToBeShared == ''
                              ? Html(
                                  data: """<h1>Share Event</h1>,""",
                                  padding: EdgeInsets.all(8.0),
                                  onLinkTap: (url) {
                                    print("Opening $url...");
                                  },
                                )
                              : Html(
                                  data: """$dataToBeShared,""",
                                  padding: EdgeInsets.all(8.0),
                                  onLinkTap: (url) {
                                    print("Opening $url...");
                                  },
                                )),
                    )),
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: Container(
                    color: Colors.white,
                    height: 150,
                    // width: 150,
                    child: widget.imageUrl == null || widget.imageUrl == ""
                        ? Image.asset(
                            'assets/splash_banner.jpeg',
                          )
                        : Image.network('${BASE_URL}/${widget.imageUrl}'),
                  ),
                ),
                SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 50.0, right: 16),
        child: BlueButton(
          onPressed: (() {
            _shareQRCode(eventMapLink);
          }),
          title: 'Share',
        ),
      ),
    );
  }
}
