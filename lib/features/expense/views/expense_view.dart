import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/core/widgets/my_appbar.dart';
import 'package:cashier/core/utils/rupiah_converter.dart';
import 'package:cashier/core/widgets/my_elevated.dart';
import 'package:cashier/core/widgets/no_data.dart';
import 'package:cashier/features/expense/bloc/expense_bloc.dart';
import 'package:cashier/features/expense/widgets/add_expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseView extends StatelessWidget {
  const ExpenseView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ExpenseBloc>().add(ExpenseGetRequested());
    return Scaffold(
      backgroundColor: softGrey,
      appBar: MyAppBar(
        titleText: 'Pengeluaran',
      ),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (state is ExpenseAddSucces) {
            context.read<ExpenseBloc>().add(ExpenseGetRequested());
          }

          if (state is ExpenseFailed) {
            return Center(child: Text("Gagal memuat data: ${state.message}"));
          }

          if (state is ExpenseGetSucces) {
            if (state.expenses.isEmpty) {
              return noData(
                  title: "Data pengeluaran kosong",
                  message: "Silahkan tambah data");
            }

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ListView.builder(
                  itemCount: state.expenses.length,
                  itemBuilder: (context, index) {
                    final data = state.expenses[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: grey),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          title:
                              Text("Pengeluaran Tanggal: ${data.date ?? '-'}"),
                          subtitle: Text(
                            rupiahConverter(int.tryParse(data.pay ?? '-') ?? 0),
                            style: const TextStyle(
                              color: Colors.red,
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
            );
          }

          return const SizedBox(); // fallback default
        },
      ),
      floatingActionButton: myPurpleElevated(
          height: 45,
          width: 180,
          onPress: () => showDialog(
                context: context,
                builder: (context) {
                  return AddExpense();
                },
              ),
          text: "Tambah"),
    );
  }
}
