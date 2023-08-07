// import 'package:eventin/controllers/get_dashboardResponse_controller.dart';
// import 'package:eventin/view/entryList.dart';
// import 'package:flutter/material.dart';

// class DashboardScreen extends StatefulWidget {
//   String eventName;
//   int eventIdNo;
//   DashboardScreen({required this.eventName, required this.eventIdNo});

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   List dashboardData = [];
//   @override
//   void initState() {
//     // TODO: implement initState
//     getData();
//     super.initState();
//   }

//   getData() async {
//     dashboardData = [];
//     var response =
//         await Dashboard().getDashboardDetails(eventID: widget.eventIdNo);
//     dashboardData.addAll(response.data);
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.eventName),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 16),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     'People',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Expanded(
//                   child: Text(
//                     'Registered',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Expanded(
//                   child: Text(
//                     'Scanned',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 8),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: List.generate(
//                 dashboardData.length,
//                 (index) => _buildDataRow(dashboardData[index]),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDataRow(rowData) {
//     String category = rowData.guestType ?? '';
//     String registered = rowData.totalGuest.toString() ?? '';
//     String scanned = rowData.guestEnteredCount.toString() ?? '';
//     int guestTypeIdNo = rowData.guestTypeIdno ?? 0;

//     return Row(
//       children: [
//         Expanded(
//           child: GestureDetector(
//             onTap: () {
//               print(category);
//             },
//             child: Text(category),
//           ),
//         ),
//         Expanded(
//           child: GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => EntryList(
//                           eventName: widget.eventName,
//                           eventIdNo: widget.eventIdNo,
//                           guestStaus: 'All',
//                           guestTypeIdNo: guestTypeIdNo,
//                         )),
//               );
//             },
//             child: Text(registered),
//           ),
//         ),
//         Expanded(
//           child: GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => EntryList(
//                           eventName: widget.eventName,
//                           eventIdNo: widget.eventIdNo,
//                           guestStaus: 'Scanned',
//                           guestTypeIdNo: guestTypeIdNo,
//                         )),
//               );
//             },
//             child: Text(scanned),
//           ),
//         ),
//       ],
//     );
//   }
// }

/// N E W      C O D E
import 'package:eventin/controllers/get_dashboardResponse_controller.dart';
import 'package:eventin/view/entryList.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatefulWidget {
  String eventName;
  int eventIdNo;
  DashboardScreen({required this.eventName, required this.eventIdNo});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List dashboardData = [];
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  getData() async {
    dashboardData = [];
    var response =
        await Dashboard().getDashboardDetails(eventID: widget.eventIdNo);
    dashboardData.addAll(response.data);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.eventName,
          style: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Dashboard at Glance",
                style: GoogleFonts.manrope(
                    fontSize: 24, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 20,
              ),
              DataTable(
                columns: [
                  DataColumn(
                    label: Text(
                      'People',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Registered',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Scanned',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: List.generate(
                  dashboardData.length,
                  (index) => _buildDataRow(dashboardData[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DataRow _buildDataRow(rowData) {
    String category = rowData.guestType ?? '';
    String registered = rowData.totalGuest.toString() ?? '';
    String scanned = rowData.guestEnteredCount.toString() ?? '';
    int guestTypeIdNo = rowData.guestTypeIdno ?? 0;

    return DataRow(
      cells: [
        DataCell(
          GestureDetector(
            onTap: () {
              print(category);
            },
            child: Text(category),
          ),
        ),
        DataCell(
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EntryList(
                    eventName: widget.eventName,
                    eventIdNo: widget.eventIdNo,
                    guestStaus: 'All',
                    guestTypeIdNo: guestTypeIdNo,
                  ),
                ),
              );
            },
            child: Center(
                child: Text(
              "$registered      ",
              style: TextStyle(
                decoration: TextDecoration.underline,
              ),
            )),
          ),
        ),
        DataCell(
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EntryList(
                    eventName: widget.eventName,
                    eventIdNo: widget.eventIdNo,
                    guestStaus: 'Scanned',
                    guestTypeIdNo: guestTypeIdNo,
                  ),
                ),
              );
            },
            child: Center(
                child: Text(
              "$scanned      ",
              style: TextStyle(
                decoration: TextDecoration.underline,
              ),
            )),
          ),
        ),
      ],
    );
  }
}
