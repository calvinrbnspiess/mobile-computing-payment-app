import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PayeroHeader extends StatelessWidget implements PreferredSizeWidget {
  const PayeroHeader({this.showBackButton = true, this.actions, super.key});
  final bool showBackButton;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.black, //change your color here
      ),
      title: SvgPicture.asset(
        'assets/images/payero-logo.svg',
        fit: BoxFit.scaleDown,
        alignment: Alignment.center,
        height: 50.0,
      ),
      backgroundColor: const Color(0xFFF3F5F7),
      centerTitle: true,
      automaticallyImplyLeading: false,
      actions: actions ?? [],
      elevation: 0,
      leading: showBackButton
          ? IconButton(
              onPressed: () {
                Navigator.maybePop(context);
              },
              icon: const Icon(
                Icons.arrow_back_outlined,
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
