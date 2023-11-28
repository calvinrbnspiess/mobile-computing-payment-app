import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_computing_payment_app/pages/settings_screen.dart';

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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SettingsScreen(),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
