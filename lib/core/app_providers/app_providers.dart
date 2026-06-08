import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../features/employee/bloc/employee_bloc.dart';
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
import '../../features/user/login/bloc/login_bloc.dart';
import '../../features/user/profile/blocs/edit_profile_bloc/edit_profile_bloc.dart';
import '../../features/user/profile/blocs/profile_bloc/profile_bloc.dart';
import '../../features/user/register/bloc/register_bloc.dart';
import '../app_theme/theme_cubit/theme_cubit.dart';

var sl = GetIt.instance;

final List<BlocProvider> appProviders = [
  BlocProvider<SplashScreenBloc>(
      create: (context) =>
          sl<SplashScreenBloc>()..add(AuthenticationChecked())),
  BlocProvider<NavbarBloc>(
      create: (context) => sl<NavbarBloc>()..add(NavbarStarted())),
  BlocProvider<LoginBloc>(create: (context) => sl<LoginBloc>()),
  BlocProvider<ProfileBloc>(create: (context) => sl<ProfileBloc>()),
  BlocProvider<RegisterBloc>(create: (context) => sl<RegisterBloc>()),
  BlocProvider<EmployeeBloc>(create: (context) => sl<EmployeeBloc>()),
  BlocProvider<ExpenseBloc>(create: (context) => sl<ExpenseBloc>()),
  BlocProvider<HomeBloc>(
      create: (context) => sl<HomeBloc>()..add(HomeGetStoreReq())),
  BlocProvider<ProductBloc>(create: (context) => sl<ProductBloc>()),
  BlocProvider<OrderBloc>(create: (context) => sl<OrderBloc>()),
  BlocProvider<HistoryOrderBloc>(create: (context) => sl<HistoryOrderBloc>()),
  BlocProvider<CheckOutBloc>(create: (context) => sl<CheckOutBloc>()),
  BlocProvider<ThemeCubit>(create: (context) => sl<ThemeCubit>()),
  BlocProvider<VersionCubit>(create: (context) => sl<VersionCubit>()),
  BlocProvider<StoreBloc>(create: (context) => sl<StoreBloc>()),
  BlocProvider<EditProfileBloc>(create: (context) => sl<EditProfileBloc>()),
  BlocProvider<CategoryCubit>(create: (context) => sl<CategoryCubit>()),
  BlocProvider<PrinterBloc>(create: (context) => sl<PrinterBloc>()),
  BlocProvider<InputManualBloc>(create: (context) => sl<InputManualBloc>()),
];
