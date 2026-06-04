import 'package:flutter/material.dart';

import '../widgets/history_header_widget.dart';

class HistoryOrderView extends StatelessWidget {
  const HistoryOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HistoryHeaderWidget(),
    );
  }
}
