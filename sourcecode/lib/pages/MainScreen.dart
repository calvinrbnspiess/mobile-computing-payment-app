import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:mobile_computing_payment_app/pages/QRScanScreen.dart';

class HeaderRow extends StatelessWidget {
  const HeaderRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset('assets/images/payero-logo-with-title.svg',
              semanticsLabel: 'Payero', width: 150),
          Positioned(
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.settings, size: 30),
              onPressed: () {
                // Handle cog wheel icon press
              },
            ),
          ),
        ],
      ),
    );
  }
}

class QrCode extends StatelessWidget {
  const QrCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Container(
            constraints: BoxConstraints(minHeight: 0, maxHeight: 200),
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.only(top: 18, bottom: 18),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFD6D6D6), width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(16))),
            child: Image.asset('assets/images/sample-qr-code.png')));
  }
}

class TransactionEntry extends StatelessWidget {
  final String date;
  final String name;
  final double amount;

  const TransactionEntry(
      {super.key, this.date = "", this.name = "", this.amount = 0.0});

  @override
  Widget build(BuildContext context) {
    var isPositiveTransaction = amount >= 0;
    var formattedAmount =
        '${isPositiveTransaction ? '+' : ''}${amount.toStringAsFixed(2)} €';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(date,
            style: const TextStyle(
                color: Color(0xff5F6060), fontWeight: FontWeight.bold)),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(name,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Text(formattedAmount,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isPositiveTransaction
                      ? const Color(0xff0FDFAF)
                      : const Color(0xffDF0F0F)))
        ])
      ],
    );
  }
}

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 30),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFD6D6D6), width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      child: const Wrap(runSpacing: 6, children: [
        Text(
          "Transaktionen",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        TransactionEntry(
            date: "09.11.2023 13:34 Uhr",
            name: "Max Mustermann",
            amount: -55.00),
        TransactionEntry(
            date: "26.10.2023 17:21 Uhr", name: "Tim Müller", amount: 24.12),
        TransactionEntry(
            date: "13.07.2023 09:12 Uhr", name: "Felix Schmidt", amount: 13.77)
      ]),
    );
  }
}

class PayeroButton extends StatelessWidget {
  const PayeroButton({this.text = "", super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    var borderRadius = BorderRadius.circular(16);

    return InkWell(
        onTap: () {
          // print("Click event on Container");
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const QRScanScreen(),
              ));
        },
        borderRadius: borderRadius,
        child: Ink(
            height: 66,
            decoration: BoxDecoration(
              color: const Color(0xff0FDFAF),
              borderRadius: borderRadius,
            ),
            child: Center(
              child: Text(text,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xff393939))),
            )));
  }
}

class BackgroundPane extends StatelessWidget {
  const BackgroundPane({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 0,
        right: 0,
        top: 0,
        bottom: MediaQuery.of(context).size.height * 0.33,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: const Color(0xFFF3F5F7),
              border: Border.all(color: const Color(0xFFD6D6D6), width: 1),
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24))),
        ));
  }
}

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
            child: const Column(children: [
              PayeroButton(text: "Zum Bezahlen Scannen"),
            ]))
      ]),
    ]));
  }
}
