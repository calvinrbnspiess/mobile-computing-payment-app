import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_computing_payment_app/pages/main_screen.dart';
import 'package:mobile_computing_payment_app/widgets/payero_button.dart';
import 'package:mobile_computing_payment_app/widgets/payero_header.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() {
    return RegistrationScreenState();
  }
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> textFieldsValue = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PayeroHeader(
          showBackButton: false,
        ),
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
                      "Registrierung",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Bitte überlasse uns einen Namen';
                                }

                                textFieldsValue.putIfAbsent(
                                    'nickname', () => value);
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: 'Nickname',
                              ),
                            ),
                            TextFormField(
                              validator: (value) {
                                var emailIsValid =
                                    EmailValidator.validate(value ?? "");

                                if (emailIsValid) {
                                  textFieldsValue.putIfAbsent(
                                      'email', () => value);
                                }

                                return emailIsValid
                                    ? null
                                    : "Bitte überprüfe deine E-Mail-Adresse";
                              },
                              decoration: const InputDecoration(
                                hintText: 'E-Mail',
                              ),
                            )
                          ],
                        ))
                  ],
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
                child: Column(children: [
                  PayeroButton(
                    text: "Registrierung abschließen",
                    onClick: () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      Future(() async {
                        try {
                          final response = await http.post(
                              Uri.parse("http://localhost:3000/register"),
                              body: jsonEncode(<String, String>{
                                'nickname': textFieldsValue['nickname'],
                                'email': textFieldsValue['email'],
                              }));

                          if (response.statusCode != 200) {
                            throw Exception('Failed to create user account.');
                          }

                          final prefs = await SharedPreferences.getInstance();
                          final Map parsed = json.decode(response.body);

                          prefs.setString('user_id', parsed['id']);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Registrierung erfolgreich: ' + parsed['id']),
                            ),
                          );
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MainScreen(),
                              ));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Es ist ein Fehler aufgetreten. Bitte versuche es später erneut.'),
                            ),
                          );
                        }
                      });
                    },
                  )
                ]))
          ]),
        ]));
  }
}
