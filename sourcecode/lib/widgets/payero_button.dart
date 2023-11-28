import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void emptyFunction() {}

class PayeroButton extends StatelessWidget {
  const PayeroButton({this.text = "", this.onClick = emptyFunction, super.key});
  final String text;
  final Function() onClick;

  @override
  Widget build(BuildContext context) {
    var borderRadius = BorderRadius.circular(16);

    return InkWell(
        onTap: () {
          onClick();
        },
        borderRadius: borderRadius,
        child: Ink(
            height: 66,
            decoration: BoxDecoration(
              color: const Color(0xff0FDFAF),
              borderRadius: borderRadius,
            ),
            child: Center(
              child: Text(text,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xff393939))),
            )));
  }
}
