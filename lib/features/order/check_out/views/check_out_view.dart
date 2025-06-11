import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/my_alert_dialog.dart';
import '../bloc/check_out_bloc.dart';
import '../../order/bloc/order_bloc.dart';
import '../../order/utils/show_receipt.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/rupiah_converter.dart';

class CheckOutView extends StatelessWidget {
  const CheckOutView({
    super.key,
    required this.orderBloc,
  });
  final OrderBloc orderBloc;

  @override
  Widget build(BuildContext context) {
    context.read<CheckOutBloc>().add(ClearReceipt());
    return BlocListener<CheckOutBloc, CheckOutState>(
      listener: (context, state) {
        if (state.processed == true) {
          if (context.mounted) {
            showModalBottomSheet(
              enableDrag: false,
              isDismissible: false,
              isScrollControlled: true,
              useSafeArea: true,
              clipBehavior: Clip.hardEdge,
              context: context,
              builder: (context) {
                return ShowReceipt(
                    orderBloc: orderBloc,
                    storeName: state.store?.name ?? '',
                    storeAddress: state.store?.address ?? '',
                    userName: state.user?.name ?? '',
                    state: state);
              },
            );
          }
        } else if (state.isProcessing == false && state.errorMessage != null) {
          Get.snackbar("Error", "${state.errorMessage}");
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: BlocBuilder<CheckOutBloc, CheckOutState>(
            builder: (context, state) {
              return Container(
                height: 55,
                width: 340,
                decoration: BoxDecoration(
                  // border: Border.all(),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    "Total :  ${rupiahConverter(state.totalPrice)}",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: state.canProcess ? green : red,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: BlocBuilder<CheckOutBloc, CheckOutState>(
                    builder: (context, state) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          rupiahConverter(int.tryParse(state.displayText) ?? 0),
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.5,
                    ),
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      List<String> buttons = [
                        '7',
                        '8',
                        '9',
                        '4',
                        '5',
                        '6',
                        '1',
                        '2',
                        '3',
                        '0',
                        '000',
                        'C'
                      ];

                      return OutlinedButton(
                        onPressed: () {
                          final bloc = context.read<CheckOutBloc>();
                          if (buttons[index] == 'C') {
                            bloc.add(ClearPressed());
                          } else {
                            bloc.add(NumberPressed(buttons[index]));
                          }
                        },
                        child: Center(
                          child: Text(
                            buttons[index],
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: BlocBuilder<CheckOutBloc, CheckOutState>(
          builder: (context, state) {
            if (state.canProcess) {
              return ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: green),
                  child: Text("PROSES"),
                  onPressed: () {
                    context
                        .read<CheckOutBloc>()
                        .add(ProcessPayment(cart: orderBloc.cart));
                  });
            } else {
              return ElevatedButton(
                  child: Text("PROSES"),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return MySingleAlertDialog(
                            contentText:
                                "Masukkan jumlah pembayaran terlebih dahulu.");
                      },
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}
