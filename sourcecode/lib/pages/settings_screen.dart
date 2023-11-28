import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_computing_payment_app/pages/registration_screen.dart';
import 'package:mobile_computing_payment_app/widgets/payero_button.dart';
import 'package:mobile_computing_payment_app/widgets/payero_header.dart';
import 'package:shared_preferences/shared_preferences.dart';

const textStyleBold = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
const textStyleNormal = TextStyle(fontSize: 16, fontWeight: FontWeight.normal);

class SettingsScreen extends StatelessWidget {
  final String userId;
  final String nickname;

  const SettingsScreen(
      {super.key, required this.userId, required this.nickname});

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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Einstellungen",
                      style:
                          TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                    ),
                    Column(children: [
                      Row(children: [
                        const Text("Spitzname:", style: textStyleBold),
                        const SizedBox(width: 10),
                        Text(nickname, style: textStyleNormal)
                      ]),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Benutzer-ID:", style: textStyleBold),
                            const SizedBox(width: 10),
                            Flexible(
                                child: Text(userId, style: textStyleNormal))
                          ]),
                      const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("App-Version:", style: textStyleBold),
                            SizedBox(width: 10),
                            Flexible(
                                child: Text("1.0.0", style: textStyleNormal))
                          ])
                    ]),
                    PayeroButton(
                        text: "Logout",
                        onClick: () async {
                          final prefs = await SharedPreferences.getInstance();

                          prefs.clear();

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegistrationScreen(),
                              ));
                        }),
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
