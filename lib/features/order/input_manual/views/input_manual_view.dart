import 'package:cashier/features/order/input_manual/bloc/input_manual_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class InputManualView extends StatelessWidget {
  InputManualView({super.key});

  final totalC = TextEditingController();
  final dateC = TextEditingController();

  final _keyForm = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocListener<InputManualBloc, InputManualState>(
      listener: (context, state) {
        if (state is InputManualSuccess) {
          totalC.clear();
          dateC.clear();

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Sukses !",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Text("Berhasil menambah data"),
                ],
              ),
            ),
          );
        }
        if (state is InputManualError) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Error !",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Text(state.message),
                ],
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Input Penjualan Manual'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 35),
            child: Form(
              key: _keyForm,
              child: ListView(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Tanggal Penjualan tidak boleh kosong";
                      }
                      return null;
                    },
                    clipBehavior: Clip.hardEdge,
                    readOnly: true,
                    controller: dateC,
                    decoration: InputDecoration(
                      // filled: true,
                      labelText: "Tanggal Penjualan",
                      suffixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                          // borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    onTap: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1990),
                        lastDate: DateTime.now(),
                      );

                      if (selectedDate != null) {
                        dateC.text =
                            "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Total Penjualan tidak boleh kosong";
                      }
                      return null;
                    },
                    controller: totalC,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Total Penjualan",
                      border: OutlineInputBorder(
                        // borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onChanged: (value) {
                      String rawValue =
                          value.replaceAll('.', '').replaceAll('Rp ', '');
                      int parsedValue = int.tryParse(rawValue) ?? 0;
                      totalC.text = parsedValue.toString();
                    },
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Wrap(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (_keyForm.currentState!.validate()) {
                                final dateFormat = DateFormat('dd-MM-yyyy');
                                final date = dateFormat.parse(dateC.text);

                                context.read<InputManualBloc>().add(
                                    AddInputManual(
                                        total: totalC.text, date: date));
                              }
                            },
                            child: Text("Simpan"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
