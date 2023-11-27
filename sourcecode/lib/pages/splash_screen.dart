import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_computing_payment_app/pages/main_screen.dart';
import 'package:mobile_computing_payment_app/pages/registration_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

var logo = SvgPicture.asset('assets/images/payero-logo-vertical-with-title.svg',
    semanticsLabel: 'Payero App');

Future<bool> checkIfUserExists() async {
  final prefs = await SharedPreferences.getInstance();
  final id = prefs.getString('user_id');

  return id != null;
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void transitionToScreen(BuildContext context, Widget screen) {
    Timer(const Duration(milliseconds: 1500), () {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => screen,
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              final tween = Tween(begin: begin, end: end);
              final offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    Future(() async {
      if (await checkIfUserExists()) {
        transitionToScreen(context, const MainScreen());
      } else {
        transitionToScreen(context, const RegistrationScreen());
      }
    });

    return Scaffold(body: Center(child: logo));
  }
}
