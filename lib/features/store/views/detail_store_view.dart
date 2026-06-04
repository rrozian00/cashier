import '../controllers/detail_store_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'edit_store_view.dart';

class DetailStore extends GetView<DetailStoreController> {
  const DetailStore({
    super.key,
    required this.index,
  });
  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profil Toko"),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

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
                          width: 100,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    _MyList(
                        icon: Icons.store,
                        subtitle: controller.storeData.value?.name ?? '',
                        title: "Nama Toko"),
                    _MyList(
                        icon: Icons.location_on,
                        subtitle: controller.storeData.value?.address ?? '',
                        title: "Alamat Toko"),
                    _MyList(
                        icon: Icons.phone_android,
                        subtitle: controller.storeData.value?.phone ?? '',
                        title: "No HP Toko"),
                    SizedBox(height: 50),
                    ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            showDragHandle: true,
                            enableDrag: true,
                            clipBehavior: Clip.hardEdge,
                            isScrollControlled: true,
                            context: context,
                            builder: (context) => EditStoreView(),
                          );
                        },
                        child: Text(
                          "Ubah Toko",
                        ))
                  ],
                ),
              ),
            ),
          );
        }));
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
