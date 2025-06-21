import 'package:cashier/features/user/blocs/employee/view/add_employee_view.dart';
import 'package:cashier/features/user/models/user_model.dart';

import '../../../../../core/widgets/no_data.dart';
import '../bloc/employee_bloc.dart';
import 'detail_emlpoyee.dart';
import 'edit_employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeeListView extends StatelessWidget {
  const EmployeeListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Karyawan"),
      ),
      body: SafeArea(
        child: BlocBuilder<EmployeeBloc, EmployeeState>(
          builder: (context, state) {
            if (state is EmployeeLoading) {
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            if (state is EmployeeFailed && state.message == "null") {
              return noData(
                  title: "Tidak ada karyawan ditemukan",
                  message: "Silahkan tambah karyawan.");
            }
            if (state is EmployeeFailed) {
              return noData(
                  icon: Icons.error, title: "Error", message: state.message);
            }
            if (state is EmployeeGetSuccess) {
              final employees = state.employees;
              if (employees.isNotEmpty) {
                return _buildListView(state);
              }
            }
            return Text("404");
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEmployeeView(),
            )),
        child: Text("Tambah Karyawan"),
      ),
    );
  }
}

Widget _buildListView(EmployeeGetSuccess state) {
  return ListView.builder(
    itemCount: state.employees.length,
    itemBuilder: (context, index) {
      final data = state.employees[index];
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
        child: Card(
          color: Theme.of(context).colorScheme.secondary,
          elevation: 4,
          borderOnForeground: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            leading: Text(
              "${index + 1}",
              style: GoogleFonts.roboto(
                // color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              //TODO
              showModalBottomSheet(
                context: context,
                builder: (context) => DetailEmlpoyee(
                  data: data,
                ),
              );
            },
            trailing: Wrap(
              children: [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      showDragHandle: true,
                      isScrollControlled: true,
                      clipBehavior: Clip.hardEdge,
                      context: context,
                      builder: (context) => EditEmployee(
                        id: data.id ?? '',
                        name: data.name ?? '',
                        address: data.address ?? '',
                        phone: data.phoneNumber ?? '',
                        salary: data.salary ?? '',
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.edit,
                    // color: Colors.blue,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _showDeleteDialog(context, data);
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            title: Text(
              data.name ?? '',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              data.email ?? '',
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onSecondary),
            ),
          ),
        ),
      );
    },
  );
}

_showDeleteDialog(BuildContext context, UserModel data) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Hapus",
            style: TextStyle(fontSize: 23),
          ),
          SizedBox(
            height: 25,
          ),
          Text(
              textAlign: TextAlign.center,
              "Apakah anda yakin akan menghapus ${data.name} dari Karyawan ?"),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  child: Text("Batal"),
                  onPressed: () => Navigator.pop(context)),
              ElevatedButton(
                  child: Text("Hapus"),
                  onPressed: () {
                    Navigator.pop(context);
                    context
                        .read<EmployeeBloc>()
                        .add(DeleteEmployeeRequested(data.id!));
                    context.read<EmployeeBloc>().add(GetEmployeeRequested());
                  }),
            ],
          )
        ],
      ),
    ),
  );
}
