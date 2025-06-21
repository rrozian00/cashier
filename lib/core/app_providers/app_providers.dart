import 'package:cashier/features/order/input_manual/bloc/input_manual_bloc.dart';
import 'package:cashier/features/printer/bloc/printer_bloc.dart';
import 'package:cashier/features/product/blocs/cubit/category_cubit.dart';
import 'package:cashier/features/setting/cubit/version_cubit.dart';
import 'package:cashier/features/user/blocs/edit_user/edit_user_bloc.dart';

import '../../features/store/bloc/store_bloc.dart';
import '../../features/user/blocs/login/login_cubit.dart';
import 'package:get_it/get_it.dart';

import '../app_theme/theme_cubit/theme_cubit.dart';
import '../app_theme/theme_service.dart';
import '../../features/order/check_out/bloc/check_out_bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/navbar/cubit/bottom_nav_cubit.dart';
import '../../features/expense/bloc/expense_bloc.dart';
import '../../features/home/bloc/home_bloc.dart';
import '../../features/order/history_order/bloc/history_order_bloc.dart';
import '../../features/order/order/bloc/order_bloc.dart';
import '../../features/product/blocs/product_bloc/product_bloc.dart';
import '../../features/user/blocs/auth/auth_bloc.dart';
import '../../features/user/blocs/employee/bloc/employee_bloc.dart';
import '../../features/user/blocs/register/register_bloc.dart';

var myi = GetIt.instance;
final List<BlocProvider> appProviders = [
  BlocProvider<BottomNavCubit>(create: (context) => BottomNavCubit()),
  BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
  BlocProvider<RegisterBloc>(create: (context) => RegisterBloc()),
  BlocProvider<EmployeeBloc>(create: (context) => EmployeeBloc()),
  BlocProvider<ExpenseBloc>(create: (context) => ExpenseBloc()),
  BlocProvider<HomeBloc>(create: (context) => HomeBloc()),
  BlocProvider<ProductBloc>(create: (context) => ProductBloc()),
  BlocProvider<OrderBloc>(create: (context) => OrderBloc()),
  BlocProvider<HistoryOrderBloc>(
      create: (context) => HistoryOrderBloc(context: context)),
  BlocProvider<CheckOutBloc>(create: (context) => CheckOutBloc()),
  BlocProvider<ThemeCubit>(create: (context) => ThemeCubit(ThemeService())),
  BlocProvider<VersionCubit>(create: (context) => VersionCubit()),
  BlocProvider<StoreBloc>(create: (context) => StoreBloc()),
  BlocProvider<LoginCubit>(create: (context) => LoginCubit()),
  BlocProvider<EditUserBloc>(create: (context) => EditUserBloc()),
  BlocProvider<CategoryCubit>(create: (context) => CategoryCubit()),
  BlocProvider<PrinterBloc>(create: (context) => PrinterBloc()),
  BlocProvider<InputManualBloc>(create: (context) => InputManualBloc()),
];
