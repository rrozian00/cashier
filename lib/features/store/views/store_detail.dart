import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/store_bloc.dart';
import 'edit_store.dart';

class StoreDetail extends StatelessWidget {
  const StoreDetail({
    super.key,
    required this.index,
  });
  final int index;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil Toko"),
      ),
      body: SafeArea(child: BlocBuilder<StoreBloc, StoreState>(
        builder: (context, state) {
          final curentState = state as GetStoreSuccess;
          final data = curentState.stores[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/store.png",
                          color: colorScheme.secondary,
                          width: 100,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    _MyList(
                        icon: Icons.store,
                        subtitle: data.name ?? '',
                        title: "Nama Toko"),
                    _MyList(
                        icon: Icons.location_on,
                        subtitle: data.address ?? '',
                        title: "Alamat Toko"),
                    _MyList(
                        icon: Icons.phone_android,
                        subtitle: data.phone ?? '',
                        title: "No HP Toko"),
                    SizedBox(height: 50),
                    ElevatedButton(
                        onPressed: () {
                          editStoreDialog(
                              context: context,
                              name: data.name ?? '',
                              address: data.address ?? '',
                              phone: data.phone ?? '');
                        },
                        child: Text(
                          "Ubah Toko",
                        ))
                  ],
                ),
              ),
            ),
          );
        },
      )),
    );
  }
}

class _MyList extends StatelessWidget {
  const _MyList({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          minTileHeight: 0,
          leading: Icon(
            color: Theme.of(context).colorScheme.secondary,
            icon,
          ),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
        ),
        Divider()
      ],
    );
  }
}
