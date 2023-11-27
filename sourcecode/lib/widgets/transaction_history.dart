import 'package:flutter/widgets.dart';

class TransactionEntry extends StatelessWidget {
  final String date;
  final String name;
  final double amount;

  const TransactionEntry(
      {super.key, this.date = "", this.name = "", this.amount = 0.0});

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
          Text(name,
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
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 30),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFD6D6D6), width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      child: const Wrap(runSpacing: 6, children: [
        Text(
          "Transaktionen",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        TransactionEntry(
            date: "09.11.2023 13:34 Uhr",
            name: "Max Mustermann",
            amount: -55.00),
        TransactionEntry(
            date: "26.10.2023 17:21 Uhr", name: "Tim Müller", amount: 24.12),
        TransactionEntry(
            date: "13.07.2023 09:12 Uhr", name: "Felix Schmidt", amount: 13.77)
      ]),
    );
  }
}
