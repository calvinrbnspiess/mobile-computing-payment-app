import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
