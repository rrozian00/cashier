import 'package:flutter/material.dart';

Widget myTextField({
  String? suffix,
  String? label,
  String? hint,
  IconData? icon,
  TextEditingController? controller,
  TextInputType? textInputType,
  TextInputAction? textInputAction,
  TextCapitalization? textCapitalization,
}) {
  return TextField(
    textCapitalization: textCapitalization ?? TextCapitalization.words,
    keyboardType: textInputType,
    textInputAction: textInputAction ?? TextInputAction.next,
    controller: controller,
    decoration: InputDecoration(
      suffixText: suffix,
      labelText: label,
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon) : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );
}
