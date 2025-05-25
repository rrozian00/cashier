import 'package:cashier/features/order/blocs/order_bloc/order_bloc.dart';
import 'package:cashier/features/order/check_out/bloc/check_out_bloc.dart';
import 'package:cashier/features/order/utils/show_receipt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/colors.dart';
import '../../../core/utils/rupiah_converter.dart';
import '../../../core/widgets/my_elevated.dart';

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
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    "Total  ${rupiahConverter(state.totalPrice)}",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
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
                          style: const TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
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

                      return myElevated(
                        onPress: () {
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
                            style: const TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 40,
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
              return myGreenElevated(
                  width: 180,
                  text: "PROSES",
                  onPress: () {
                    context.read<CheckOutBloc>().add(ProcessPayment());
                  });
            } else {
              return Text(
                "Masukkan jumlah pembayaran",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: red,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
