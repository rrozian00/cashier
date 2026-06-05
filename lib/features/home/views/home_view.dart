import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_bloc.dart';
import 'widgets/date.dart';
import 'widgets/statistic_list.dart';
import 'widgets/store_name.dart';
import 'widgets/tag_line.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        return Scaffold(
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
        );
      },
    );
  }
}
