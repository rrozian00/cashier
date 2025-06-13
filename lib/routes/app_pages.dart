import 'package:get/get.dart';

import '../core/splash_screen/splash_screen.dart';
import '../features/bottom_navbar/views/bottom_view.dart';
import '../features/expense/views/expense_view.dart';
import '../features/order/history_order/views/history_order_view.dart';
import '../features/order/input_manual/bindings/input_manual_binding.dart';
import '../features/order/input_manual/views/input_manual_view.dart';
import '../features/order/order/views/order_view.dart';
import '../features/printer/bindings/printer_binding.dart';
import '../features/printer/views/printer_view.dart';
import '../features/product/views/add_product_view.dart';
import '../features/product/views/product_list.dart';
import '../features/product/views/product_view.dart';
import '../features/settings/views/settings_view.dart';
import '../features/store/bindings/store_binding.dart';
import '../features/store/views/add_store_view.dart';
import '../features/store/views/store_view.dart';
import '../features/user/blocs/employee/view/add_employee_view.dart';
import '../features/user/blocs/employee/view/employee_list_view.dart';
import '../features/user/views/login_view.dart';
import '../features/user/views/profile_view.dart';
import '../features/user/views/register_view.dart';

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
      name: _Paths.order,
      page: () => OrderView(),
    ),
    GetPage(
      name: _Paths.productList,
      page: () => ProductList(),
    ),
    // GetPage(
    //   name: _Paths.checkOut,
    //   page: () => CheckOutView(),
    // ),
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
    ),
    GetPage(
      name: _Paths.historyOrder,
      page: () => HistoryOrderView(),
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
      page: () => StoreView(),
      binding: StoreBinding(),
    ),
    GetPage(
      name: _Paths.addStore,
      page: () => AddStoreView(),
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
