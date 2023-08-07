// import 'package:eventin/view/qr_result.dart';
// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// class QRScannerScreen extends StatefulWidget {
//   final String eventName;
//   final int eventIdNo;
//   final String eventLat;
//   final String eventLong;

//   QRScannerScreen({
//     required this.eventIdNo,
//     required this.eventName,
//     required this.eventLat,
//     required this.eventLong,
//   });

//   @override
//   _QRScannerScreenState createState() => _QRScannerScreenState();
// }

// class _QRScannerScreenState extends State<QRScannerScreen> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   late QRViewController controller;
//   String qrCodeResult = '';
//   bool backCamera = true;
//   bool isQRCodeDetected = false; // Flag to track QR code detection
//   var result;

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Scan QR"),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             flex: 5,
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 QRView(
//                   key: qrKey,
//                   onQRViewCreated: _onQRViewCreated,
//                 ),
//                 Container(
//                   height: 155,
//                   width: 155,
//                   margin: EdgeInsets.all(50.0),
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: MyTheme.secondaryColor,
//                       width: 2.0,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       if (!isQRCodeDetected) {
//         setState(() {
//           qrCodeResult = scanData.code!;
//           isQRCodeDetected =
//               true; // Set the flag to true once QR code is detected
//         });

//         // Perform necessary actions with the detected QR code
//         // For example, navigate to a different screen
//         result = Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => QRResultScreen(
//               qrCodeResult: qrCodeResult,
//               eventIdNo: widget.eventIdNo,
//               eventName: widget.eventName,
//               eventLat: widget.eventLat,
//               eventLong: widget.eventLong,
//             ),
//           ),
//         );
//         isQRCodeDetected = result;
//       }
//     });
//   }
// }

// class QRResultScreen extends StatelessWidget {
//   final String qrCodeResult;
//   final int eventIdNo;
//   final String eventName;
//   final String eventLat;
//   final String eventLong;

//   QRResultScreen({
//     required this.qrCodeResult,
//     required this.eventIdNo,
//     required this.eventName,
//     required this.eventLat,
//     required this.eventLong,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("QR Result"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "QR Code Result:",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Text(
//               qrCodeResult,
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 20),
//             Text(
//               "Event ID: $eventIdNo",
//               style: TextStyle(fontSize: 16),
//             ),
//             Text(
//               "Event Name: $eventName",
//               style: TextStyle(fontSize: 16),
//             ),
//             Text(
//               "Event Latitude: $eventLat",
//               style: TextStyle(fontSize: 16),
//             ),
//             Text(
//               "Event Longitude: $eventLong",
//               style: TextStyle(fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:eventin/constants/theme.dart';
import 'package:eventin/view/qr_result.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  final String eventName;
  final int eventIdNo;
  final String eventLat;
  final String eventLong;

  QRScannerScreen({
    required this.eventIdNo,
    required this.eventName,
    required this.eventLat,
    required this.eventLong,
  });

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  String qrCodeResult = '';
  bool backCamera = true;
  bool isQRCodeDetected = false; // Flag to track QR code detection
  var result;
  bool hasflashlight = false;
  bool isturnon = false;
  String flashLightString = 'Turn on the flashlight';

  // @override
  // void initState() {
  //   Future.delayed(Duration.zero, () async {
  //     //we use Future.delayed because there is async function inside it.
  //     bool istherelight = await Flashlight.hasFlashlight;
  //     setState(() {
  //       hasflashlight = istherelight;
  //     });
  //   });
  //   super.initState();
  // }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Scan QR",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              alignment: Alignment.center,
              children: [
                QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
                Container(
                  height: 155,
                  width: 155,
                  margin: EdgeInsets.all(50.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: MyTheme.secondaryColor,
                      width: 2.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // bottomNavigationBar: InkWell(
      //   onTap: () {
      //     if (isturnon) {
      //       //if light is on, then turn off
      //       flashLightString = 'Turn off the flashlight';
      //       _enableTorch(context);
      //       setState(() {
      //         isturnon = false;
      //       });
      //     } else {
      //       //if light is off, then turn on.
      //       flashLightString = 'Turn on the flashlight';
      //       _enableTorch(context);
      //       setState(() {
      //         isturnon = true;
      //       });
      //     }
      //   },
      //   child: BottomAppBar(
      //     color: Colors.white,
      //     child: Padding(
      //       padding: EdgeInsets.symmetric(vertical: 16.0),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Icon(Icons.flash_on, color: Colors.grey),
      //           SizedBox(width: 16.0),
      //           Text(
      //             flashLightString,
      //             style: TextStyle(color: Colors.grey),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!isQRCodeDetected) {
        setState(() {
          qrCodeResult = scanData.code!;
          isQRCodeDetected =
              true; // Set the flag to true once QR code is detected
        });

        // Perform necessary actions with the detected QR code
        // For example, navigate to a different screen
        result = Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QRResultScreen(
              qrCodeResult: qrCodeResult,
              eventIdNo: widget.eventIdNo,
              eventName: widget.eventName,
              eventLat: widget.eventLat,
              eventLong: widget.eventLong,
            ),
          ),
        );
        isQRCodeDetected = result;
      }
    });
  }

  // Future<void> _enableTorch(BuildContext context) async {
  //   try {
  //     await TorchLight.enableTorch();
  //   } on Exception catch (_) {
  //     _showMessage('Could not enable torch', context);
  //   }
  // }

  // Future<void> _disableTorch(BuildContext context) async {
  //   try {
  //     await TorchLight.disableTorch();
  //   } on Exception catch (_) {
  //     _showMessage('Could not disable torch', context);
  //   }
  // }

  // void _showMessage(String message, BuildContext context) {
  //   ScaffoldMessenger.of(context)
  //       .showSnackBar(SnackBar(content: Text(message)));
  // }
}

class QRResultScreen extends StatelessWidget {
  final String qrCodeResult;
  final int eventIdNo;
  final String eventName;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "QR Result",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "QR Code Result:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              qrCodeResult,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "Event ID: $eventIdNo",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "Event Name: $eventName",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "Event Latitude: $eventLat",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "Event Longitude: $eventLong",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
