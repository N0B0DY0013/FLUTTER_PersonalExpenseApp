import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTransaction extends StatefulWidget {
  final Function updateList;

  const AddTransaction({super.key, required this.updateList});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final _txfNameController = TextEditingController();
  final _txfAmountController = TextEditingController();

  var txDate = null;

  bool _calIsEmpty = true;
  bool _nameIsEmpty = true;
  bool _amountIsEmpty = true;

  void _submitData(BuildContext ctx) {
    final inputName = _txfAmountController.text;
    final inputAmount = _txfAmountController.text;

    if (inputName.isNotEmpty && inputAmount.isNotEmpty && txDate != null) {
      widget.updateList(
        _txfNameController.text,
        _txfAmountController.text,
        txDate,
      );
    }

    Navigator.of(ctx).pop();
  }

  void _showDate(BuildContext ctx) {
    showDatePicker(
      context: ctx,
      initialDate: DateTime.now(),
      firstDate: DateTime(int.parse(DateFormat("yyyy").format(DateTime.now()))),
      lastDate: DateTime(
          int.parse(DateFormat("yyyy").format(DateTime.now())), 12, 31),
    ).then((selectedDate) {
      if (selectedDate == null) {
        return;
      }
      setState(() {
        txDate = selectedDate;
        _calIsEmpty = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _txfNameController.addListener(() {
      setState(() {
        _nameIsEmpty = _txfNameController.text.isEmpty;
      });
    });

    _txfAmountController.addListener(() {
      setState(() {
        _amountIsEmpty = _txfAmountController.text.isEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        //height: 800,
        child: LayoutBuilder(
          builder: (ctx, constraints) {
            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Name",
                      ),
                      controller: _txfNameController,
                      onSubmitted: (_) => _submitData(context),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Amount",
                      ),
                      controller: _txfAmountController,
                      keyboardType: TextInputType.number,
                      onSubmitted: (_) => _submitData(context),
                    ),
                    SizedBox(
                      height: constraints.maxHeight * 0.05,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(txDate == null
                              ? "Please select a date"
                              : DateFormat("dd-MMM-yyyy").format(txDate)),
                        ),
                        TextButton(
                          onPressed: () {
                            _showDate(context);
                          },
                          child: const Text(
                            "Choose Date",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: constraints.maxHeight * 0.05,
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          (_nameIsEmpty || _amountIsEmpty || _calIsEmpty)
                              ? null
                              : _submitData(context),
                      child: const Text("Add Transaction"),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
