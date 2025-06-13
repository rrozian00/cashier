import 'dart:convert';

import 'package:http/http.dart' as http;

void main() async {
  final res =
      await http.get(Uri.parse("https://api.github.com/users/rrozian00"));
  final data = jsonDecode(res.body);
  print(data["name"]);
}
