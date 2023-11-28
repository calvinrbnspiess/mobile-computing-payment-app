import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:mobile_computing_payment_app/widgets/payero_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QrCode extends StatelessWidget {
  final String? url;

  const QrCode({this.url, super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Stack(alignment: Alignment.center, children: [
      Container(
          constraints: const BoxConstraints(minHeight: 0, maxHeight: 200),
          padding: const EdgeInsets.all(4),
          margin: const EdgeInsets.only(top: 18, bottom: 26),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD6D6D6), width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(16))),
          child: url != null
              ? Image.network(url!)
              : new CircularProgressIndicator()),
      Positioned(
          bottom: 0,
          child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xff0FDFAF)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
              onPressed: () {
                if (url == null) return;

                debugPrint("Downloading image from $url");

                ImageDownloader.downloadImage(url!).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("QR-Code wurde gespeichert.")));
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Fehler beim Herunterladen.")));
                });
              },
              child: Text("Download")))
    ]));
  }
}
