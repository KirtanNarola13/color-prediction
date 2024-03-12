import 'dart:async';
import 'dart:math';
import 'dart:developer' as msg;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Static {
  static int current = 0;
  static int balance = 10;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _getRandomColor() {
    Random random = Random();
    Static.current = random.nextInt(colors.length);

    setState(() {});
    Timer(Duration(seconds: 5), () {
      _getRandomColor();
      hestoryColors.add(Static.current);
      updateBalance(Static.current, selectedColorIndex);
    });
    msg.log("${Static.current}");
  }

  int selectedColorIndex = -1;

  updateBalance(int currentColorIndex, int selectedColorIndex) {
    if (currentColorIndex == selectedColorIndex) {
      Static.balance += 10;
    } else {
      // Check if balance is greater than 0 before decrementing
      if (Static.balance > 0) {
        Static.balance -= 10;
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getRandomColor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: colors.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColorIndex = index;
                    });
                    updateBalance(Static.current, selectedColorIndex);
                  },
                  child: Container(
                    margin: EdgeInsets.all(20),
                    height: 50,
                    width: 20,
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
                );
              },
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: hestoryColors
                  .map(
                    (e) => Container(
                      margin: EdgeInsets.all(10),
                      height: 30,
                      width: 30,
                      color: colors[e],
                    ),
                  )
                  .toList(),
            ),
          ),
          Container(
            height: 50,
            width: 50,
            color: colors[Static.current],
          ),
          Text("Balance: ${Static.balance}"),
        ],
      ),
    );
  }
}

List<Color> colors = [
  Colors.green,
  Colors.red,
  Colors.deepPurple,
];

List hestoryColors = [];
