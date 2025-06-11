import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/no_data.dart';
import '../../../routes/app_pages.dart';

import '../controllers/store_controller.dart';

class StoreView extends GetView<StoreController> {
  const StoreView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil Toko"),
      ),
      body: Obx(() {
        if (controller.store.value == null) {
          return noData(
              icon: Icons.store,
              title: "Anda Belum Membuat Toko",
              message: "Silahkan Buat Toko Baru");
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/store.png",
                          color: colorScheme.secondary,
                          width: 100,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    _MyList(
                        icon: Icons.store,
                        subtitle: controller.store.value?.name ?? '',
                        title: "Nama Toko"),
                    _MyList(
                        icon: Icons.location_on,
                        subtitle: controller.store.value?.address ?? '',
                        title: "Alamat Toko"),
                    _MyList(
                        icon: Icons.phone_android,
                        subtitle: controller.store.value?.phone ?? '',
                        title: "No HP Toko"),
                    SizedBox(height: 50),
                    ElevatedButton(
                        onPressed: () => controller.editDialog(context),
                        child: Text(
                          "Ubah Toko",
                        ))
                  ],
                ),
              ),
            ),
          );
        }
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Obx(() => Visibility(
            visible: controller.store.value != null,
            child: ElevatedButton(
              // width: 180,
              // height: 45,
              child: Text("Tambah Toko"),
              onPressed: () => Get.toNamed(Routes.addStore),
              // text: "Tambah Toko"
            ),
          )),
    );
  }
}

class _MyList extends StatelessWidget {
  const _MyList({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          minTileHeight: 0,
          leading: Icon(
            color: Theme.of(context).colorScheme.secondary,
            icon,
          ),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
        ),
        Divider()
      ],
    );
  }
}
