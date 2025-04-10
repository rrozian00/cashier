import 'package:cashier/features/order/views/check_out_view.dart';
import 'package:cashier/features/store/views/add_store_view.dart';
import 'package:get/get.dart';

import 'package:cashier/features/menu/views/add_product_view.dart';
import 'package:cashier/features/menu/views/edit_product_view.dart';
import 'package:cashier/features/order/views/product_list.dart';
import 'package:cashier/features/user/views/add_employee_view.dart';
import 'package:cashier/features/user/views/edit_profile_view.dart';
import 'package:cashier/features/user/views/employee_list_view.dart';

import '../features/bottom_navigation_bar/bindings/bottom_binding.dart';
import '../features/bottom_navigation_bar/views/bottom_view.dart';
import '../features/expense/bindings/expense_binding.dart';
import '../features/expense/views/expense_view.dart';
import '../features/home/bindings/home_binding.dart';
import '../features/home/views/home_view.dart';
import '../features/login/bindings/login_binding.dart';
import '../features/login/views/login_view.dart';
import '../features/menu/bindings/menu_binding.dart';
import '../features/menu/views/product_view.dart';
import '../features/order/bindings/history_order_binding.dart';
import '../features/order/bindings/input_manual_binding.dart';
import '../features/order/bindings/order_binding.dart';
import '../features/order/views/history_order_view.dart';
import '../features/order/views/input_manual_view.dart';
import '../features/order/views/order_view.dart';
import '../features/printer/bindings/printer_binding.dart';
import '../features/printer/views/printer_view.dart';
import '../features/rekapan/bindings/rekapan_binding.dart';
import '../features/rekapan/views/rekapan_view.dart';
import '../features/settings/bindings/settings_binding.dart';
import '../features/settings/views/settings_view.dart';
import '../features/store/bindings/store_binding.dart';
import '../features/store/views/store_view.dart';
import '../features/user/bindings/add_employee_binding.dart';
import '../features/user/bindings/profile_binding.dart';
import '../features/user/views/profile_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.home,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.order,
      page: () => TransaksiView(),
      binding: TransaksiBinding(),
    ),
    GetPage(
      name: _Paths.productList,
      page: () => ProductList(),
      binding: TransaksiBinding(),
    ),
    GetPage(
      name: _Paths.checkOut,
      page: () => CheckOutView(),
      binding: TransaksiBinding(),
    ),
    GetPage(
      name: _Paths.BOTTOM,
      page: () => BottomView(),
      binding: BottomBinding(),
    ),
    GetPage(
      name: _Paths.menus,
      page: () => const ProductView(),
      binding: MenuBinding(),
    ),
    GetPage(
      name: _Paths.addMenus,
      page: () => const AddProductView(),
      binding: MenuBinding(),
    ),
    GetPage(
      name: _Paths.editMenus,
      page: () => const EditProductView(),
      binding: MenuBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY_ORDER,
      page: () => HistoryOrderView(),
      binding: RiwayatBinding(),
    ),
    GetPage(
      name: _Paths.EXPENSE,
      page: () => const ExpenseView(),
      binding: PengeluaranBinding(),
    ),
    GetPage(
      name: _Paths.PRINTER,
      page: () => const PrinterView(),
      binding: PrinterBinding(),
    ),
    GetPage(
      name: _Paths.RECAP,
      page: () => const RekapanView(),
      binding: RekapanBinding(),
    ),
    GetPage(
      name: _Paths.INPUT_MANUAL,
      page: () => const InputManualView(),
      binding: InputManualBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.editProfile,
      page: () => const EditProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.store,
      page: () => const StoreView(),
      binding: StoreBinding(),
    ),
    GetPage(
      name: _Paths.addStore,
      page: () => const AddStoreView(),
      binding: StoreBinding(),
    ),
    GetPage(
      name: _Paths.employee,
      page: () => const EmployeeListView(),
      binding: AddEmployeeBinding(),
    ),
    GetPage(
      name: _Paths.addEmployee,
      page: () => const AddEmployeeView(),
      binding: AddEmployeeBinding(),
    ),
  ];
}
