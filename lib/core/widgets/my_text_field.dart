import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//ini
class MyTextField extends StatelessWidget {
  final TextEditingController controller;
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
  final String? Function(String?)? validator;

  const MyTextField({
    this.validator,
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
    final colorScheme = Theme.of(context).colorScheme;
    // final textController = TextEditingController(text: controller.value);

    // Sync awal saja
    // textController.selection =
    //     TextSelection.collapsed(offset: controller.value.length);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label ?? ''),
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                validator: validator,
                style: const TextStyle(
                  fontSize: 14,
                ),
                controller: controller,
                maxLength: max,
                maxLines: maxLines,
                obscureText: obscure,
                textInputAction: textInputAction,
                keyboardType: textInputType,
                textCapitalization: textCapitalization,
                readOnly: readOnly,
                decoration: InputDecoration(
                  prefixText: prefixText,
                  suffixIcon: suffixWidget ?? suffixIcon,
                  suffixText: suffix,
                  // labelText: label,
                  labelStyle: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  hintText: hint,
                  filled: filled,
                  fillColor: fill ?? colorScheme.secondary,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
