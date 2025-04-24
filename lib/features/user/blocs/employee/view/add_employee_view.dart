import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/core/widgets/my_elevated.dart';
import 'package:cashier/core/widgets/my_text_field.dart';
import 'package:cashier/features/user/blocs/auth/auth_bloc.dart';
import 'package:cashier/features/user/blocs/employee/bloc/employee_bloc.dart';
import 'package:cashier/features/user/models/user_model.dart';
import 'package:cashier/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:cashier/core/widgets/my_appbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class AddEmployeeView extends StatelessWidget {
  AddEmployeeView({super.key});

  final TextEditingController nameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();
  final TextEditingController addressC = TextEditingController();
  final TextEditingController salaryC = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeBloc, EmployeeState>(
      listener: (context, state) {
        if (state is EmployeeAddSuccess) {
          Navigator.pushReplacementNamed(context, Routes.login);
          // context.read<EmployeeBloc>().add(GetEmployeeRequested());
        } else if (state is EmployeeFailed) {
          throw Exception(state.message);
        }
      },
      child: Scaffold(
        backgroundColor: softGrey,
        appBar: MyAppBar(titleText: "Tambah Karyawan"),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  MyText(
                    controller: nameC,
                    label: "Nama",
                    hint: "Nama",
                    validator: (p0) {
                      if (nameC.text.isEmpty) {
                        return "Nama tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  MyText(
                      textCapitalization: TextCapitalization.none,
                      controller: emailC,
                      textInputType: TextInputType.emailAddress,
                      label: "Email",
                      hint: "Email"),
                  SizedBox(height: 10),
                  MyText(
                    obscure: true,
                    textCapitalization: TextCapitalization.none,
                    controller: passwordC,
                    label: "Password",
                    hint: "Password",
                  ),
                  SizedBox(height: 10),
                  MyText(
                    controller: addressC,
                    label: "Alamat",
                    hint: "Alamat",
                  ),
                  SizedBox(height: 10),
                  MyText(
                      controller: phoneC,
                      textInputType: TextInputType.phone,
                      label: "No HP",
                      hint: "No HP"),
                  SizedBox(height: 10),
                  MyText(
                      suffix: "( % )",
                      controller: salaryC,
                      textInputType: TextInputType.number,
                      label: "Persentase Gaji",
                      hint: "Persentase Gaji"),
                  SizedBox(height: 20),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoggedState) {
                        return myPurpleElevated(onPress: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<EmployeeBloc>().add(AddEmployeePressed(
                                employee: UserModel(
                                    id: state.user.id,
                                    role: state.user.role,
                                    storeId: state.user.storeId,
                                    name: nameC.text,
                                    email: emailC.text,
                                    phoneNumber: phoneC.text,
                                    address: addressC.text,
                                    salary: salaryC.text,
                                    createdAt: Timestamp.now()),
                                password: passwordC.text));
                          }
                        }, child: BlocBuilder<EmployeeBloc, EmployeeState>(
                          builder: (context, state) {
                            if (state is EmployeeLoading) {
                              return CircularProgressIndicator.adaptive();
                            }
                            return Text(
                              "Simpan",
                              style: GoogleFonts.poppins(
                                  color: white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400),
                            );
                          },
                        ));
                      }
                      return CircularProgressIndicator.adaptive();
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
