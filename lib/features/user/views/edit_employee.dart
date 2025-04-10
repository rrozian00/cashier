import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/core/widgets/home_indicator.dart';
import 'package:cashier/core/widgets/my_elevated.dart';
import 'package:cashier/core/widgets/my_text_field.dart';
import 'package:cashier/features/user/controllers/employee_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EditEmployee extends GetView<EmployeeController> {
  final int index;

  const EditEmployee({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final data = controller.listEmployee[index];

    controller.nameC.value = data.name ?? '';
    controller.addressC.value = data.address ?? '';
    controller.phoneC.value = data.phoneNumber ?? '';
    controller.salaryC.value = data.salary ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            homeIndocator(),
            Text(
              "Edit Karyawan",
              style: GoogleFonts.roboto(color: purple, fontSize: 16),
            ),
            SizedBox(
              height: 25,
            ),
            MyTextField(
              label: "Nama",
              controller: controller.nameC,
            ),
            MyTextField(
              label: "No HP",
              controller: controller.phoneC,
            ),
            MyTextField(
              label: "Alamat",
              controller: controller.addressC,
            ),
            MyTextField(
              suffix: "%",
              label: "Gaji",
              controller: controller.salaryC,
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                myRedElevated(
                  width: 110,
                  onPress: () => Get.back(),
                  text: "Batal",
                ),
                myGreenElevated(
                    width: 110,
                    onPress: () async => await controller.edit(data),
                    text: "Simpan"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
