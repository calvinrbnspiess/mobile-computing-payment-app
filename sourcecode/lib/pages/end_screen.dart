import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_computing_payment_app/pages/main_screen.dart';
import 'package:mobile_computing_payment_app/widgets/payero_button.dart';
import 'package:mobile_computing_payment_app/widgets/payero_header.dart';

class EndScreen extends StatelessWidget {
  final String value;

  const EndScreen({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false, // Verhindert das Zurückgehen
        child: Scaffold(
            appBar: const PayeroHeader(
              showBackButton: false,
            ),
            body: Stack(children: [
              Column(children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                        bottom: 30, top: 80, left: 30, right: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Zahlung erfolgreich ausgeführt',
                            style: TextStyle(fontSize: 20)),
                        Text('$value €',
                            style: const TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold)),
                        SvgPicture.asset(
                          'assets/images/payero-illustration.svg',
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.center,
                          // height: 50.0,
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                    margin:
                        const EdgeInsets.only(left: 30, right: 30, bottom: 30),
                    child: Column(children: [
                      PayeroButton(
                          text: "Fertig",
                          onClick: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const MainScreen(),
                                    ))
                              }),
                    ]))
              ]),
            ])));
  }
}
