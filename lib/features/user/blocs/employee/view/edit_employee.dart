import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/widgets/my_text_field.dart';
import '../bloc/employee_bloc.dart';

class EditEmployee extends StatefulWidget {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String salary;
  const EditEmployee({
    super.key,
    required this.id,
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
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            left: 10.0,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // homeIndicator(),
            Text(
              "Edit Karyawan",
              style: GoogleFonts.roboto(fontSize: 16),
            ),
            SizedBox(
              height: 25,
            ),
            MyTextField(
              label: "Nama",
              controller: nameC,
            ),
            MyTextField(
              label: "No HP",
              controller: phoneC,
            ),
            MyTextField(
              label: "Alamat",
              controller: addressC,
            ),
            MyTextField(
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
                ElevatedButton(
                  child: Text("Batal"),
                  onPressed: () => Navigator.pop(context),
                  // text: "Batal",
                  // width: 110,
                ),
                ElevatedButton(
                  // width: 110,
                  child: Text("Simpan"),
                  onPressed: () {
                    Navigator.pop(context);
                    context.read<EmployeeBloc>().add(EditEmployeePressed(
                          id: widget.id,
                          name: nameC.text,
                          address: addressC.text,
                          phone: phoneC.text,
                          salary: salaryC.text,
                        ));
                    context.read<EmployeeBloc>().add(GetEmployeeRequested());
                  },
                  // text: "Simpan",
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
