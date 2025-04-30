import 'package:get/get.dart';

import 'package:cashier/core/splash_screen/splash_screen.dart';

import 'package:cashier/features/order/views/check_out_view.dart';
import 'package:cashier/features/product/views/product_list.dart';
import 'package:cashier/features/product/views/add_product_view.dart';
import 'package:cashier/features/store/views/add_store_view.dart';
import 'package:cashier/features/user/blocs/employee/view/add_employee_view.dart';
import 'package:cashier/features/user/blocs/employee/view/employee_list_view.dart';
import 'package:cashier/features/user/views/register_view.dart';

import '../features/bottom_navigation_bar/views/bottom_view.dart';

import '../features/expense/views/expense_view.dart';
import '../features/home/bindings/home_binding.dart';
import '../features/home/views/home_view.dart';
import '../features/order/bindings/history_order_binding.dart';
import '../features/order/bindings/input_manual_binding.dart';

import '../features/order/views/history_order_view.dart';
import '../features/order/views/input_manual_view.dart';
import '../features/order/views/order_view.dart';
import '../features/printer/bindings/printer_binding.dart';
import '../features/printer/views/printer_view.dart';

import '../features/product/views/product_view.dart';
import '../features/settings/bindings/settings_binding.dart';
import '../features/settings/views/settings_view.dart';
import '../features/store/bindings/store_binding.dart';
import '../features/store/views/store_view.dart';
import '../features/user/views/login_view.dart';
import '../features/user/views/profile_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: _Paths.splash,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: _Paths.home,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.order,
      page: () => OrderView(),
    ),
    GetPage(
      name: _Paths.productList,
      page: () => ProductList(),
    ),
    GetPage(
      name: _Paths.checkOut,
      page: () => CheckOutView(),
    ),
    GetPage(
      name: _Paths.bottom,
      page: () => BottomView(),
    ),
    GetPage(
      name: _Paths.product,
      page: () => const ProductView(),
    ),
    GetPage(
      name: _Paths.addMenus,
      page: () => AddProductView(),
    ),

    GetPage(
      name: _Paths.settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.historyOrder,
      page: () => HistoryOrderView(),
      binding: RiwayatBinding(),
    ),
    GetPage(
      name: _Paths.expense,
      page: () => const ExpenseView(),
      // binding: PengeluaranBinding(),
    ),
    GetPage(
      name: _Paths.printer,
      page: () => const PrinterView(),
      binding: PrinterBinding(),
    ),
    GetPage(
      name: _Paths.inputManual,
      page: () => const InputManualView(),
      binding: InputManualBinding(),
    ),
    GetPage(name: _Paths.login, page: () => LoginView(), children: [
      GetPage(
        name: _Paths.register,
        page: () => RegisterView(),
      )
    ]),
    GetPage(
      name: _Paths.profile,
      page: () => const ProfileView(),
      // binding: ProfileBinding(),
    ),
    // GetPage(
    //   name: _Paths.editProfile,
    //   page: () => EditProfileView(),
    //   // binding: ProfileBinding(),
    // ),
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
    ),
    GetPage(
      name: _Paths.addEmployee,
      page: () => AddEmployeeView(),
    ),
  ];
}
