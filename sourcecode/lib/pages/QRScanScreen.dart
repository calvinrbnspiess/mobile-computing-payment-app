// import 'dart:html';
// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_braintree/flutter_braintree.dart';

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({super.key});

  @override
  State<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool _screenOpened = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/images/payero-logo.svg',
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          height: 50.0,
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF3F5F7),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state as TorchState) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state as CameraFacing) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front, color: Colors.grey);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear, color: Colors.grey);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        startDelay: true,
        controller: cameraController,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty && !_screenOpened) {
            final String code = barcodes.first.rawValue ?? "---";
            debugPrint('QRCode found! $code');
            _screenOpened = true;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FoundCodeScreen(
                    screenClosed: _screenWasClosed, value: code),
              ),
            );
          }
        },
      ),
    );
  }

  void _screenWasClosed() {
    _screenOpened = false;
  }
}

class FoundCodeScreen extends StatefulWidget {
  final String value;
  final Function() screenClosed;
  const FoundCodeScreen({
    Key? key,
    required this.value,
    required this.screenClosed,
  }) : super(key: key);

  @override
  State<FoundCodeScreen> createState() => _FoundCodeScreenState();
}

// class _FoundCodeScreenState extends State<FoundCodeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: SvgPicture.asset('assets/images/payero-logo.svg',
//         fit: BoxFit.scaleDown,
//         alignment: Alignment.center,
//         height: 50.0,
//         ),
//         backgroundColor: const Color(0xFFF3F5F7),
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () {
//             widget.screenClosed();
//             Navigator.pop(context);
//           },
//           icon: const Icon(Icons.arrow_back_outlined,),
//         ),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text("Scanned Code:", style: TextStyle(fontSize: 20,),),
//               SizedBox(height: 20,),
//               Text(widget.value, style: TextStyle(fontSize: 16,),),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_braintree/flutter_braintree.dart';

class _FoundCodeScreenState extends State<FoundCodeScreen> {
  void startBraintreeCheckout() async {
    var request = BraintreeDropInRequest(
      tokenizationKey: 'sandbox_d53t3dpq_8fxhdjy2nrd33mtm',
      collectDeviceData: true,
      paypalRequest: BraintreePayPalRequest(
        amount: '10.00',
        displayName: 'Payero',
        currencyCode: 'EUR',
      ),
      googlePaymentRequest: BraintreeGooglePaymentRequest(
        totalPrice: '10.00',
        currencyCode: 'EUR',
        billingAddressRequired: false,
      ),
      applePayRequest: BraintreeApplePayRequest(
        paymentSummaryItems: [
          ApplePaySummaryItem(
              label: 'Payero',
              amount: 10.00,
              type: ApplePaySummaryItemType.final_)
        ],
        displayName: 'Payero',
        currencyCode: 'EUR',
        countryCode: 'DE',
        merchantIdentifier:
            'merchant.com.yourcompany.yourapp', // Ersetzen Sie dies mit Ihrem Apple Pay Merchant Identifier
        supportedNetworks: [
          ApplePaySupportedNetworks.visa,
          ApplePaySupportedNetworks.masterCard,
          ApplePaySupportedNetworks.amex
        ],
      ),
      // Weitere Optionen und Konfigurationen
    );

    BraintreeDropInResult? result = await BraintreeDropIn.start(request);
    if (result != null) {
      print('Zahlung erfolgreich: ${result.paymentMethodNonce.description}');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bearbeite Zahlungsvorgang')));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Zahlung erfolgreich: ${result.paymentMethodNonce.description}')));
      // Weitere Aktionen nach erfolgreicher Zahlung
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Zahlung abgebrochen')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/images/payero-logo.svg',
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          height: 50.0,
        ),
        backgroundColor: const Color(0xFFF3F5F7),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            widget.screenClosed();
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_outlined,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Scanned Code:",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                widget.value,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: startBraintreeCheckout,
                child: Text('Bezahlen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
