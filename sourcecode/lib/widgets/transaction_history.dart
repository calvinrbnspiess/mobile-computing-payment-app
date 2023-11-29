import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mobile_computing_payment_app/classes/Transaction.dart';

String truncateWithEllipsis(int cutoff, String myString) {
  return (myString.length <= cutoff)
      ? myString
      : '${myString.substring(0, cutoff)}...';
}

String getFriendlyTimeDifferenceFromNow(String timestamp) {
  DateTime now = DateTime.now();
  DateTime utcTime = DateTime.parse(timestamp);
  DateTime localTime = utcTime.toLocal();

  Duration difference = now.difference(localTime);

  if (difference.inSeconds < 60) {
    return 'Gerade eben';
  } else if (difference.inMinutes < 60) {
    return 'Vor ${difference.inMinutes} Minuten';
  } else if (difference.inHours < 24) {
    return DateFormat('HH:mm').format(localTime);
  } else {
    return DateFormat('dd.MM.yyyy HH:mm').format(localTime);
  }
}

class TransactionEntry extends StatelessWidget {
  final String date;
  final String message;
  final double amount;

  const TransactionEntry(
      {super.key, this.date = "", this.message = "", this.amount = 0.0});

  @override
  Widget build(BuildContext context) {
    var isPositiveTransaction = amount >= 0;
    var formattedAmount =
        '${isPositiveTransaction ? '+' : ''}${amount.toStringAsFixed(2)} €';

    return Container(
        margin: const EdgeInsets.only(bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(getFriendlyTimeDifferenceFromNow(date),
                style: const TextStyle(
                    color: Color(0xff5F6060), fontWeight: FontWeight.bold)),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(truncateWithEllipsis(20, message),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              Text(formattedAmount,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isPositiveTransaction
                          ? const Color(0xff0FDFAF)
                          : const Color(0xffDF0F0F)))
            ])
          ],
        ));
  }
}

class TransactionHistory extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionHistory({required this.transactions, super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> transactionWidgets = [
      for (var item in transactions.take(3))
        TransactionEntry(
            date: item.createdAt!, message: item.message!, amount: item.amount!)
    ];

    debugPrint("transactionHistory" + transactions.toString());

    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 15, right: 15),
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFD6D6D6), width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      child: Container(
          constraints: const BoxConstraints(
              minHeight: 210), // Minimum height for the container
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              "Letzte Transaktionen",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (transactions.isEmpty)
              const Text(
                "Noch keine Transaktionen vorhanden",
              ),
            ...transactionWidgets
          ])),
    );
  }
}
