import 'package:cashier/features/expense/bloc/expense_bloc.dart';
import 'package:cashier/features/user/blocs/auth/auth_bloc.dart';
import 'package:cashier/features/bottom_navigation_bar/cubit/bottom_nav_cubit.dart';
import 'package:cashier/features/user/blocs/employee/bloc/employee_bloc.dart';
import 'package:cashier/features/user/blocs/register/register_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final List<BlocProvider> appProviders = [
  BlocProvider<BottomNavCubit>(create: (context) => BottomNavCubit()),
  BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
  BlocProvider<RegisterBloc>(create: (context) => RegisterBloc()),
  BlocProvider<EmployeeBloc>(create: (context) => EmployeeBloc()),
  BlocProvider<ExpenseBloc>(create: (context) => ExpenseBloc()),
];
