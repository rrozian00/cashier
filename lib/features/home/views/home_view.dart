import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
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
          Get.offAllNamed(Routes.login);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tanggal Sekarang
                    const Date(),
                    //Tag Line
                    TagLineWidget(),
                  ],
                ),
                Column(
                  spacing: 15,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // // Animasi Logo Toko
                    StoreName(),
                    SizedBox(height: 10),

                    // Statistik Keuangan
                    StatisticList(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
