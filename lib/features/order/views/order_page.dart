import 'package:cashier/core/theme/colors.dart';

import '../blocs/order_bloc/order_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<OrderBloc>().add(FetchProduct());
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ProductSuccess) {
            return SafeArea(
                child: ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final datas = state.products[index];
                return Padding(
                  padding: EdgeInsets.all(8),
                  child: Card(
                    color: softGrey,
                    child: ListTile(
                      onTap: () {},
                      leading: Image.network(datas.image ?? ''),
                      subtitle: Text(datas.price ?? ''),
                      title: Text(datas.name ?? ''),
                    ),
                  ),
                );
              },
            ));
          }
          return Text("404");
        },
      ),
    );
  }
}
