import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/core/utils/rupiah_converter.dart';
import 'package:cashier/core/widgets/my_elevated.dart';
import 'package:cashier/features/order/controllers/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckOutView extends GetView<OrderController> {
  const CheckOutView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.jumlahBayar.value = 0;
    controller.displayText.value = '';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Obx(() {
          return Container(
              height: 55,
              width: 340,
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15)),
              child: Center(
                  child: Text(
                "Total  ${rupiahConverter(controller.totalHarga.value)}",
                style: GoogleFonts.poppins(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: controller.jumlahBayar.value != 0 &&
                            controller.jumlahBayar.value >=
                                controller.totalHarga.value
                        ? green
                        : red),
              )));
        }),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              //Layar
              Container(
                height: 150,
                width: double.infinity,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Obx(() => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        rupiahConverter(
                            int.tryParse(controller.displayText.value) ?? 0),
                        style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple),
                      ),
                    )),
              ),
              SizedBox(height: 10),

              // Tombol angka
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                        if (buttons[index] == 'C') {
                          controller.clearTap();
                        } else {
                          controller.onNumberPressed(buttons[index]);
                        }
                      },
                      child: Center(
                        child: Text(
                          buttons[index],
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
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
      floatingActionButton: Obx(
        () => controller.jumlahBayar.value != 0 &&
                controller.jumlahBayar.value >= controller.totalHarga.value
            ? myGreenElevated(
                child: Text("PROSES",
                    style: GoogleFonts.poppins(
                        color: white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                onPress: () => controller.insertTransaksi(),
              )
            : Text("Masukkan jumlah pembayaran",
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.bold, color: red)),
      ),
    );
  }
}
