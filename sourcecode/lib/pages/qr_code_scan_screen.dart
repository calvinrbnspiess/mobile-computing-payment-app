import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_computing_payment_app/pages/end_screen.dart';
import 'package:mobile_computing_payment_app/widgets/payero_button.dart';
import 'package:mobile_computing_payment_app/widgets/payero_header.dart';
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
                    screenClosed: _screenWasClosed, value: code),
              ),
            ).then((_) {
              // Diese Zeile wird ausgeführt, wenn FoundCodeScreen geschlossen wird
              _screenWasClosed();
            });
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

class _FoundCodeScreenState extends State<FoundCodeScreen> {
  void startBraintreeCheckout() async {
    var request = BraintreeDropInRequest(
      tokenizationKey: 'sandbox_d53t3dpq_8fxhdjy2nrd33mtm',
      collectDeviceData: true,
      paypalRequest: BraintreePayPalRequest(
        amount: widget.value,
        displayName: 'Payero',
        currencyCode: 'EUR',
      ),
      googlePaymentRequest: BraintreeGooglePaymentRequest(
        totalPrice: widget.value,
        currencyCode: 'EUR',
        billingAddressRequired: false,
      ),
      applePayRequest: BraintreeApplePayRequest(
        paymentSummaryItems: [
          ApplePaySummaryItem(
              label: 'Payero',
              amount: double.parse(widget.value),
              type: ApplePaySummaryItemType.final_)
        ],
        displayName: 'Payero',
        currencyCode: 'EUR',
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
        // print(
        //     'Zahlung erfolgreich: ${result.paymentMethodNonce.typeLabel} ${result.paymentMethodNonce.description}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Bearbeite Zahlungsvorgang mit ${result.paymentMethodNonce.typeLabel} ${result.paymentMethodNonce.description}'),
              duration: const Duration(seconds: 2)),
        );

        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text(
        //       'Zahlung erfolgreich: ${result.paymentMethodNonce.typeLabel} ${result.paymentMethodNonce.description}'),
        //   duration: const Duration(seconds: 2),
        // ));

        await Future.delayed(const Duration(seconds: 3));

        Navigator.push(context,
            MaterialPageRoute(builder: (_) => EndScreen(value: widget.value)));

        // Weitere Aktionen nach erfolgreicher Zahlung
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Zahlungsvorgang abgebrochen'),
            duration: Duration(seconds: 2)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Zahlungsvorgang abgebrochen. Stellen Sie sicher, dass Sie mit dem Internet verbunden sind. \n\n Fehler: $e')));
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
                height: 30,
              ),
              Text(
                '${widget.value} €',
                style: const TextStyle(
                  fontSize: 40,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              PayeroButton(
                onClick: startBraintreeCheckout,
                text: 'Jetzt Bezahlen',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
