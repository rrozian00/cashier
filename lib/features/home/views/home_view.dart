import 'package:cashier/features/user/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../user/blocs/auth/auth_bloc.dart';
import '../bloc/home_bloc.dart';
import 'widgets/date.dart';
import 'widgets/statistic_list.dart';
import 'widgets/store_name.dart';
import 'widgets/tag_line.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<HomeBloc>().add(HomeGetStoreReq());

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UnauthenticatedState) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginView(),
              ));
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  // Tanggal Sekarang
                  const Date(),

                  //Tag Line
                  const TagLineWidget(),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Animasi Logo Toko
                  const StoreName(),

                  // Statistik Keuangan
                  const StatisticList(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
