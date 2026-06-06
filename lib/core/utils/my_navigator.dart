import 'package:flutter/material.dart';

void myNavigatorTo(BuildContext context, Widget page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}
