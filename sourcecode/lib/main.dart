import 'package:flutter/material.dart';
import 'package:mobile_computing_payment_app/pages/splash_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: const SplashScreen(),
        theme: ThemeData(fontFamily: 'Nunito'),
        debugShowCheckedModeBanner: false);
  }
}
