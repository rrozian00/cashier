import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Date extends StatelessWidget {
  const Date({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 10,
        children: [
          Icon(Icons.date_range),
          Text(
            DateFormat('EEEE, dd-MM-yyyy', 'id_ID').format(DateTime.now()),
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              // fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
