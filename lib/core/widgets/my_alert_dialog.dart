// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cashier/core/widgets/my_elevated.dart';

class MyAlertDialog extends GetView {
  const MyAlertDialog({
    super.key,
    this.onCancel,
    required this.onConfirm,
    this.onConfirmText,
    required this.contentText,
    this.onConfirmColor,
    this.onCancelColor,
  });

  final VoidCallback? onCancel;
  final VoidCallback onConfirm;
  final String? onConfirmText;
  final String contentText;
  final Color? onConfirmColor;
  final Color? onCancelColor;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 100,
              color: Colors.amber,
            ),
            Text(
              contentText,
              style: GoogleFonts.poppins(),
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                myRedElevated(
                  color: onCancelColor,
                  width: 100,
                  text: "Batal",
                  onPress: onCancel ?? () => Get.back(),
                ),
                myGreenElevated(
                  color: onConfirmColor,
                  width: 100,
                  text: onConfirmText ?? "Simpan",
                  onPress: () {
                    onConfirm();
                    Get.back();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
