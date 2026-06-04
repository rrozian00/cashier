import 'package:get/get.dart';

import '../models/store_model.dart';

class DetailStoreController extends GetxController {
  final isLoading = true.obs;
  final storeData = Rxn<StoreModel>(null);
}
