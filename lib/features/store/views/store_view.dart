import 'package:cashier/features/store/views/add_store_view.dart';

import '../../../core/widgets/no_data.dart';
import '../bloc/store_bloc.dart';
import 'store_detail.dart';
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
            if (state is StoreError && state.message == 'null') {
              return noData(
                title: "Tidak ada Toko ditemukan",
                message: "Silahkan buat Toko Anda.",
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
                          // final color = data.isActive == true
                          //     ? Theme.of(context).colorScheme.surface
                          //     : Theme.of(context).colorScheme.primary;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0),
                            child: Card(
                              // color: data.isActive == true
                              //     ? Theme.of(context).colorScheme.onPrimary
                              //     : Theme.of(context).colorScheme.surface,
                              child: ListTile(
                                trailing: data.isActive == true
                                    ? Text(
                                        "Aktif",
                                        style: TextStyle(color: Colors.green),
                                      )
                                    : TextButton(
                                        style: OutlinedButton.styleFrom(
                                            padding: EdgeInsets.all(0)),
                                        onPressed: () {
                                          context.read<StoreBloc>().add(
                                              MakeStoreActive(id: data.id!));
                                        },
                                        child: Text(
                                          "Aktifkan",
                                          style: TextStyle(fontSize: 12),
                                        )),
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
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  // color: color,
                                ),
                                title: Text(
                                  data.name ?? '',
                                  style: TextStyle(
                                      // color: color
                                      ),
                                ),
                                subtitle: Text(
                                  data.address ?? '',
                                  style: TextStyle(
                                      // color: color
                                      ),
                                ),
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
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddStoreView(),
                )),
            child: Text("Tambah Toko")),
      ),
    );
  }
}
