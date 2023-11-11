import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HeaderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset('assets/images/payero-logo-with-title.svg',
              semanticsLabel: 'Payero', width: 150),
          Positioned(
            right: 0,
            child: IconButton(
              icon: Icon(Icons.settings, size: 30),
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
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Image.asset('assets/images/sample-qr-code.png', width: 200),
        padding: EdgeInsets.all(14),
        margin: EdgeInsets.only(top: 70, bottom: 60),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Color(0xFFD6D6D6), width: 1),
            borderRadius: BorderRadius.all(Radius.circular(16))));
  }
}

class TransactionEntry extends StatelessWidget {
  String date = "";
  String name = "";
  double amount = 0.0;

  TransactionEntry(this.date, this.name, this.amount, {super.key});

  @override
  Widget build(BuildContext context) {
    var isPositiveTransaction = amount >= 0;
    var formattedAmount =
        '${isPositiveTransaction ? '+' : ''}${amount.toStringAsFixed(2)} €';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(date, style: const TextStyle(color: const Color(0xff5F6060))),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(name, style: const TextStyle(fontSize: 16)),
          Text(formattedAmount,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isPositiveTransaction
                      ? const Color(0xff0FDFAF)
                      : const Color(0xffDF0F0F)))
        ])
      ],
    );
  }
}

class TransactionHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(children: [
        Text(
          "Transaktionen",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        TransactionEntry("09.11.2023 13:34 Uhr", "Max Mustermann", -55.00),
        TransactionEntry("26.10.2023 17:21 Uhr", "Tim Müller", 24.12),
        TransactionEntry("13.07.2023 09:12 Uhr", "Felix Schmidt", 13.77)
      ], runSpacing: 6),
      padding: EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 30),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFD6D6D6), width: 1),
          borderRadius: BorderRadius.all(Radius.circular(16))),
      margin: EdgeInsets.only(left: 30, right: 30),
      transform: Matrix4.translationValues(0.0, -75.0, 0.0),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var pane = Container(
        width: double.infinity,
        child: Column(
            children: [HeaderRow(), QrCode()], mainAxisSize: MainAxisSize.min),
        padding: EdgeInsets.only(bottom: 60, top: 60, left: 30, right: 30),
        decoration: BoxDecoration(
            color: Color(0xFFF3F5F7),
            border: Border.all(color: Color(0xFFD6D6D6), width: 1),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24))));

    return Scaffold(
        body: Container(child: Column(children: [pane, TransactionHistory()])),
        backgroundColor: Colors.white);
  }
}
