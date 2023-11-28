import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_computing_payment_app/widgets/payero_header.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PayeroHeader(),
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
