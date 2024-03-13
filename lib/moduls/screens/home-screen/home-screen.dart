import 'dart:async';
import 'dart:math';
import 'dart:developer' as msg;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Static {
  static int current = 0;
  static int balance = 10;
  static int currentPeriod = 0;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer _timer;
  static const int defaultTimerDuration = 10; // 2 minutes in seconds
  int timerSeconds = defaultTimerDuration;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _getRandomColor();
  }

  _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timerSeconds > 0) {
          timerSeconds--;
        } else {
          timerSeconds = defaultTimerDuration;
          _getRandomColor();
          hestoryColors.add(Static.current);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  _getRandomColor() {
    Random random = Random();
    Static.current = random.nextInt(colors.length);
    Static.currentPeriod = hestoryColors.length + 1; // Save the current period

    setState(() {});
    msg.log("${Static.current}");
    msg.log("${Static.currentPeriod}");
  }

  int selectedColorIndex = -1;

  void _showColorSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Color Selection"),
          content: Text("Do you want to bet on this color?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (Static.balance <= 0) {
                  _showInfluenceBalanceDialog();
                } else {
                  updateBalance(Static.current, selectedColorIndex, 0);
                }
                Navigator.of(context).pop();
              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  updateBalance(int currentColorIndex, int selectedColorIndex, int betAmount) {
    if (currentColorIndex == selectedColorIndex) {
      Static.balance += betAmount * 2;
    } else {
      Static.balance -= betAmount;
    }
    setState(() {});
  }

  void _showInfluenceBalanceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Insufficient Balance"),
          content: Text("Your balance is insufficient. Please recharge."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "COLOR PREDICTION",
          style: TextStyle(
            fontSize: 15,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                  ),
                ],
                color: Colors.blue,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Available Balance : ₹${Static.balance}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                        child: const Text("Recharge"),
                      ),
                      SizedBox(
                        width: w / 20,
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                        child: const Text("Read Rules"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Period",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Cool Down",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "20240131${Static.currentPeriod + 1}",
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              _formatTime(timerSeconds),
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 3,
                        mainAxisExtent: 50,
                      ),
                      itemCount: colors.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedColorIndex = index;
                          });
                          _showColorSelectionDialog();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 20),
                          height: h / 30,
                          width: w / 5,
                          decoration: BoxDecoration(
                            color: colors[index],
                            border: Border.all(
                              color: selectedColorIndex == index
                                  ? Colors.blue
                                  : Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          Expanded(
            flex: 13,
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: hestoryColors
                    .asMap()
                    .entries
                    .map(
                      (entry) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("20240131${entry.key + 1}"),
                          Text("${entry.value}"),
                          Container(
                            height: h / 30,
                            width: w / 20,
                            decoration: BoxDecoration(
                              color: colors[entry.value].withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

List<Color> colors = [
  Colors.green,
  Colors.red,
  Colors.deepPurple,
];

List hestoryColors = [];
