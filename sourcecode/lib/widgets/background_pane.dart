import 'package:flutter/widgets.dart';

class BackgroundPane extends StatelessWidget {
  const BackgroundPane({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 0,
        right: 0,
        top: 0,
        bottom: MediaQuery.of(context).size.height * 0.33,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: const Color(0xFFF3F5F7),
              border: Border.all(color: const Color(0xFFD6D6D6), width: 1),
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24))),
        ));
  }
}
