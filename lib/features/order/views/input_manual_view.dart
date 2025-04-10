import 'package:cashier/core/widgets/my_elevated.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/input_manual_controller.dart';

class InputManualView extends GetView<InputManualController> {
  const InputManualView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // actions: [
        //   IconButton(
        //       onPressed: () => controller.getId(), icon: Icon(Icons.get_app))
        // ],
        title: const Text('Input Manual'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Obx(
              () => TextField(
                readOnly: true,
                controller: TextEditingController(
                  text: controller.inputDate.value,
                ),
                decoration: InputDecoration(
                  labelText: "Tanggal Penjualan",
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
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
              height: 15,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Wrap(
                  children: [
                    myElevated(
                        onPress: () => controller.save(), text: "Simpan"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
