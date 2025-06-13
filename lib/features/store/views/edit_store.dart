import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/core/widgets/my_text_field.dart';
import 'package:cashier/features/store/bloc/store_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class EditStore extends StatefulWidget {
  const EditStore(
      {super.key,
      required this.id,
      required this.name,
      required this.address,
      required this.phone});

  final String id;
  final String name;
  final String address;
  final String phone;

  @override
  State<EditStore> createState() => _EditStoreState();
}

class _EditStoreState extends State<EditStore> {
  late TextEditingController nameC;
  late TextEditingController addressC;
  late TextEditingController phoneC;

  @override
  void initState() {
    nameC = TextEditingController(text: widget.name);
    addressC = TextEditingController(text: widget.address);
    phoneC = TextEditingController(text: widget.phone);
    super.initState();
  }

  @override
  void dispose() {
    nameC.dispose();
    addressC.dispose();
    phoneC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 10,
        left: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // homeIndicator(),
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
                          id: widget.id,
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
    );
  }
}
