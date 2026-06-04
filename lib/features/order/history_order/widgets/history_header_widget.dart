import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/history_order_controller.dart';

class HistoryHeaderWidget extends GetView<HistoryOrderController>
    implements PreferredSizeWidget {
  const HistoryHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: ElevatedButton(
        onPressed: () async {
          final DateTimeRange? picked = await showDateRangePicker(
            context: context,
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
            initialDateRange: controller.dateRange.value,
          );

          if (picked != null) {
            if (context.mounted) {
              controller.dateRange.value = picked;
            }
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: Text('Pilih Rentang Tanggal', style: GoogleFonts.poppins()),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
