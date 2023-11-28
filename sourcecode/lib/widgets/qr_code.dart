import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QrCode extends StatelessWidget {
  final String? url;

  const QrCode({this.url, super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Container(
            constraints: BoxConstraints(minHeight: 0, maxHeight: 200),
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.only(top: 18, bottom: 18),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFD6D6D6), width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(16))),
            child: url != null
                ? Image.network(url!)
                : new CircularProgressIndicator()));
  }
}
