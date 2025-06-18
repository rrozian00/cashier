import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../bloc/home_bloc.dart';

class StoreName extends StatelessWidget {
  const StoreName({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<HomeBloc>().add(HomeGetStoreReq());

    final colorThis = Theme.of(context).colorScheme.secondary;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Icon(
            shadows: [
              Shadow(
                blurRadius: 2,
                color: Theme.of(context).colorScheme.primary,
                offset: Offset(1, 1),
              )
            ],
            Icons.store_rounded,
            color: colorThis,
            size: 70,
          ),
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              if (state is HomeSuccess) {
                return Text(
                  state.store.name ?? 'Nama Kosong',
                  style: GoogleFonts.pacifico(
                      shadows: [
                        Shadow(
                          blurRadius: 2,
                          color: Theme.of(context).colorScheme.primary,
                          offset: Offset(1, 1),
                        )
                      ],
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: colorThis),
                );
              }
              if (state is HomeError) {
                if (state.message == 'null') {
                  return Text(
                    "Silahkan Buat Toko pertama Anda.",
                    style: TextStyle(color: Colors.red),
                  );
                }
                return Text(
                  state.message,
                  style: TextStyle(color: Colors.red),
                );
              }
              return Text("-Toko tidak ditemukan-");
            },
          )
        ],
      ),
    );
  }
}
