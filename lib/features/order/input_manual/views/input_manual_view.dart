import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/input_manual_controller.dart';

class InputManualView extends GetView<InputManualController> {
  const InputManualView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Penjualan Manual'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 35),
          child: ListView(
            children: [
              Obx(
                () => TextField(
                  clipBehavior: Clip.hardEdge,
                  readOnly: true,
                  controller: TextEditingController(
                    text: controller.inputDate.value,
                  ),
                  decoration: InputDecoration(
                    // filled: true,
                    labelText: "Tanggal Penjualan",
                    suffixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
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
                      controller.inputDate.value =
                          "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
                    }
                  },
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: controller.totalC,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Total Penjualan",
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onChanged: (value) {
                  String rawValue =
                      value.replaceAll('.', '').replaceAll('Rp ', '');
                  int parsedValue = int.tryParse(rawValue) ?? 0;
                  controller.total.value = parsedValue.toString();
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
                        onPressed: () => controller.save(),
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
    );
  }
}
