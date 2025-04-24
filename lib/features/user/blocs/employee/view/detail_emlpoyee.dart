import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/core/widgets/home_indicator.dart';
import 'package:cashier/features/user/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailEmlpoyee extends StatelessWidget {
  const DetailEmlpoyee({
    super.key,
    required this.data,
  });

  final UserModel data;
  @override
  Widget build(BuildContext context) {
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
              color: brown,
            ),
          ),
          Text(
            ": $value",
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: black,
            ),
          ),
        ]),
        TableRow(children: [
          Divider(),
          Divider(),
        ]),
      ],
    );
  }
}
