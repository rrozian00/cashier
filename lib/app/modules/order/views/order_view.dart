// import 'dart:io';

// import 'package:cashier/app/data/model/menu_model.dart';
// import 'package:cashier/utils/rupiah_converter.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../controllers/order_controller.dart';

// class TransaksiView extends GetView<OrderController> {
//   const TransaksiView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         leading: IconButton(
//           color: Colors.red,
//           onPressed: () {
//             controller.fetchProduk();
//             Get.snackbar("Sukses", "Berhasil Update Menu");
//           },
//           icon: Icon(Icons.refresh),
//         ),
//         title: const Text('Pilih Menu'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // Dropdown
//                 Expanded(
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     decoration: BoxDecoration(
//                       color: Colors.black,
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: Obx(() {
//                       return DropdownButton<MenuModel>(
//                         iconEnabledColor: Colors.white,
//                         borderRadius: BorderRadius.circular(15),
//                         value: controller.selectedProduk.value != null &&
//                                 controller.produk
//                                     .contains(controller.selectedProduk.value)
//                             ? controller.selectedProduk.value
//                             : null,
//                         isExpanded: true,
//                         underline: Container(),
//                         hint: Text(
//                           controller.produk.isNotEmpty
//                               ? "Pilih Menu Disini:"
//                               : "Menu Kosong",
//                           style: GoogleFonts.poppins(color: Colors.white),
//                         ),
//                         dropdownColor: Colors.black,
//                         items: controller.produk.map((produk) {
//                           return DropdownMenuItem<MenuModel>(
//                             value: produk,
//                             child: Row(
//                               children: [
//                                 produk.image != null && produk.image!.isNotEmpty
//                                     ? Image.file(
//                                         File(produk.image!),
//                                         height: 30,
//                                         width: 30,
//                                         fit: BoxFit.cover,
//                                       )
//                                     : Image.asset('assets/icons/icon.png',
//                                         color: Colors.white,
//                                         height: 30,
//                                         width: 30),
//                                 const SizedBox(width: 10),
//                                 Expanded(
//                                   child: Text(
//                                     "${produk.name} ( ${rupiahConverter(int.tryParse(produk.price ?? '') ?? 0)} )",
//                                     style: GoogleFonts.poppins(
//                                         color: Colors.white),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         }).toList(),
//                         onChanged: (value) {
//                           if (value != null) {
//                             // Cek apakah produk sudah ada di keranjang
//                             bool sudahAda = controller.keranjangBelanja
//                                 .any((item) => item['produk'] == value);

//                             if (!sudahAda) {
//                               controller.selectedProduk.value = value;
//                               controller.tambahKeKeranjang(value);
//                             }
//                           }
//                         },
//                       );
//                     }),
//                   ),
//                 ),
//                 // const SizedBox(width: 10),
//                 // Tombol Tambah
//                 // Container(
//                 //   height: 45,
//                 //   decoration: BoxDecoration(
//                 //       border: Border.all(),
//                 //       borderRadius: BorderRadius.circular(15)),
//                 //   child: TextButton(
//                 //     onPressed: () {
//                 //       // controller.tampilkanStruk();
//                 //       if (controller.selectedProduk.value != null) {
//                 //         controller.tambahKeKeranjang(
//                 //             controller.selectedProduk.value!);
//                 //       }
//                 //     },
//                 //     child: Text("Tambah"),
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//           const Divider(color: Colors.black),
//           Expanded(
//             flex: 2,
//             child: Obx(() {
//               if (controller.keranjangBelanja.isEmpty) {
//                 return Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image.asset(
//                       'assets/images/empty.png',
//                       height: 100,
//                       width: 100,
//                     ),
//                     Text(
//                       "Keranjang Kosong,",
//                       style: GoogleFonts.poppins(
//                           color: Colors.red, fontWeight: FontWeight.w500),
//                     ),
//                     Text(
//                       "Silahkan Pilih Menu",
//                       style: GoogleFonts.poppins(
//                           color: Colors.black, fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 );
//               }
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       flex: 2,
//                       child: Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(15),
//                           // color: Colors.grey[400],
//                         ),
//                         child: ListView.builder(
//                           itemCount: controller.keranjangBelanja.length,
//                           itemBuilder: (context, index) {
//                             final item = controller.keranjangBelanja[index];
//                             final produk = item['produk'] as MenuModel;
//                             final jumlah = item['jumlah'] as int;

//                             return Card(
//                               elevation: 6,
//                               color: Colors.black54,
//                               child: ListTile(
//                                 leading: CircleAvatar(
//                                   backgroundColor: Colors.white,
//                                   child: produk.image!.isNotEmpty
//                                       ? ClipOval(
//                                           child: Image.file(
//                                             File(produk.image!),
//                                             height: 50,
//                                             width: 50,
//                                             fit: BoxFit.cover,
//                                           ),
//                                         )
//                                       : Image.asset('assets/icons/icon.png'),
//                                 ),
//                                 title: Text(
//                                   produk.name ?? 'Nama Produk',
//                                   style: GoogleFonts.poppins(
//                                     color: Colors.cyan,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 subtitle: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       '${rupiahConverter(int.tryParse(produk.price ?? '') ?? 0)} x $jumlah pcs',
//                                       style: GoogleFonts.poppins(
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                     // Text(
//                                     //   'Banyak:  pcs',
//                                     //   style: GoogleFonts.poppins(
//                                     //     color: Colors.white,
//                                     //   ),
//                                     // ),
//                                   ],
//                                 ),
//                                 trailing: Wrap(
//                                   children: [
//                                     IconButton(
//                                       icon: Icon(
//                                         Icons.remove_rounded,
//                                         color: Colors.white,
//                                       ),
//                                       // Text(
//                                       //   "Hapus",
//                                       //   style: GoogleFonts.poppins(
//                                       //       color: Colors.red,
//                                       //       fontWeight: FontWeight.bold),
//                                       // ),
//                                       // color: Colors.red,
//                                       // icon: const Icon(Icons.remove),
//                                       onPressed: () {
//                                         controller.hapusDariKeranjang(produk);
//                                       },
//                                     ),
//                                     IconButton(
//                                       icon: Icon(
//                                         Icons.add_rounded,
//                                         color: Colors.white,
//                                       ),
//                                       // Text(
//                                       //   "Hapus",
//                                       //   style: GoogleFonts.poppins(
//                                       //       color: Colors.red,
//                                       //       fontWeight: FontWeight.bold),
//                                       // ),
//                                       // color: Colors.red,
//                                       // icon: const Icon(Icons.remove),
//                                       onPressed: () {
//                                         controller.tambahKeKeranjang(produk);
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: TextField(
//                         cursorColor: Colors.red,
//                         style: TextStyle(color: Colors.white),
//                         controller: controller.bayarController,
//                         keyboardType: TextInputType.number,
//                         onChanged: (value) {
//                           // Menghapus format lama (titik dan simbol Rp) untuk parsing
//                           String rawValue =
//                               value.replaceAll('.', '').replaceAll('Rp ', '');
//                           int parsedValue = int.tryParse(rawValue) ?? 0;

//                           // Update jumlahBayar
//                           controller.jumlahBayar.value = parsedValue;

//                           // Perbarui teks di TextField dengan format Rupiah
//                           controller.bayarController.value = TextEditingValue(
//                             text: rupiahConverter(
//                                 parsedValue), // Format ke Rupiah
//                             selection: TextSelection.collapsed(
//                                 offset: rupiahConverter(parsedValue)
//                                     .length), // Posisikan kursor di akhir teks
//                           );
//                         },
//                         decoration: InputDecoration(
//                             filled: true,
//                             fillColor: Colors.black,
//                             border: OutlineInputBorder(
//                               borderSide: const BorderSide(color: Colors.black),
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                             hintText: "Bayar :",
//                             hintStyle: TextStyle(color: Colors.white)
//                             // labelText: "Bayar :",
//                             // labelStyle: TextStyle(color: Colors.white),
//                             ),
//                       ),
//                     ),
//                     Center(
//                       child: SizedBox(
//                         width: double.infinity,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             Row(
//                               children: [
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "Kembalian",
//                                     ),
//                                     Text(
//                                       "Total",
//                                       style: GoogleFonts.poppins(
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   ],
//                                 ),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       ": ${rupiahConverter(controller.kembalian.value)}",
//                                     ),
//                                     Text(
//                                       ": ${rupiahConverter(controller.totalHarga.value)}",
//                                       style: GoogleFonts.poppins(
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             Container(
//                               decoration: BoxDecoration(
//                                   border: Border.all(),
//                                   borderRadius: BorderRadius.circular(15)),
//                               child: TextButton(
//                                 onPressed: () {
//                                   // controller.tampilkanStruk();
//                                   controller.insertTransaksi();
//                                 },
//                                 child: const Text("Check Out"),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cashier/app/data/model/menu_model.dart';
import 'package:cashier/app/modules/home/controllers/home_controller.dart';
import 'package:cashier/utils/my_appbar.dart';
import 'package:cashier/utils/my_elevated.dart';
import 'package:cashier/utils/rupiah_converter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/order_controller.dart';

class TransaksiView extends GetView<OrderController> {
  const TransaksiView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController home = Get.find();
    return Scaffold(
      appBar: MyAppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Obx(() => Text(
                  "-${home.storeNameFinal.value}-",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.deepPurple),
                )),
          )
        ],
        titleText: 'Pilih Menu',
        leading: IconButton(
          color: Colors.deepPurple,
          onPressed: () {
            controller.fetchProduk();
            Get.snackbar("Sukses", "Berhasil Update Menu");
          },
          icon: const Icon(Icons.refresh),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
            ),
            child: Obx(() {
              return DropdownButtonFormField<MenuModel>(
                decoration: InputDecoration(
                  // filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  // border: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(15),
                  // ),
                ),
                value: controller.selectedProduk.value != null &&
                        controller.produk
                            .contains(controller.selectedProduk.value)
                    ? controller.selectedProduk.value
                    : null,
                hint: Text(
                  controller.produk.isNotEmpty
                      ? "Pilih Menu Disini:"
                      : "Menu kosong",
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(15),
                elevation: 10,
                iconEnabledColor: Colors.black,
                iconDisabledColor: Colors.grey[600],
                items: controller.produk.map((produk) {
                  return DropdownMenuItem<MenuModel>(
                    value: produk,
                    child: Wrap(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/icons/icon.png',
                              color: Colors.black,
                              height: 30,
                              width: 30,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "${produk.name} ( ${rupiahConverter(int.tryParse(produk.price ?? '') ?? 0)} )",
                              style: GoogleFonts.poppins(color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.black,
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    bool sudahAda = controller.keranjangBelanja
                        .any((item) => item['produk'] == value);
                    if (!sudahAda) {
                      controller.selectedProduk.value = value;
                      controller.tambahKeKeranjang(value);
                    }
                  }
                },
              );
            }),
          ),

          const Divider(color: Colors.black),

          // Keranjang Belanja
          Expanded(
            child: Obx(() {
              if (controller.keranjangBelanja.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/empty.png',
                        height: 70,
                      ),
                      Text("Keranjang Kosong,",
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.w500)),
                      Text("Silahkan pilih Menu !",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: controller.keranjangBelanja.length,
                itemBuilder: (context, index) {
                  final item = controller.keranjangBelanja[index];
                  final produk = item['produk'] as MenuModel;
                  final jumlah = item['jumlah'] as int;

                  return Card(
                    elevation: 4,
                    color: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Image.asset(
                        'assets/icons/icon.png',
                        color: Colors.black,
                      ),
                      title: Text(
                        produk.name ?? 'Nama Produk',
                        style: GoogleFonts.poppins(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${rupiahConverter(int.tryParse(produk.price ?? '') ?? 0)} x $jumlah pcs',
                        style: GoogleFonts.poppins(color: Colors.black),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_rounded,
                                color: Colors.black),
                            onPressed: () =>
                                controller.hapusDariKeranjang(produk),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_rounded,
                                color: Colors.black),
                            onPressed: () =>
                                controller.tambahKeKeranjang(produk),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  controller.totalHarga != 0
                      ? Text(
                          "Total ${rupiahConverter(controller.totalHarga.value)}",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: Colors.red[800],
                              fontSize: 24))
                      : Container(),
                  controller.keranjangBelanja.isNotEmpty
                      ? myElevated(
                          onPress: () => Get.to(() => CheckOutView()),
                          child: Text(
                            "BAYAR",
                            style: GoogleFonts.poppins(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ))
                      : Container()
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class CheckOutView extends GetView<OrderController> {
  const CheckOutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // actions: [
        //   SizedBox()
        // ],
        title: Obx(() {
          return Container(
              height: 50,
              width: 280,
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15)),
              child: Center(
                  child: Text(
                "TOTAL:   ${rupiahConverter(controller.totalHarga.value)}",
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              )));
        }),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  "Masukkan Jumlah Bayar",
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
              ),
              // Layar tampilan angka
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
                          controller.onClear();
                        }
                        // else if (buttons[index] == 'OK') {
                        //   controller.insertTransaksi();
                        // }
                        else {
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
            ? myElevated(
                child: Text("PROSES",
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                onPress: () => controller.insertTransaksi(),
              )
            : Text("Jumlah Pembayaran Kurang",
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
