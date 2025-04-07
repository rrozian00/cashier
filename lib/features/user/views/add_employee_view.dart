import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cashier/core/widgets/my_appbar.dart';
import 'package:cashier/core/widgets/my_elevated.dart';
import 'package:cashier/core/widgets/my_text_field.dart';

import '../controllers/employee_controller.dart';

class AddEmployeeView extends GetView<EmployeeController> {
  const AddEmployeeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(titleText: "Tambah Karyawan"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              MyTextField(
                controller: controller.nameC,
                hint: "Nama",
              ),
              SizedBox(height: 10),
              MyTextField(
                  textCapitalization: TextCapitalization.none,
                  controller: controller.emailC,
                  textInputType: TextInputType.emailAddress,
                  hint: "Email"),
              SizedBox(height: 10),
              MyTextField(
                  textCapitalization: TextCapitalization.none,
                  controller: controller.passwordC,
                  hint: "Password"),
              SizedBox(height: 10),
              MyTextField(
                  controller: controller.phoneC,
                  textInputType: TextInputType.phone,
                  hint: "No HP"),
              SizedBox(height: 10),
              MyTextField(controller: controller.addressC, hint: "Alamat"),
              SizedBox(height: 10),
              MyTextField(
                  suffix: "( % )",
                  controller: controller.salaryC,
                  textInputType: TextInputType.phone,
                  hint: "Persentase Gaji"),
              SizedBox(height: 20),
              myPurpleElevated(
                  text: 'Simpan', onPress: () => controller.addEmployee()),
            ],
          ),
        ),
      ),
    );
  }
}

Widget myText(String text) {
  return Text(
    text,
    style: GoogleFonts.poppins(color: Colors.purple),
  );
}
