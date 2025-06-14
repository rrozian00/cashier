import 'package:cashier/core/widgets/no_data.dart';
import 'package:cashier/features/store/bloc/store_bloc.dart';
import 'package:cashier/features/store/views/store_detail.dart';
import 'package:cashier/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoreView extends StatelessWidget {
  const StoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<StoreBloc, StoreState>(
      listener: (context, state) {
        if (state is UpdateStoreSuccess) {
          context.read<StoreBloc>().add(GetStoresList());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Toko"),
        ),
        body: BlocBuilder<StoreBloc, StoreState>(
          builder: (context, state) {
            if (state is StoreLoading) {
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            if (state is GetStoreSuccess && state.stores.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 30,
                children: [
                  noData(
                    title: "Tidak ada Toko ditemukan",
                    message: "Silahkan buat Toko Anda.",
                  ),
                  ElevatedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, Routes.addStore),
                      child: Text("Tambah Toko"))
                ],
              );
            }
            if (state is GetStoreSuccess) {
              return SafeArea(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.stores.length,
                        itemBuilder: (context, index) {
                          final data = state.stores[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0),
                            child: Card(
                              color: data.isActive == true
                                  ? Theme.of(context).colorScheme.onSecondary
                                  : null,
                              child: ListTile(
                                trailing: data.isActive == true
                                    ? Text("Aktif")
                                    : null,
                                onLongPress: () => context
                                    .read<StoreBloc>()
                                    .add(MakeStoreActive(id: data.id!)),
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          StoreDetail(index: index),
                                    )),
                                leading: Image.asset(
                                  "assets/images/store.png",
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                title: Text(data.name ?? ''),
                                subtitle: Text(data.address ?? ''),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ));
            }
            if (state is StoreError) {
              return Center(
                child: Text(state.message),
              );
            }
            return Text("404");
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, Routes.addStore),
            child: Text("Tambah Toko")),
      ),
    );
  }
}
