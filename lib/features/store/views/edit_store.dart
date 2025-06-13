import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/core/widgets/home_indicator.dart';
import 'package:cashier/core/widgets/my_text_field.dart';
import 'package:cashier/features/store/bloc/store_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void editStoreDialog({
  required BuildContext context,
  required String name,
  required String address,
  required String phone,
}) {
  final nameC = TextEditingController(text: name);
  final addressC = TextEditingController(text: address);
  final phoneC = TextEditingController(text: phone);

  showBottomSheet(
    context: context,
    builder: (context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                homeIndicator(),
                Text(
                  "Ubah Toko",
                  style: GoogleFonts.poppins(color: purple, fontSize: 18),
                ),
                SizedBox(height: 15),
                MyTextField(controller: nameC, label: "Nama Toko"),
                MyTextField(controller: addressC, label: "Alamat Toko"),
                MyTextField(controller: phoneC, label: "No HP Toko"),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Kembali"),
                    ),
                    ElevatedButton(
                      child: Text("Simpan"),
                      onPressed: () {
                        context.read<StoreBloc>().add(UpdateStore(
                              name: nameC.text,
                              address: addressC.text,
                              phone: phoneC.text,
                            ));
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
