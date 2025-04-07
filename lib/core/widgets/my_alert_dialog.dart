import 'package:cashier/core/widgets/my_elevated.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAlertDialog extends GetView {
  const MyAlertDialog({
    super.key,
    required this.onConfirm,
    this.onConfirmText,
    required this.contentText,
    this.onCancel,
  });

  final VoidCallback? onCancel;
  final VoidCallback onConfirm;
  final String? onConfirmText;
  final String contentText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
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
              myElevated(
                text: "Batal",
                onPress: onCancel ?? () => Get.back(),
              ),
              myPurpleElevated(
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
    );
  }
}
