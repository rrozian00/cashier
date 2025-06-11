import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../bloc/home_bloc.dart';

class StoreName extends StatefulWidget {
  const StoreName({super.key});

  @override
  State<StoreName> createState() => _StoreNameState();
}

class _StoreNameState extends State<StoreName> {
  @override
  void initState() {
    context.read<HomeBloc>().add(HomeGetStoreReq());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorThis = Theme.of(context).colorScheme.secondary;
    final shadow = Shadow(
        blurRadius: 2,
        color: Theme.of(context).colorScheme.primary,
        offset: Offset(1, 1));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          AnimatedContainer(
              duration: Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              child: Icon(
                shadows: [shadow],
                color: colorThis,
                Icons.store_rounded,
                size: 70,
              )),
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeSuccess) {
                return Text(
                  state.store.name ?? 'Nama Kosong',
                  style: GoogleFonts.pacifico(
                      shadows: [shadow],
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: colorThis),
                );
              }
              if (state is HomeError) {
                return Text("state error ${state.message}");
              }
              return Text("-Toko tidak ditemukan-");
            },
          )
        ],
      ),
    );
  }
}
