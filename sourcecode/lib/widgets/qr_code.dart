import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QrCode extends StatefulWidget {
  const QrCode({super.key});

  @override
  QrCodeState createState() {
    return QrCodeState();
  }
}

class QrCodeState extends State<QrCode> {
  String? userId;

  // show spinner
  // check user preferences, if user_id -> show image

  Future<void> fetchUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      userId = prefs.getString('user_id');
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(userId ?? "No user id found"),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    fetchUserPreferences();
  }

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
            child: userId != null
                ? Image.network("http://localhost:3000/$userId/qr")
                : new CircularProgressIndicator()));
  }
}
