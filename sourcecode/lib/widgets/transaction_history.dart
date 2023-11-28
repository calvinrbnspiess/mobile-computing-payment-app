import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_computing_payment_app/classes/Transaction.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(date,
            style: const TextStyle(
                color: Color(0xff5F6060), fontWeight: FontWeight.bold)),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(message,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Text(formattedAmount,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isPositiveTransaction
                      ? const Color(0xff0FDFAF)
                      : const Color(0xffDF0F0F)))
        ])
      ],
    );
  }
}

class TransactionHistory extends StatelessWidget {
  final List<Transaction> transactions = [];

  TransactionHistory({transactions, super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> transactionWidgets = [
      for (var item in transactions)
        TransactionEntry(
            date: item.createdAt!, message: item.message!, amount: item.amount!)
    ];

    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 30),
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFD6D6D6), width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      child: Wrap(runSpacing: 6, direction: Axis.vertical, children: [
        const Text(
          "Transaktionen",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        if (transactions.isEmpty)
          const Text(
            "Noch keine Transaktionen vorhanden",
          ),
        if (transactions.isEmpty)
          const SizedBox(
            height: 30,
          ),
        ...transactionWidgets
      ]),
    );
  }
}
