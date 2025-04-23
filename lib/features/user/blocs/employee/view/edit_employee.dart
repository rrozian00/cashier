// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cashier/features/user/blocs/employee/bloc/employee_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/core/widgets/home_indicator.dart';
import 'package:cashier/core/widgets/my_elevated.dart';
import 'package:cashier/core/widgets/my_text_field.dart';

class EditEmployee extends StatefulWidget {
  final String name;
  final String address;
  final String phone;
  final String salary;
  const EditEmployee({
    super.key,
    required this.name,
    required this.address,
    required this.phone,
    required this.salary,
  });

  @override
  State<EditEmployee> createState() => _EditEmployeeState();
}

class _EditEmployeeState extends State<EditEmployee> {
  final TextEditingController nameC = TextEditingController();
  final TextEditingController addressC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();
  final TextEditingController salaryC = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameC.text = widget.name;
    addressC.text = widget.address;
    phoneC.text = widget.phone;
    salaryC.text = widget.salary;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            homeIndicator(),
            Text(
              "Edit Karyawan",
              style: GoogleFonts.roboto(color: purple, fontSize: 16),
            ),
            SizedBox(
              height: 25,
            ),
            MyText(
              label: "Nama",
              controller: nameC,
            ),
            MyText(
              label: "No HP",
              controller: phoneC,
            ),
            MyText(
              label: "Alamat",
              controller: addressC,
            ),
            MyText(
              suffix: "%",
              label: "Gaji",
              controller: salaryC,
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
                    onPress: () {
                      context.read<EmployeeBloc>().add(EditEmployeePressed(
                            name: nameC.text,
                            address: addressC.text,
                            phone: phoneC.text,
                            salary: salaryC.text,
                          ));
                    },
                    text: "Simpan"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
