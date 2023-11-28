import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_computing_payment_app/constants.dart';
import 'package:mobile_computing_payment_app/widgets/payero_header.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:http/http.dart' as http;

class QRScanScreen extends StatefulWidget {
  final String userId;

  const QRScanScreen({super.key, required this.userId});

  @override
  State<QRScanScreen> createState() => _QRScanScreenState(userId: userId);
}

class _QRScanScreenState extends State<QRScanScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool _screenOpened = false;
  final String userId;

  _QRScanScreenState({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PayeroHeader(showBackButton: true, actions: [
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
        )
      ]),
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
                    screenClosed: _screenWasClosed,
                    userId: userId,
                    value: code),
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
  final String userId;

  const FoundCodeScreen({
    Key? key,
    required this.userId,
    required this.value,
    required this.screenClosed,
  }) : super(key: key);

  @override
  State<FoundCodeScreen> createState() => _FoundCodeScreenState();
}

class _FoundCodeScreenState extends State<FoundCodeScreen> {
  String currency = "EUR";

  void startBraintreeCheckout() async {
    var request = BraintreeDropInRequest(
      tokenizationKey: 'sandbox_d53t3dpq_8fxhdjy2nrd33mtm',
      collectDeviceData: true,
      paypalRequest: BraintreePayPalRequest(
        amount: '10.00',
        displayName: 'Payero',
        currencyCode: currency,
      ),
      googlePaymentRequest: BraintreeGooglePaymentRequest(
        totalPrice: '10.00',
        currencyCode: currency,
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
        currencyCode: currency,
        countryCode: 'DE',
        merchantIdentifier:
            'merchant.com.example.mobile_computing_payment_app', // Ersetzen Sie dies mit Ihrem Apple Pay Merchant Identifier
        supportedNetworks: [
          ApplePaySupportedNetworks.visa,
          ApplePaySupportedNetworks.masterCard,
          ApplePaySupportedNetworks.amex
        ],
      ),
      // Weitere Optionen und Konfigurationen
    );
    try {
      BraintreeDropInResult? result = await BraintreeDropIn.start(request);
      if (result != null) {
        print('Zahlung erfolgreich: ${result.paymentMethodNonce.description}');
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bearbeite Zahlungsvorgang')));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Zahlung erfolgreich: ${result.paymentMethodNonce.description}')));
        // Weitere Aktionen nach erfolgreicher Zahlung

        try {
          final response = await http.post(
              Uri.parse("$SERVER_URL/${widget.userId}/transact"),
              body: jsonEncode(<String, String>{
                "receiver": "mobile_computing_payment_app",
                "amount": "0",
                "currency": currency,
                "message":
                    "${result.paymentMethodNonce.typeLabel} - ${result.paymentMethodNonce.description}"
              }));

          debugPrint("response: " + response.body);

          if (response.statusCode != 200) {
            throw Exception('Failed to save transaction.' + response.body);
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Zahlvorgang abgebrochen')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Zahlvorgang abgebrochen. Stellen Sie sicher, dass Sie eine Internetverbindung haben. Fehler: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PayeroHeader(showBackButton: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Zu bezahlender Betrag:",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                '${widget.value} €',
                style: const TextStyle(
                  fontSize: 40,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: startBraintreeCheckout,
                child: const Text('Bezahlen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
