import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/core/widgets/my_appbar.dart';
import 'package:cashier/core/widgets/my_elevated.dart';
import 'package:cashier/core/widgets/no_data.dart';
import 'package:cashier/features/user/blocs/employee/bloc/employee_bloc.dart';
import 'package:cashier/features/user/blocs/employee/view/detail_emlpoyee.dart';
import 'package:cashier/features/user/blocs/employee/view/edit_employee.dart';
import 'package:cashier/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeeListView extends StatelessWidget {
  const EmployeeListView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<EmployeeBloc>().add(GetEmployeeRequested());
    return Scaffold(
      backgroundColor: softGrey,
      appBar: MyAppBar(
        titleText: "Daftar Karyawan",
      ),
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (state is EmployeeGetSuccess) {
            final employees = state.employees;

            if (employees.isNotEmpty) {
              return SafeArea(
                child: Column(
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "${index + 1}",
                                  style: GoogleFonts.roboto(
                                    color: blue,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Flexible(
                                  child: Card(
                                    color: white,
                                    elevation: 4,
                                    borderOnForeground: true,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(color: grey),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ListTile(
                                      onTap: () {
                                        Get.bottomSheet(
                                            backgroundColor: white,
                                            isScrollControlled: true,
                                            DetailEmlpoyee());
                                      },
                                      trailing: Wrap(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Get.bottomSheet(
                                                  backgroundColor: white,
                                                  enableDrag: true,
                                                  isScrollControlled: true,
                                                  EditEmployee(
                                                    name: data.name ?? '',
                                                    address: data.address ?? '',
                                                    phone:
                                                        data.phoneNumber ?? '',
                                                    salary: data.salary ?? '',
                                                  ));
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              color: blue,
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
                                                        myGreenElevated(
                                                            width: 110,
                                                            text: "Batal",
                                                            onPress: () =>
                                                                Get.back()),
                                                        myRedElevated(
                                                            width: 110,
                                                            text: "Hapus",
                                                            onPress: () async {
                                                              //TODO:
                                                              // await controller
                                                              //     .delete(
                                                              //         data.id!);
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
                                      title: Text(data.name ?? ''),
                                      subtitle: Text(
                                        data.email ?? '',
                                        style: TextStyle(color: red),
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
                ),
              );
            }
          }
          return noData(
              title: "Tidak ada data Karyawan",
              message: "Silahkan Tambah Karyawan");
        },
      ),
      floatingActionButton: myPurpleElevated(
          width: 220,
          height: 45,
          onPress: () => Get.toNamed(Routes.addEmployee),
          text: "Tambah Karyawan"),
    );
  }
}
