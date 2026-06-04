import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/rupiah_converter.dart';
import '../controllers/expense_controller.dart';
import '../widgets/add_expense.dart';

class ExpenseView extends GetView<ExpenseController> {
  const ExpenseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengeluaran'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: ListView.builder(
            itemCount: controller.expenselist.length,
            itemBuilder: (context, index) {
              final data = controller.expenselist[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                child: Card(
                  color: Theme.of(context).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    title: Text("Pengeluaran Tanggal: ${data.date ?? '-'}"),
                    subtitle: Text(
                      rupiahConverter(int.tryParse(data.pay ?? '-') ?? 0),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        // height: 45,
        // width: 180,
        onPressed: () => showDialog(
          context: context,
          builder: (context) {
            return AddExpense();
          },
        ),
        // text: "Tambah",
        child: Text("Tambah"),
      ),
    );
  }
}
