import '../../../core/utils/rupiah_converter.dart';
import '../../../core/widgets/my_date_picker.dart';
import '../../../core/widgets/my_elevated.dart';
import '../bloc/expense_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddExpense extends StatelessWidget {
  AddExpense({super.key});

  final dateC = TextEditingController();
  final payC = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExpenseBloc, ExpenseState>(
      listener: (context, state) {
        if (state is ExpenseLoading) {
          Navigator.pop(context);
        }
      },
      child: Form(
        key: _formKey,
        child: Dialog(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Text(
                    "Tambah Pengeluaran",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                MyDatePicker(
                  validator: (value) {
                    if (dateC.text.isEmpty) {
                      return "Tanggal tidak boleh kosong";
                    }
                    return null;
                  },
                  labelText: "Tanggal",
                  controller: dateC,
                  onDateSelected: (value) => dateC.text = value,
                ),
                SizedBox(height: 8),
                TextFormField(
                  validator: (value) {
                    if (payC.text.isEmpty) {
                      return "Total belanja tidak boleh kosong";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  controller: payC,
                  onChanged: (value) {
                    String rawValue = value.replaceAll(RegExp(r'[^\d]'), '');
                    int parseValue = int.tryParse(rawValue) ?? 0;

                    value = rupiahConverter(parseValue);
                    payC.selection =
                        TextSelection.collapsed(offset: payC.text.length);
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    label: Text("Total Belanja"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      myRedElevated(
                        width: 120,
                        text: "Batal",
                        onPress: () {
                          Navigator.pop(context);
                        },
                      ),
                      myGreenElevated(
                          width: 120,
                          text: "Simpan",
                          onPress: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<ExpenseBloc>().add(
                                  ExpenseAddRequested(
                                      date: dateC.text, pay: payC.text));
                            }
                          }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
