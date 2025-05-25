import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../blocs/history_order_bloc/history_order_bloc.dart';
import 'widgets/content_widget.dart';
import 'widgets/header_widget.dart';

import '../../../core/widgets/no_data.dart';
import '../models/order_model.dart';

class HistoryOrderView extends StatelessWidget {
  const HistoryOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: HistoryOrderHeader(),
        body: BlocBuilder<HistoryOrderBloc, HistoryOrderState>(
          builder: (context, state) {
            if (state is HistoryOrderLoading) {
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            if (state is HistoryOrderLoaded && state.orders.isEmpty) {
              return noData(
                  icon: CupertinoIcons.trash_slash_fill,
                  title: "Riwayat Kosong",
                  message: "Silahkan pilih tanggal");
            }
            if (state is HistoryOrderLoaded) {
              final groupedTransactions = groupBy(
                state.orders,
                (OrderModel transaksi) {
                  // Mengelompokkan berdasarkan tanggal (tanpa jam-menit)
                  return DateFormat('dd-MM-yyyy HH:mm:ss')
                      .format(transaksi.createdAt!.toDate());
                },
              );
              return ContentWidget(
                groupedTransactions: groupedTransactions,
              );
            }
            return Center(child: Text("404"));
          },
        ));
  }
}
