// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyDatePicker extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final Function(String) onDateSelected;
  final String? Function(String?)? validator;

  const MyDatePicker({
    super.key,
    required this.labelText,
    required this.controller,
    required this.onDateSelected,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Membuka dialog DatePicker
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        // Jika tanggal dipilih
        if (pickedDate != null) {
          // Format tanggal ke string (yyyy-MM-dd)
          String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

          // Set nilai ke controller
          controller.text = formattedDate;

          // Kirim tanggal ke callback
          onDateSelected(formattedDate);
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          validator: validator,
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            suffixIcon: Icon(Icons.calendar_today),
          ),
        ),
      ),
    );
  }
}
