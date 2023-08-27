import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

//import '../main.dart';
import '../models/transaction.dart';

import './chart_bar.dart';

class Chart extends StatelessWidget {

  final List<Transaction> recentTransactions;

  const Chart({super.key, required this.recentTransactions});

  List<Map<String, Object>> get groupedTransactionValues {
    List<Map<String, Object>> myList = [];

    double totalSum = 0;
    DateTime currDay;

    for (int i = 0; i < 7; i++) {
      totalSum = 0;

      currDay = DateTime.now().subtract(Duration(days: i));

      recentTransactions.forEach((tx) {
        if (DateFormat("yyyy-MM-dd").format(tx.date).toString() ==
            DateFormat("yyyy-MM-dd").format(currDay).toString()) {
          totalSum = tx.amount + totalSum;
        }
      });

      myList.add({
        "day": DateFormat("E").format(currDay).toString().substring(0, 2),
        "amount": totalSum
      });

      //_totalSpent = _totalSpent + totalSum;

    }

    return myList.reversed.toList();
  }

  double get TotalSpent {
    return groupedTransactionValues.fold(0.0, (previousValue, element) {
      return previousValue + double.parse(element['amount'].toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Flexible(
        fit: FlexFit.tight, 
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactionValues.map((tx) {
              //return Text("${tx['day']} ${tx['amount']}");
              return ChartBar(
                  dayLabel: tx['day'].toString(),
                  spentAmount: double.parse(tx['amount'].toString()),
                  percentOfSpentAmount: TotalSpent == 0 ? 0 : (double.parse(tx['amount'].toString())) / TotalSpent );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
