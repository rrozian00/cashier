import '../../../../../core/theme/colors.dart';
import '../../../../../core/widgets/no_data.dart';
import '../bloc/employee_bloc.dart';
import 'detail_emlpoyee.dart';
import 'edit_employee.dart';
import '../../../../../routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
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

            if (state is EmployeeGetSuccess) {
              final employees = state.employees;

              if (employees.isNotEmpty) {
                return Column(
                  children: [
                    Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 20,
                        )),
                    Expanded(
                      flex: 50,
                      child: ListView.builder(
                        itemCount: state.employees.length,
                        itemBuilder: (context, index) {
                          final data = state.employees[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 3),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "${index + 1}",
                                  style: GoogleFonts.roboto(
                                    // color: blue,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Flexible(
                                  child: Card(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    elevation: 4,
                                    borderOnForeground: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ListTile(
                                      onTap: () {
                                        Get.bottomSheet(
                                            backgroundColor: white,
                                            isScrollControlled: true,
                                            DetailEmlpoyee(
                                              data: data,
                                            ));
                                      },
                                      trailing: Wrap(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Get.bottomSheet(
                                                  clipBehavior: Clip.hardEdge,
                                                  EditEmployee(
                                                    id: data.id ?? '',
                                                    name: data.name ?? '',
                                                    address: data.address ?? '',
                                                    phone:
                                                        data.phoneNumber ?? '',
                                                    salary: data.salary ?? '',
                                                  ));
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              // color: blue,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              Get.dialog(AlertDialog(
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      "Hapus",
                                                      style: TextStyle(
                                                          fontSize: 23),
                                                    ),
                                                    SizedBox(
                                                      height: 25,
                                                    ),
                                                    Text(
                                                        "Apakah anda yakin akan menghapus ${data.name} ?"),
                                                    SizedBox(
                                                      height: 25,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        ElevatedButton(
                                                            child:
                                                                Text("Batal"),
                                                            // width: 110,
                                                            // text: "Batal",
                                                            onPressed: () =>
                                                                Get.back()),
                                                        ElevatedButton(
                                                            child:
                                                                Text("Hapus"),
                                                            // width: 110,
                                                            // text: "Hapus",
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                              context
                                                                  .read<
                                                                      EmployeeBloc>()
                                                                  .add(DeleteEmployeeRequested(
                                                                      data.id!));
                                                              context
                                                                  .read<
                                                                      EmployeeBloc>()
                                                                  .add(
                                                                      GetEmployeeRequested());
                                                            }),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ));
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: red,
                                            ),
                                          ),
                                        ],
                                      ),
                                      title: Text(
                                        data.name ?? '',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        data.email ?? '',
                                        style: TextStyle(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
            }
            return noData(
                title: "Tidak ada data Karyawan",
                message: "Silahkan Tambah Karyawan");
          },
        ),
      ),
      floatingActionButton: ElevatedButton(
        // width: 220,
        // height: 45,
        onPressed: () => Get.toNamed(Routes.addEmployee),
        child: Text("Tambah Karyawan"),
      ),
    );
  }
}
