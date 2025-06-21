import '../../bloc/history_order_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HistoryHeaderWidget extends StatelessWidget
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
            initialDateRange:
                (context.read<HistoryOrderBloc>().state as HistoryOrderLoaded)
                    .picked,
          );

          if (picked != null) {
            if (context.mounted) {
              context
                  .read<HistoryOrderBloc>()
                  .add(ShowMyDateRange(picked: picked));
            }
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: BlocBuilder<HistoryOrderBloc, HistoryOrderState>(
          builder: (context, state) {
            if (state is HistoryOrderLoaded && state.picked != null) {
              final dateFormat = DateFormat('dd/MM/yyyy');
              final startDate = dateFormat.format(state.picked!.start);
              final endDate = dateFormat.format(state.picked!.end);
              return Text(
                '$startDate - $endDate',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  // color: Colors.black,
                ),
              );
            }
            return Text(
              "Pilih Tanggal",
              style: GoogleFonts.jetBrainsMono(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                // color: Colors.black,
              ),
            );
          },
        ),
      ),
      // actions: [
      //   IconButton(
      //     onPressed: () {
      //       // Add reset functionality here
      //       // Example: context.read<HistoryOrderBloc>().add(ResetDateRange());
      //     },
      //     icon: const Icon(
      //       Icons.refresh,
      //       // color: Colors.deepPurple,
      //     ),
      //     tooltip: 'Reset',
      //   ),
      // ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
