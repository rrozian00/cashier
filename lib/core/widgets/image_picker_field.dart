import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerField extends StatefulWidget {
  final String? initialImageUrl; // Untuk menampilkan gambar lama saat Edit
  final Function(File? pickedFile)
      onImageSelected; // Kirim file ke halaman induk

  const ImagePickerField({
    super.key,
    this.initialImageUrl,
    required this.onImageSelected,
  });

  @override
  State<ImagePickerField> createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final fileSize = await file.length();

        // Validasi ukuran maksimal 1MB
        if (fileSize > 1 * 1024 * 1024) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("Ukuran gambar terlalu besar (Maks 1MB)")),
            );
          }
          return;
        }

        setState(() => _imageFile = file);
        widget.onImageSelected(_imageFile); // Lempar file ke halaman induk
      }
    } catch (e) {
      // Handle error izin galeri di sini
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: _imageFile != null
            ? Image.file(_imageFile!, fit: BoxFit.cover)
            : (widget.initialImageUrl != null &&
                    widget.initialImageUrl!.isNotEmpty)
                ? Image.network(widget.initialImageUrl!, fit: BoxFit.cover)
                : const Center(child: Icon(Icons.add_a_photo)),
      ),
    );
  }
}
