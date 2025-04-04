import 'package:cashier/core/widgets/my_elevated.dart';
import 'package:cashier/core/utils/rupiah_converter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/expense_controller.dart';

class ExpenseView extends GetView<ExpenseController> {
  const ExpenseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // actions: [
        //   IconButton(
        //       onPressed: () => moveExpenseToFirebase(),
        //       icon: Icon(Icons.move_down_rounded)),
        // ],
        title: const Text('Pengeluaran'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.listExpense.isEmpty) {
          return Center(
            child: Text("Data Kosong"),
          );
        }

        return ListView.builder(
          itemCount: controller.listExpense.length,
          itemBuilder: (context, index) {
            final data = controller.listExpense[index];
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  title: Text("Pengeluaran Tanggal: ${data.date ?? '-'}"),
                  subtitle: Text(
                    rupiahConverter(int.tryParse(data.pay ?? '-') ?? 0),
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton:
          myElevated(onPress: () => controller.addDialog(), text: "Tambah"),
    );
  }
}
