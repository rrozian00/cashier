import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/core/widgets/home_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cashier/features/user/controllers/employee_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailEmlpoyee extends GetView<EmployeeController> {
  final int index;

  const DetailEmlpoyee({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final data = controller.listEmployee[index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            homeIndicator(),
            _buildTable(name: "Nama", value: data.name),
            _buildTable(name: "Alamat", value: data.address),
            _buildTable(name: "Email", value: data.email),
            _buildTable(name: "No HP", value: data.phoneNumber),
            _buildTable(name: "Gaji", value: "${data.salary} %"),
          ],
        ),
      ),
    );
  }

  Widget _buildTable({
    String? name,
    String? value,
  }) {
    return Table(
      // border: TableBorder.all(color: black, width: 15),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(3),
      },
      children: [
        TableRow(children: [
          Text(
            name ?? '',
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: blue,
            ),
          ),
          Text(
            value ?? '',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: purple,
            ),
          ),
        ]),
        TableRow(children: [
          // SizedBox(height: 12),
          // SizedBox(height: 12),
          Divider(),
          Divider(),
        ]),
      ],
    );
  }
}
