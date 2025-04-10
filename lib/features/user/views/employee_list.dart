import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/core/widgets/my_appbar.dart';
import 'package:cashier/core/widgets/my_elevated.dart';
import 'package:cashier/core/widgets/no_data.dart';
import 'package:cashier/features/user/controllers/employee_controller.dart';
import 'package:cashier/features/user/views/add_employee_view.dart';
import 'package:cashier/features/user/views/detail_emlpoyee.dart';
import 'package:cashier/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeeListView extends GetView<EmployeeController> {
  const EmployeeListView({super.key});

  @override
  Widget build(BuildContext context) {
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
            final data = controller.listEmployee[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${index + 1}",
                    style: GoogleFonts.roboto(
                      color: blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 5),
                  Flexible(
                    child: Card(
                      elevation: 4,
                      borderOnForeground: true,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: grey),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        onTap: () {
                          Get.bottomSheet(
                              clipBehavior: Clip.hardEdge,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                              DetailEmlpoyee(index: index));
                        },
                        trailing: Wrap(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.edit,
                                color: blue,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.delete,
                                color: red,
                              ),
                            ),
                          ],
                        ),
                        title: myText(data.name ?? ''),
                        subtitle: myText(data.email ?? ''),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: myPurpleElevated(
          onPress: () => Get.toNamed(Routes.addEmployee),
          text: "Tambah Karyawan"),
    );
  }
}
