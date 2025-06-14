import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/my_text_field.dart';
import '../../auth/auth_bloc.dart';
import '../bloc/employee_bloc.dart';

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
          // Navigator.pushReplacementNamed(context, Routes.login);
          Navigator.pop(context);
          context.read<EmployeeBloc>().add(GetEmployeeRequested());
        } else if (state is EmployeeFailed) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Text(state.message),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Tambah Karyawan")),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  MyTextField(
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
                  MyTextField(
                      textCapitalization: TextCapitalization.none,
                      controller: emailC,
                      textInputType: TextInputType.emailAddress,
                      label: "Email",
                      hint: "Email"),
                  SizedBox(height: 10),
                  MyTextField(
                    obscure: true,
                    textCapitalization: TextCapitalization.none,
                    controller: passwordC,
                    label: "Password",
                    hint: "Password",
                  ),
                  SizedBox(height: 10),
                  MyTextField(
                    controller: addressC,
                    label: "Alamat",
                    hint: "Alamat",
                  ),
                  SizedBox(height: 10),
                  MyTextField(
                      controller: phoneC,
                      textInputType: TextInputType.phone,
                      label: "No HP",
                      hint: "No HP"),
                  SizedBox(height: 10),
                  MyTextField(
                      suffix: "( % )",
                      controller: salaryC,
                      textInputType: TextInputType.number,
                      label: "Persentase Gaji",
                      hint: "Persentase Gaji"),
                  SizedBox(height: 20),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoggedState) {
                        return ElevatedButton(onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<EmployeeBloc>().add(AddEmployeePressed(
                                  name: nameC.text,
                                  email: emailC.text,
                                  phone: phoneC.text,
                                  address: addressC.text,
                                  salary: salaryC.text,
                                  password: passwordC.text,
                                ));
                          }
                        }, child: BlocBuilder<EmployeeBloc, EmployeeState>(
                          builder: (context, state) {
                            if (state is EmployeeLoading) {
                              return CircularProgressIndicator.adaptive();
                            }
                            return Text(
                              "Simpan",
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
