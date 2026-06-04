import '../../navbar/controllers/navbar_controller.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final datadummy = "".obs;
  final totalPrice = 0.obs;
  final totalItem = 0.obs;
  final orderList = [].obs;
  final paymentAmount = 0.obs;
  final changeAmount = 0.obs;

  @override
  void onInit() {
    datadummy.value = 'Order Controller';
    super.onInit();
  }
}
