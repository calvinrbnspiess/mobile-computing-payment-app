import 'package:flutter/material.dart';

import 'package:mobile_computing_payment_app/pages/qr_code_scan_screen.dart';
import 'package:mobile_computing_payment_app/widgets/background_pane.dart';
import 'package:mobile_computing_payment_app/widgets/header_row.dart';
import 'package:mobile_computing_payment_app/widgets/payero_button.dart';
import 'package:mobile_computing_payment_app/widgets/qr_code.dart';
import 'package:mobile_computing_payment_app/widgets/transaction_history.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      const BackgroundPane(),
      Column(children: [
        Expanded(
          child: Container(
            padding:
                const EdgeInsets.only(bottom: 30, top: 60, left: 30, right: 30),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [HeaderRow(), QrCode(), TransactionHistory()],
            ),
          ),
        ),
        Container(
            margin: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
            child: Column(children: [
              PayeroButton(
                  text: "Zum Bezahlen Scannen",
                  onClick: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const QRScanScreen(),
                            ))
                      }),
            ]))
      ]),
    ]));
  }
}
