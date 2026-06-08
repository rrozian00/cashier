import 'package:cashier/features/employee/bloc/employee_bloc.dart';
import 'package:cashier/features/home/bloc/home_bloc.dart';
import 'package:cashier/features/order/history_order/bloc/history_order_bloc.dart';
import 'package:cashier/features/order/history_order/repos/history_order_repository.dart';
import 'package:cashier/features/order/order/bloc/order_bloc.dart';
import 'package:cashier/features/order/order/repositories/order_repository.dart';
import 'package:cashier/features/product/blocs/cubit/category_cubit.dart';
import 'package:cashier/features/product/blocs/product_bloc.dart';
import 'package:cashier/features/splash_screen/bloc/splash_screen_bloc.dart';
import 'package:cashier/features/store/bloc/store_bloc.dart';
import 'package:cashier/features/user/profile/blocs/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:cashier/features/user/profile/blocs/profile_bloc/profile_bloc.dart';
import 'package:cashier/features/user/register/bloc/register_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/employee/repo/employee_repo.dart';
import '../../features/navbar/bloc/navbar_bloc.dart';
import '../../features/order/check_out/bloc/check_out_bloc.dart';
import '../../features/order/input_manual/repositories/input_manual_repository.dart';
import '../../features/product/models/product_model.dart';
import '../../features/product/repositories/product_repository.dart';
import '../../features/setting/cubit/version_cubit.dart';
import '../../features/store/models/store_model.dart';
import '../../features/store/repositories/store_repository.dart';
import '../../features/user/login/bloc/login_bloc.dart';
import '../../features/user/models/user_model.dart';
import '../../features/user/repositories/auth_repository.dart';
import '../../features/user/repositories/user_repository.dart';
import '../app_theme/theme_cubit/theme_cubit.dart';
import '../app_theme/theme_service.dart';

var sl = GetIt.instance;

Future<void> initInjection() async {
  //BLOCS
  sl.registerFactory<ThemeCubit>(() => ThemeCubit(sl<ThemeService>()));
  sl.registerFactory<VersionCubit>(() => VersionCubit());
  sl.registerFactory<NavbarBloc>(() => NavbarBloc());
  sl.registerFactory<LoginBloc>(() => LoginBloc());
  sl.registerFactory<CheckOutBloc>(() => CheckOutBloc(
      sl<StoreRepository>(), sl<OrderRepository>(), sl<UserRepository>()));
  sl.registerFactory<SplashScreenBloc>(() => SplashScreenBloc());
  sl.registerFactory<RegisterBloc>(() => RegisterBloc());
  sl.registerFactory<EditProfileBloc>(() => EditProfileBloc());
  sl.registerFactory<ProfileBloc>(
      () => ProfileBloc(sl<UserRepository>(), sl<AuthRepository>()));
  sl.registerFactory<HomeBloc>(() => HomeBloc(
      sl<AuthRepository>(), sl<StoreRepository>(), sl<UserRepository>()));
  sl.registerFactory<OrderBloc>(
      () => OrderBloc(sl<OrderRepository>(), sl<ProductRepository>()));
  sl.registerFactory<StoreBloc>(
      () => StoreBloc(sl<StoreRepository>(), sl<UserRepository>()));
  sl.registerFactory<EmployeeBloc>(
      () => EmployeeBloc(sl<EmployeeRepo>(), sl<UserRepository>()));
  sl.registerFactory<ProductBloc>(() => ProductBloc(sl<ProductRepository>()));
  sl.registerFactory<HistoryOrderBloc>(
      () => HistoryOrderBloc(sl<HistoryOrderRepository>()));
  sl.registerFactory<CategoryCubit>(
      () => CategoryCubit(sl<ProductRepository>()));

//DATABASES
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  //REPOSITORIES
  sl.registerLazySingleton<UserRepository>(() => UserRepository());
  sl.registerLazySingleton<HistoryOrderRepository>(() => HistoryOrderRepository(
      sl<SupabaseClient>(), sl<UserRepository>(), sl<StoreRepository>()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository());
  sl.registerLazySingleton<OrderRepository>(() => OrderRepository(
      sl<SupabaseClient>(), sl<StoreRepository>(), sl<UserRepository>()));
  sl.registerLazySingleton<StoreRepository>(() => StoreRepository(
      sl<FirebaseFirestore>(), sl<SupabaseClient>(), sl<UserRepository>()));
  sl.registerLazySingleton<EmployeeRepo>(() => EmployeeRepo(
      sl<UserRepository>(), sl<StoreRepository>(), sl<SupabaseClient>()));
  sl.registerLazySingleton<InputManualRepository>(() => InputManualRepository(
      sl<SupabaseClient>(), sl<StoreRepository>(), sl<UserRepository>()));
  sl.registerLazySingleton<ProductRepository>(() => ProductRepository(
      sl<FirebaseFirestore>(), sl<SupabaseClient>(), sl<UserRepository>()));

  //MODELS
  sl.registerLazySingleton<UserModel>(() => UserModel());
  sl.registerLazySingleton<ProductModel>(() => ProductModel());
  sl.registerLazySingleton<StoreModel>(() => StoreModel());

  //SERVICES
  sl.registerLazySingleton<ThemeService>(() => ThemeService());
}
