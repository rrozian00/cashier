// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
              // color: Theme.of(context).colorScheme.error,
              color: Color(0xFFFFC107),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                contentText,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  // color: onCancelColor,
                  // width: 100,
                  // text: "Batal",
                  onPressed: onCancel ?? () => Navigator.pop(context),
                  // color: onCancelColor,
                  // width: 100,
                  // text: "Batal",
                  child: Text("Batal"),
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: onConfirmColor),
                  child: Text(onConfirmText ?? "Simpan"),
                  onPressed: () {
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

class MySingleAlertDialog extends GetView {
  final VoidCallback? onCancel;
  final String? onCancelText;
  final String contentText;
  final Color? onCancelColor;

  const MySingleAlertDialog({
    super.key,
    this.onCancel,
    required this.contentText,
    this.onCancelColor,
    this.onCancelText,
  });

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
              color: Theme.of(context).colorScheme.error,
            ),
            Text(
              contentText,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(),
            ),
            SizedBox(
              height: 25,
            ),
            ElevatedButton(
              onPressed: onCancel ?? () => Navigator.pop(context),
              child: Text(onCancelText ?? "Batal"),
            )
          ],
        ),
      ),
    );
  }
}
