import 'dart:typed_data';

import 'package:eventin/controllers/get_qr_generator_controller.dart';
import 'package:eventin/widgets/dark_blue_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:ui' as ui;

class QrScreen extends StatefulWidget {
  final String eventName;
  final int eventIdNo;
  final int guestId;

  QrScreen({
    required this.eventIdNo,
    required this.eventName,
    required this.guestId,
  });

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  String title = "";
  String data = 'bSkyQr';
  List lQrData = [];
  List lines = [];
  GlobalKey screenKey = GlobalKey();
  String mapLink = '';

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    lQrData = [];
    var response = await QrGenerator()
        .getQrData(eventID: widget.eventIdNo, guestId: widget.guestId);
    lQrData.addAll(response.data);
    title = lQrData[0].headerText;
    mapLink = lQrData[0].mapUrl;
    data = lQrData[0].qrText;
    // lines = title.split('\r');
    setState(() {});
  }

  void _shareQRCode() async {
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
      await Share.shareFiles([screenImagePath], text: mapLink);
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
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 0,
                    child: title == ''
                        ? Html(
                            data: """<h1>Share</h1>,""",
                            padding: EdgeInsets.all(8.0),
                            onLinkTap: (url) {
                              print("Opening $url...");
                            },
                          )
                        : Html(
                            data: """$title,""",
                            padding: EdgeInsets.all(8.0),
                            onLinkTap: (url) {
                              print("Opening $url...");
                            },
                          )),
                Container(
                  color: Colors.white,
                  height: 150,
                  width: 150,
                  child: QrImage(
                    data: data,
                    version: QrVersions.auto,
                    size: 200.0,
                    foregroundColor:
                        Colors.black, // Set a different foreground color
                    backgroundColor:
                        Colors.white, // Set a different background color
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding:
            const EdgeInsets.only(top: 16.0, bottom: 16, right: 1, left: 35),
        child: BlueButton(
          onPressed: _shareQRCode,
          title: 'Share QR Code',
        ),
      ),
    );
  }
}
