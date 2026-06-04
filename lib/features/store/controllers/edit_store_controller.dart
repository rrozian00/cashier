import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class EditStoreController extends GetxController {
  final nameC = TextEditingController().obs;
  final addressC = TextEditingController().obs;
  final phoneC = TextEditingController().obs;
}
