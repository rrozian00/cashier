import '../bindings/store_binding.dart';
import '../controllers/all_store_controller.dart';
import 'add_store_view.dart';
import 'package:get/get.dart';

import '../../../core/widgets/no_data.dart';
import 'detail_store_view.dart';
import 'package:flutter/material.dart';

class AllStoreView extends GetView<AllStoreController> {
  const AllStoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Toko"),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: controller.storeList.length,
                itemBuilder: (context, index) {
                  final data = controller.storeList[index];
                  // final color = data.isActive == true
                  //     ? Theme.of(context).colorScheme.surface
                  //     : Theme.of(context).colorScheme.primary;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: Card(
                      // color: data.isActive == true
                      //     ? Theme.of(context).colorScheme.onPrimary
                      //     : Theme.of(context).colorScheme.surface,
                      child: ListTile(
                        trailing: data.isActive == true
                            ? Text(
                                "Aktif",
                                style: TextStyle(color: Colors.green),
                              )
                            : TextButton(
                                style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.all(0)),
                                onPressed: () {
                                  controller.storeList[index].isActive = true;
                                  controller.update();
                                },
                                child: Text(
                                  "Aktifkan",
                                  style: TextStyle(fontSize: 12),
                                )),
                        onTap: () => Get.to(() => DetailStore(index: index),
                            binding: StoreBinding()),
                        leading: Image.asset(
                          "assets/images/store.png",
                          color: Theme.of(context).colorScheme.onSurface,
                          // color: color,
                        ),
                        title: Text(
                          data.name ?? '',
                          style: TextStyle(
                              // color: color
                              ),
                        ),
                        subtitle: Text(
                          data.address ?? '',
                          style: TextStyle(
                              // color: color
                              ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
          onPressed: () => Get.to(() {
                AddStoreView();
              }, binding: StoreBinding()),
          child: Text("Tambah Toko")),
    );
  }
}
