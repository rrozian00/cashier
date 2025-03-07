import 'package:get/get.dart';

import '../controllers/history_order_controller.dart';

class RiwayatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryOrderController>(
      () => HistoryOrderController(),
    );
  }
}
