import '../../blocs/history_order_bloc/history_order_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HistoryOrderHeader extends StatelessWidget
    implements PreferredSizeWidget {
  const HistoryOrderHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: OutlinedButton(
        onPressed: () {
          context
              .read<HistoryOrderBloc>()
              .add(ShowMyDateRange(context: context));
        },
        style: OutlinedButton.styleFrom(
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
                  // color: black,
                ),
              );
            }
            return Text(
              "Pilih Tanggal",
              style: GoogleFonts.jetBrainsMono(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                // color: black,
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
