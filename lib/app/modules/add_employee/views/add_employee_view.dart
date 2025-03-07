import 'dart:io';

import 'package:cashier/app/data/model/user_model.dart';
import 'package:cashier/app/modules/profile/controllers/profile_controller.dart';
import 'package:cashier/utils/my_appbar.dart';
import 'package:cashier/utils/my_elevated.dart';
import 'package:cashier/utils/my_text_field.dart';
import 'package:cashier/utils/no_data.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_employee_controller.dart';

class EmployeeView extends GetView<AddEmployeeController> {
  const EmployeeView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profile = Get.find();
    return Scaffold(
      appBar: MyAppBar(
        titleText: "Daftar Karyawan",
      ),
      body: Obx(() {
        if (controller.listEmployee.isEmpty) {
          return noData(
              title: "Tidak ada data Karyawan",
              message: "Silahkan Tambah Karyawan");
        }
        return ListView.builder(
          itemCount: controller.listEmployee.length,
          itemBuilder: (context, index) {
            final data = controller.listEmployee[index] as UserModel;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  spacing: 10,
                  children: [
                    ClipOval(
                      child: data.photo != null && data.photo != ''
                          ? Image.file(
                              File(data.photo ?? ''),
                              width: 60,
                              // height: 30,
                            )
                          : Icon(
                              Icons.person,
                              size: 60,
                            ),
                    ),
                    Expanded(
                      child: Table(
                        columnWidths: {
                          0: FlexColumnWidth(5),
                          1: FlexColumnWidth(1),
                          2: FlexColumnWidth(20),
                        },
                        children: [
                          _buildTableRow(label: "Nama", value: data.name),
                          _buildTableRow(label: "E-mail", value: data.email),
                          _buildTableRow(
                              label: "No Hp", value: data.phoneNumber),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
            );
          },
        );
      }),
      floatingActionButton: myElevated(
          onPress: () => Get.to(() => AddEmployeeView()),
          child: Text("Tambah Karyawan")),
    );
  }
}

class AddEmployeeView extends GetView<AddEmployeeController> {
  const AddEmployeeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
          //   actions: [
          //   TextButton(
          //       onPressed: () => controller.getEmployee(), child: Text("GET")),
          //   TextButton(
          //       onPressed: () => Get.to(() => EmployeeView()), child: Text("view"))
          // ],
          titleText: "Tambah Karyawan"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              myTextField(
                controller: controller.nameC,
                hint: "Nama",
              ),
              SizedBox(height: 10),
              myTextField(
                  textCapitalization: TextCapitalization.none,
                  controller: controller.emailC,
                  textInputType: TextInputType.emailAddress,
                  hint: "Email"),
              SizedBox(height: 10),
              myTextField(
                  textCapitalization: TextCapitalization.none,
                  controller: controller.passwordC,
                  hint: "Password"),
              SizedBox(height: 10),
              myTextField(
                  controller: controller.phoneC,
                  textInputType: TextInputType.phone,
                  hint: "No HP"),
              SizedBox(height: 10),
              myTextField(controller: controller.addressC, hint: "Alamat"),
              SizedBox(height: 10),
              myTextField(
                  suffix: "( % )",
                  controller: controller.salaryC,
                  textInputType: TextInputType.phone,
                  hint: "Persentase Gaji"),
              SizedBox(height: 20),
              Obx(() => myElevated(
                    // text: 'Tambah',
                    onPress: controller.isLoading.value
                        ? null
                        : controller.addEmployee,
                    child: controller.isLoading.value
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Simpan"),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

TableRow _buildTableRow({
  String? label,
  String colon = ":",
  String? value,
}) {
  return TableRow(children: [
    Text(label ?? '-'),
    Text(colon),
    Text(value ?? '-'),
  ]);
}
