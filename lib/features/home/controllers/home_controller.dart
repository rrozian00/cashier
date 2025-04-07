import 'package:cashier/core/utils/get_user_data.dart';
import 'package:cashier/features/user/models/user_model.dart';
import 'package:get/get.dart';

import 'package:cashier/core/utils/get_store_id.dart';

class HomeController extends GetxController {
  final userData = Rxn<UserModel>();

  final storeName = ''.obs;
  final storeAddress = ''.obs;

  void fetchData() async {
    userData.value = await getUserData();

    final store = await getStore();
    if (store == null) return;

    storeName.value = store.name ?? '';
    storeAddress.value = store.address ?? '';
  }

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }
}

  // void getIncomeToday() {
  //   if (userData.value?.st) {
  //     debugPrint("Store ID belum tersedia, menunggu...");
  //     return;
  //   }
  //   _firestore
  //       .collection('stores')
  //       .doc(storeIdFinal.value)
  //       .collection('orders')
  //       .snapshots()
  //       .listen((snapshot) {
  //     double total = 0;
  //     final today = DateTime.now();
  //     final todayString = DateFormat('dd-MM-yyyy').format(today);

  //     for (var doc in snapshot.docs) {
  //       final data = doc.data();
  //       final createdAtString = data['createdAt'] as String?;

  //       if (createdAtString != null) {
  //         final createdAt = DateTime.parse(createdAtString);
  //         final orderDate = DateFormat('dd-MM-yyyy').format(createdAt);

  //         if (orderDate == todayString) {
  //           total += double.tryParse(data['total']?.toString() ?? '') ?? 0;
  //         }
  //       }
  //     }
  //     totalIncomeToday.value = total;
  //   });
  // }

  // void getPengeluaranToday() {
  //   if (storeIdFinal.isEmpty) {
  //     debugPrint("Store ID belum tersedia, menunggu...");
  //     return;
  //   }

  //   _firestore
  //       .collection('stores')
  //       .doc(storeIdFinal.value)
  //       .collection('expenses') // Mengambil data dari koleksi pengeluaran
  //       .snapshots()
  //       .listen((snapshot) {
  //     double total = 0;
  //     final today = DateTime.now();
  //     final todayString = DateFormat('dd-MM-yyyy').format(today);

  //     for (var doc in snapshot.docs) {
  //       final data = doc.data();
  //       final createdAtString = data['createdAt'] as String?;

  //       if (createdAtString != null) {
  //         final createdAt = DateTime.parse(createdAtString);
  //         final expenseDate = DateFormat('dd-MM-yyyy').format(createdAt);
  //         debugPrint(todayString);

  //         if (expenseDate == todayString) {
  //           total += double.tryParse(data['pay']?.toString() ?? '') ?? 0;
  //         }
  //       }
  //     }
  //     totalPengeluaranToday.value = total;
  //   });
  // }

