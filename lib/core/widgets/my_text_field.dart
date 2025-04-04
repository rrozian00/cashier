import 'package:cashier/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextField extends StatelessWidget {
  final RxString controller;
  final bool readOnly;
  final TextCapitalization textCapitalization;
  final String hint;
  final String? suffix;
  final Widget? suffixWidget;
  final Widget? suffixIcon;
  final String? label;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final bool obscure;
  final bool filled;
  final int? max;
  final int maxLines;
  final Color? fill;

  const MyTextField({
    super.key,
    required this.controller,
    this.readOnly = false,
    this.fill,
    this.textCapitalization = TextCapitalization.words,
    this.hint = '',
    this.suffix,
    this.suffixIcon,
    this.label,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscure = false,
    this.filled = true,
    this.max,
    this.suffixWidget,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final textEditingController = TextEditingController(text: controller.value);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            // ✅ Perbaikan: Menjaga posisi kursor
            final cursorPosition = textEditingController.selection.baseOffset;
            textEditingController.value = TextEditingValue(
              text: controller.value,
              selection: TextSelection.collapsed(
                  offset: cursorPosition > controller.value.length
                      ? controller.value.length
                      : cursorPosition),
            );

            return TextField(
              style: const TextStyle(fontSize: 14, color: Colors.black),
              controller: textEditingController,
              maxLength: max,
              maxLines: maxLines,
              obscureText: obscure,
              textInputAction: textInputAction,
              keyboardType: textInputType,
              textCapitalization: textCapitalization,
              readOnly: readOnly,
              onChanged: (value) => controller.value = value,
              decoration: InputDecoration(
                suffix: suffixWidget,
                suffixIcon: suffixIcon,
                labelText: label,
                labelStyle: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: purple,
                  fontWeight: FontWeight.w500,
                ),
                hintText: hint,
                suffixText: suffix,
                filled: filled,

                // floatingLabelStyle: TextStyle(fontSize: 12),
                fillColor: fill ?? Colors.grey.shade200,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: purple, width: 0.8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: purple, width: 1.2),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
