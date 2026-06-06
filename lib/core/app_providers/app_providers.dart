import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../features/expense/bloc/expense_bloc.dart';
import '../../features/home/bloc/home_bloc.dart';
import '../../features/navbar/bloc/navbar_bloc.dart';
import '../../features/order/check_out/bloc/check_out_bloc.dart';
import '../../features/order/history_order/bloc/history_order_bloc.dart';
import '../../features/order/input_manual/bloc/input_manual_bloc.dart';
import '../../features/order/order/bloc/order_bloc.dart';
import '../../features/printer/bloc/printer_bloc.dart';
import '../../features/product/blocs/cubit/category_cubit.dart';
import '../../features/product/blocs/product_bloc.dart';
import '../../features/setting/cubit/version_cubit.dart';
import '../../features/splash_screen/bloc/splash_screen_bloc.dart';
import '../../features/store/bloc/store_bloc.dart';
import '../../features/store/repositories/store_repository.dart';
import '../../features/user/employee/bloc/employee_bloc.dart';
import '../../features/user/login/bloc/login_bloc.dart';
import '../../features/user/profile/blocs/edit_profile_bloc/edit_profile_bloc.dart';
import '../../features/user/profile/blocs/profile_bloc/profile_bloc.dart';
import '../../features/user/register/bloc/register_bloc.dart';
import '../../features/user/repositories/auth_repository.dart';
import '../../features/user/repositories/user_repository.dart';
import '../app_theme/theme_cubit/theme_cubit.dart';
import '../app_theme/theme_service.dart';

var myi = GetIt.instance;
final List<BlocProvider> appProviders = [
  BlocProvider<SplashScreenBloc>(
      create: (context) => SplashScreenBloc()..add(AuthenticationChecked())),
  BlocProvider<NavbarBloc>(
      create: (context) => NavbarBloc()..add(NavbarStarted())),
  BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
  BlocProvider<ProfileBloc>(
      create: (context) => ProfileBloc(UserRepository(), AuthRepository())),
  BlocProvider<RegisterBloc>(create: (context) => RegisterBloc()),
  BlocProvider<EmployeeBloc>(create: (context) => EmployeeBloc()),
  BlocProvider<ExpenseBloc>(create: (context) => ExpenseBloc()),
  BlocProvider<HomeBloc>(
      create: (context) =>
          HomeBloc(AuthRepository(), StoreRepository(), UserRepository())),
  BlocProvider<ProductBloc>(create: (context) => ProductBloc()),
  BlocProvider<OrderBloc>(create: (context) => OrderBloc()),
  BlocProvider<HistoryOrderBloc>(create: (context) => HistoryOrderBloc()),
  BlocProvider<CheckOutBloc>(create: (context) => CheckOutBloc()),
  BlocProvider<ThemeCubit>(create: (context) => ThemeCubit(ThemeService())),
  BlocProvider<VersionCubit>(create: (context) => VersionCubit()),
  BlocProvider<StoreBloc>(
      create: (context) => StoreBloc(StoreRepository(), UserRepository())),
  BlocProvider<EditProfileBloc>(create: (context) => EditProfileBloc()),
  BlocProvider<CategoryCubit>(create: (context) => CategoryCubit()),
  BlocProvider<PrinterBloc>(create: (context) => PrinterBloc()),
  BlocProvider<InputManualBloc>(create: (context) => InputManualBloc()),
];
