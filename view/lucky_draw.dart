import 'dart:async';

import 'package:eventin/constants/theme.dart';
import 'package:eventin/controllers/get_event_List_conntroller.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:google_fonts/google_fonts.dart';

class LuckyDraw extends StatefulWidget {
  LuckyDraw({required this.eventID});
  int eventID;

  @override
  _LuckyDrawState createState() => _LuckyDrawState();
}

class _LuckyDrawState extends State<LuckyDraw> {
  StreamController<int> selected = StreamController<int>();

  var _width = 300.0;
  var _height = 120.0;
  var _txSize = TextStyle(fontSize: 28, fontWeight: FontWeight.bold);
  var showtext = false;

  var luckyGuest = '';
  bool showWinner = false;
  double _scale = 1.0;

  double boxHeight = 50;
  double boxWidth = 50;
  double boxX = 1.0;
  double boxY = 1.0;
  bool _isExpanded = false;

  void _expandBox() {
    setState(() {
      _isExpanded = !_isExpanded;
      // boxHeight = 300;
      // boxWidth = 300;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getLuckyGuest();
  }

  getLuckyGuest() async {
    var response =
        await GuestEntryList().getLuckyGuest(eventID: widget.eventID);
    luckyGuest = response.data[0].guestName;
  }

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = <String>[
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: MyTheme.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: MyTheme.secondaryColor,
        title: Text('Lucky Draw'),
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            selected.add(
              Fortune.randomInt(0, items.length),
            );
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FortuneWheel(
                styleStrategy: AlternatingStyleStrategy(),
                indicators: <FortuneIndicator>[
                  FortuneIndicator(
                    alignment: Alignment
                        .bottomCenter, // <-- changing the position of the indicator
                    child: TriangleIndicator(
                      color: MyTheme
                          .golden, // <-- changing the color of the indicator
                    ),
                  ),
                ],
                selected: selected.stream,
                onAnimationEnd: () {
                  setState(() {
                    Future.delayed(Duration(milliseconds: 500), () {
                      setState(() {
                        showWinner = true;
                      });
                    });
                  });
                },
                items: [
                  for (var it in items) FortuneItem(child: Text(it)),
                ],
              ),
            ),
            if (showWinner)
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: Column(
                  children: [
                    AnimatedTextKit(
                      pause: const Duration(seconds: 0),
                      isRepeatingAnimation: false,
                      animatedTexts: [
                        ScaleAnimatedText(
                          'Winner is $luckyGuest',
                          textStyle: TextStyle(
                              fontSize: 34, fontWeight: FontWeight.bold),
                        ),
                      ],
                      // totalRepeatCount: 1,
                      onFinished: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            if (!showWinner)
              Padding(
                padding: const EdgeInsets.only(bottom: 50, top: 20),
                child: Text(
                  '',
                  // 'Tap on the wheel to draw',
                  style: GoogleFonts.manrope(
                      fontSize: 14, color: MyTheme.font_grey),
                ),
              )
          ],
        ),
      ),
    );
  }
}
