import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/rekapan_controller.dart';

class RekapanView extends GetView<RekapanController> {
  const RekapanView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekapan'),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning,
              size: 50,
            ),
            Text(
              'Rekapan is not Available now',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
