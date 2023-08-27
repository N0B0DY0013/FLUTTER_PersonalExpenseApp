import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;

  const TransactionList({
    super.key,
    required this.transactions,
    required this.deleteTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 480,
      //color: Colors.red,
      child: transactions.isEmpty
          ? LayoutBuilder(
              builder: (ctx, constraints) {
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        top: 20,
                      ),
                      child: const Text(
                        "No transactions",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      width: constraints.maxHeight * 0.7,
                      margin:  EdgeInsets.only(
                        top: constraints.maxHeight * 0.05,
                      ),
                      child: Image.asset(
                        'assets/images/cat1.png',
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                );
              },
            )
          : ListView.builder(
              itemBuilder: (ctx, idx) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text(
                            //transactions[idx].amount.toStringAsFixed(2),
                            NumberFormat("#,##0.00")
                                .format(transactions[idx].amount),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      transactions[idx].name,
                    ),
                    subtitle: Text(
                      DateFormat("dd-MMM-yyyy").format(
                        transactions[idx].date,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        deleteTransaction(transactions[idx].id);
                      },
                    ),
                  ),
                );
              },
              itemCount: transactions.length,
            ),
    );
  }
}
