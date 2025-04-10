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
  final String? prefixText;
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
    this.prefixText,
  });

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController(text: controller.value);

    // Sync awal saja
    textController.selection =
        TextSelection.collapsed(offset: controller.value.length);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            // Update textController tanpa bikin baru
            if (textController.text != controller.value) {
              final cursorPos = textController.selection.baseOffset;
              textController.value = TextEditingValue(
                text: controller.value,
                selection: TextSelection.collapsed(
                  offset: cursorPos > controller.value.length
                      ? controller.value.length
                      : cursorPos,
                ),
              );
            }

            return TextField(
              style: const TextStyle(fontSize: 14, color: Colors.black),
              controller: textController,
              maxLength: max,
              maxLines: maxLines,
              obscureText: obscure,
              textInputAction: textInputAction,
              keyboardType: textInputType,
              textCapitalization: textCapitalization,
              readOnly: readOnly,
              onChanged: (value) => controller.value = value,
              decoration: InputDecoration(
                prefixText: prefixText,
                suffixIcon: suffixWidget ?? suffixIcon,
                suffixText: suffix,
                labelText: label,
                labelStyle: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: purple,
                  fontWeight: FontWeight.w500,
                ),
                hintText: hint,
                filled: filled,
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
