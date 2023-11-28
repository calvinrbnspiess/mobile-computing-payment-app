import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_computing_payment_app/classes/Transaction.dart';

import 'package:mobile_computing_payment_app/constants.dart';

import 'package:mobile_computing_payment_app/pages/qr_code_scan_screen.dart';
import 'package:mobile_computing_payment_app/widgets/background_pane.dart';
import 'package:mobile_computing_payment_app/widgets/header_row.dart';
import 'package:mobile_computing_payment_app/widgets/payero_button.dart';
import 'package:mobile_computing_payment_app/widgets/qr_code.dart';
import 'package:mobile_computing_payment_app/widgets/transaction_history.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? userId;
  String? nickname;
  String? qrcodeUrl;
  List<Transaction> transactions = [];

  Future<void> fetchUserPreferences() async {
    debugPrint("Fetching user preferences");
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      nickname = prefs.getString('nickname');
      userId = prefs.getString('user_id');
      qrcodeUrl = "$SERVER_URL/${userId!}/qr";
    });

    final response =
        await http.get(Uri.parse("$SERVER_URL/${userId!}/history"));

    if (response.statusCode != 200) {
      debugPrint("failed to fetch transactions" + response.body);
    } else {
      final List<dynamic> transactionsJson =
          jsonDecode(response.body)["transactions"];
      transactions =
          transactionsJson.map((e) => Transaction.fromJson(e)).toList();
      debugPrint("transactions: " + response.body);
    }
  }

  @override
  void initState() {
    super.initState();

    fetchUserPreferences();
  }

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const HeaderRow(),
                QrCode(url: qrcodeUrl),
                TransactionHistory(transactions: transactions)
              ],
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
