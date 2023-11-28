import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: SvgPicture.asset(
            'assets/images/payero-logo.svg',
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            height: 50.0,
          ),
          backgroundColor: const Color(0xFFF3F5F7),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_outlined,
            ),
          ),
        ),
        body: Stack(children: [
          Column(children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                    bottom: 30, top: 60, left: 30, right: 30),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Einstellungen",
                      style:
                          TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
                child: const Column(children: []))
          ]),
        ]));
  }
}
