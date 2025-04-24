import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ProductRepository {
  Future<String> uploadImageToCloudinary(File imageFile) async {
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
      return data['secure_url'];
    } catch (e) {
      throw Exception("Upload error: ${e.toString()}");
    }
  }
}
