import 'package:flutter/material.dart';
import 'package:personal_expense_app/widgets/add_transaction.dart';
// import 'package:intl/intl.dart';

import './models/transaction.dart';
//import './widgets/add_transaction.dart';
import './widgets/transaction_list.dart';
//import './widgets/transaction_stateful.dart';
import './widgets/chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Transaction> transactions = [];
  bool _showChart = false;

  List<Transaction> get recentTransactions {
    return transactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  void updateList(String name, String amount, DateTime txDate) {
    setState(() {
      transactions.add(
        Transaction(
            id: UniqueKey().toString(),
            name: name,
            amount: double.parse(amount),
            date: txDate),
      );
    });
  }

  void deleteTransaction(String id) {
    setState(() {
      transactions.removeWhere((tx) => tx.id == id);
    });
  }

  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (bctx) {
        return AddTransaction(
          updateList: updateList,
        );
      },
    );
  }

  Widget chartWidget(BuildContext ctx, AppBar appBar, double heightPercent) {
    return Container(
      height: (MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              appBar.preferredSize.height) *
          heightPercent,
      child: Chart(
        recentTransactions: recentTransactions,
      ),
    );
  }

  Widget transactionListWidget(
      BuildContext ctx, AppBar appBar, double heightPercent) {
    return Container(
      height: (MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              appBar.preferredSize.height) *
          heightPercent,
      child: TransactionList(
        transactions: transactions,
        deleteTransaction: deleteTransaction,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      // Here we take the value from the MyHomePage object that was created by
      // the App.build method, and use it to set our appbar title.
      title: const Text("Personal Expense"),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            startAddNewTransaction(context);
          },
        ),
      ],
    );

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLandscape)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Show Chart"),
                    Switch(
                        value: _showChart,
                        onChanged: (val) {
                          setState(() {
                            _showChart = val;
                          });
                        }),
                  ],
                ),
              if (isLandscape)
                if (_showChart) chartWidget(context, appBar, 1),
              if (isLandscape)
                if (_showChart == false)
                  transactionListWidget(context, appBar, 1),
              if (isLandscape == false) 
                chartWidget(context, appBar, 0.2),
              if (isLandscape == false)
                transactionListWidget(context, appBar, 0.8),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          startAddNewTransaction(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
