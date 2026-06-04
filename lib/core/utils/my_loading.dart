import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget myLoading() {
  return Platform.isIOS
      ? CupertinoActivityIndicator()
      : CircularProgressIndicator();
}
