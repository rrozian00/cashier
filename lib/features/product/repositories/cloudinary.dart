import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class Cloudinary {
  static Future<Map<String, dynamic>> uploadImageToCloudinary(
      File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();

      final uri =
          Uri.parse('https://api.cloudinary.com/v1_1/dvc6x08kw/image/upload');

      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = 'cashier'
        ..files.add(http.MultipartFile.fromBytes('file', bytes,
            filename: 'product.jpg'));

      final response = await request.send();
      final resBody = await response.stream.bytesToString();

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Gagal upload ke Cloudinary: $resBody");
      }

      final data = jsonDecode(resBody);
      return {
        'secure_url': data['secure_url'],
        'public_id': data['public_id'],
      };
    } catch (e) {
      throw Exception("Upload error: ${e.toString()}");
    }
  }

  static Future<void> deleteImageFromCloudinary(String publicId) async {
    final cloudName = 'dvc6x08kw';
    final apiKey = '941964148458378';
    final apiSecret = '78S7XNfKQwXh_fbSXylOS8h9BUE';

    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    // Buat signature
    final signatureRaw = 'public_id=$publicId&timestamp=$timestamp$apiSecret';
    final signature = sha1.convert(utf8.encode(signatureRaw)).toString();

    final uri =
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/destroy');

    final response = await http.post(
      uri,
      body: {
        'public_id': publicId,
        'api_key': apiKey,
        'timestamp': timestamp.toString(),
        'signature': signature,
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Gagal hapus gambar: ${response.body}");
    }
  }
}
