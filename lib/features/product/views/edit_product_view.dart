// // import 'dart:io';

// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';

// // import '../../../core/utils/my_snackbar.dart';
// // import '../../../core/utils/rupiah_converter.dart';
// // import '../blocs/product_bloc.dart';
// // import '../models/product_model.dart';

// // class EditProductView extends StatefulWidget {
// //   final ProductModel productData; // Receive data as parameter

// //   const EditProductView({super.key, required this.productData});

// //   @override
// //   State<EditProductView> createState() => _EditProductViewState();
// // }

// // class _EditProductViewState extends State<EditProductView> {
// //   late final TextEditingController productCode;
// //   late final TextEditingController nameC;
// //   late final TextEditingController priceC;

// //   @override
// //   void initState() {
// //     super.initState();

// //     // Initialize controllers with product data
// //     productCode = TextEditingController(text: widget.productData.id ?? '');
// //     nameC = TextEditingController(text: widget.productData.name ?? '');
// //     priceC = TextEditingController(
// //         text: rupiahConverter(widget.productData.price ?? 0));
// //   }

// //   @override
// //   void dispose() {
// //     productCode.dispose();
// //     nameC.dispose();
// //     priceC.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return BlocListener<ProductBloc, ProductState>(
// //       listener: (context, state) {
// //         if (state is ProductEditSuccess) {
// //           context.read<ProductBloc>().add(ProductGetRequested());
// //           Navigator.pop(context);
// //         }
// //         if (state is PickImageError) {
// //           showMysnackbar(context, state.message, isError: true);
// //         }
// //       },
// //       child: Scaffold(
// //         appBar: AppBar(
// //           title: Text("Edit Produk"),
// //         ),
// //         body: BlocBuilder<ProductBloc, ProductState>(
// //           builder: (context, state) {
// //             if (state is ProductEditLoading) {
// //               return Center(
// //                 child: CircularProgressIndicator.adaptive(),
// //               );
// //             }
// //             return Padding(
// //               padding: const EdgeInsets.all(8.0),
// //               child: SingleChildScrollView(
// //                 child: Column(
// //                   children: [
// //                     GestureDetector(
// //                       onTap: () => context
// //                           .read<ProductBloc>()
// //                           .add(ProductPickImageReq()),
// //                       child: Stack(
// //                         children: [
// //                           Container(
// //                             height: 80,
// //                             width: 80,
// //                             decoration: BoxDecoration(
// //                               shape: BoxShape.circle,
// //                               color: Colors.grey.withAlpha(100),
// //                             ),
// //                             child: ClipOval(
// //                                 child: BlocBuilder<ProductBloc, ProductState>(
// //                               builder: (context, state) {
// //                                 if (state is PickImageSuccess) {
// //                                   if (state.pickedImage.isNotEmpty) {
// //                                     return Image.file(
// //                                         fit: BoxFit.cover,
// //                                         File(state.pickedImage));
// //                                   }
// //                                 }
// //                                 if (state is PickImageError) {
// //                                   return Center(
// //                                     child: Text("Error"),
// //                                   );
// //                                 }
// //                                 if (state is ProductPickLoading) {
// //                                   return Center(
// //                                       child:
// //                                           CircularProgressIndicator.adaptive());
// //                                 }
// //                                 return Image.network(
// //                                   fit: BoxFit.cover,
// //                                   widget.productData.image!,
// //                                 );
// //                               },
// //                             )),
// //                           ),
// //                           Positioned(
// //                               right: 6,
// //                               bottom: 6,
// //                               child: Icon(
// //                                 Icons.add_a_photo,
// //                                 size: 25,
// //                               ))
// //                         ],
// //                       ),
// //                     ),
// //                     const SizedBox(height: 12),
// //                     TextField(
// //                       readOnly: true,
// //                       keyboardType: TextInputType.number,
// //                       controller: productCode,
// //                       textInputAction: TextInputAction.next,
// //                       textCapitalization: TextCapitalization.characters,
// //                       decoration: InputDecoration(
// //                         labelText: "Kode Produk",
// //                         border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(15),
// //                         ),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 8),
// //                     TextField(
// //                       controller: nameC,
// //                       textInputAction: TextInputAction.next,
// //                       textCapitalization: TextCapitalization.characters,
// //                       decoration: InputDecoration(
// //                         labelText: "Nama",
// //                         border: OutlineInputBorder(
// //                             borderRadius: BorderRadius.circular(15)),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 8),
// //                     TextField(
// //                       controller: priceC,
// //                       keyboardType: TextInputType.number,
// //                       onChanged: (value) {
// //                         String rawValue =
// //                             value.replaceAll(RegExp(r'[^\d]'), '');
// //                         int parsedValue = int.tryParse(rawValue) ?? 0;
// //                         priceC.value = TextEditingValue(
// //                           text: rupiahConverter(parsedValue),
// //                           selection: TextSelection.collapsed(
// //                               offset: rupiahConverter(parsedValue).length),
// //                         );
// //                       },
// //                       decoration: InputDecoration(
// //                         labelText: "Harga",
// //                         border: OutlineInputBorder(
// //                             borderRadius: BorderRadius.circular(15)),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 25),
// //                     ElevatedButton(
// //                       child: Text("Simpan"),
// //                       onPressed: () {
// //                         context.read<ProductBloc>().add(ProductEditRequested(
// //                               id: widget.productData.id!,
// //                               newName: nameC.text,
// //                               newPrice: int.parse(
// //                                   priceC.text.replaceAll(RegExp(r'[^\d]'), '')),
// //                               publicId: widget.productData.publicId ?? "",
// //                             ));
// //                       },
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             );
// //           },
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';

// import '../../../core/utils/my_snackbar.dart';
// import '../../../core/utils/rupiah_converter.dart';
// import '../blocs/product_bloc.dart';
// import '../models/product_model.dart';

// class EditProductView extends StatefulWidget {
//   final ProductModel productData;

//   const EditProductView({super.key, required this.productData});

//   @override
//   State<EditProductView> createState() => _EditProductViewState();
// }

// class _EditProductViewState extends State<EditProductView> {
//   late final TextEditingController productCode;
//   late final TextEditingController nameC;
//   late final TextEditingController priceC;

//   // Local State untuk mengelola gambar baru yang dipilih (Best Practice)
//   File? _newSelectedImage;
//   bool _isPickImageLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     productCode = TextEditingController(text: widget.productData.id ?? '');
//     nameC = TextEditingController(text: widget.productData.name ?? '');
//     priceC = TextEditingController(
//         text: rupiahConverter(widget.productData.price ?? 0));
//   }

//   @override
//   void dispose() {
//     productCode.dispose();
//     nameC.dispose();
//     priceC.dispose();
//     super.dispose();
//   }

//   // Fungsi internal untuk memilih gambar baru
//   Future<void> _pickImage() async {
//     final ImagePicker picker = ImagePicker();
//     setState(() => _isPickImageLoading = true);

//     try {
//       final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//       if (pickedFile != null) {
//         final imageFile = File(pickedFile.path);
//         final fileSize = await imageFile.length();

//         // Validasi Ukuran Maksimal 1MB
//         if (fileSize > 1 * 1024 * 1024) {
//           if (mounted) {
//             showMysnackbar(context, "Ukuran gambar terlalu besar (Maks 1MB)",
//                 isError: true);
//           }
//           return;
//         }

//         setState(() => _newSelectedImage = imageFile);
//       }
//     } catch (e) {
//       if (mounted) {
//         showMysnackbar(context, "Gagal mengambil gambar", isError: true);
//       }
//     } finally {
//       setState(() => _isPickImageLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Edit Produk"),
//       ),
//       body: BlocConsumer<ProductBloc, ProductState>(
//         listener: (context, state) {
//           // Jika proses update berhasil, state global berubah menjadi ProductSuccess (karena me-refresh list data)
//           if (state is ProductSuccess) {
//             Navigator.pop(context);
//             showMysnackbar(context, "Produk berhasil diperbarui");
//           }
//           if (state is ProductFailed) {
//             showMysnackbar(context, state.message, isError: true);
//           }
//         },
//         builder: (context, state) {
//           final isLoading = state is ProductLoading;

//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   // Image Picker Circle Section
//                   GestureDetector(
//                     onTap: _isPickImageLoading ? null : _pickImage,
//                     child: Stack(
//                       children: [
//                         Container(
//                           height: 80,
//                           width: 80,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.grey.withAlpha(100),
//                           ),
//                           child: ClipOval(
//                             child: _isPickImageLoading
//                                 ? const Center(
//                                     child: CircularProgressIndicator.adaptive())
//                                 : _newSelectedImage != null
//                                     ? Image.file(_newSelectedImage!,
//                                         fit: BoxFit.cover)
//                                     : (widget.productData.image != null &&
//                                             widget
//                                                 .productData.image!.isNotEmpty)
//                                         ? Image.network(
//                                             widget.productData.image!,
//                                             fit: BoxFit.cover)
//                                         : const Center(
//                                             child: Icon(Icons.add_a_photo,
//                                                 size: 30)),
//                           ),
//                         ),
//                         Positioned(
//                           right: 4,
//                           bottom: 4,
//                           child: Container(
//                             padding: const EdgeInsets.all(4),
//                             decoration: const BoxDecoration(
//                               color: Colors.blue,
//                               shape: BoxShape.circle,
//                             ),
//                             child: const Icon(
//                               Icons.edit,
//                               size: 14,
//                               color: Colors.white,
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 12),

//                   // Product Code Field
//                   TextField(
//                     readOnly: true,
//                     keyboardType: TextInputType.number,
//                     controller: productCode,
//                     textInputAction: TextInputAction.next,
//                     textCapitalization: TextCapitalization.characters,
//                     decoration: InputDecoration(
//                       labelText: "Kode Produk",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 8),

//                   // Name Field
//                   TextField(
//                     controller: nameC,
//                     textInputAction: TextInputAction.next,
//                     textCapitalization: TextCapitalization.words,
//                     decoration: InputDecoration(
//                       labelText: "Nama",
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(15)),
//                     ),
//                   ),
//                   const SizedBox(height: 8),

//                   // Price Field
//                   TextField(
//                     controller: priceC,
//                     keyboardType: TextInputType.number,
//                     onChanged: (value) {
//                       String rawValue = value.replaceAll(RegExp(r'[^\d]'), '');
//                       int parsedValue = int.tryParse(rawValue) ?? 0;
//                       priceC.value = TextEditingValue(
//                         text: rupiahConverter(parsedValue),
//                         selection: TextSelection.collapsed(
//                             offset: rupiahConverter(parsedValue).length),
//                       );
//                     },
//                     decoration: InputDecoration(
//                       labelText: "Harga",
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(15)),
//                     ),
//                   ),
//                   const SizedBox(height: 25),

//                   // Submit / Save Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                       ),
//                       onPressed: isLoading
//                           ? null
//                           : () {
//                               if (nameC.text.trim().isEmpty ||
//                                   priceC.text.isEmpty) {
//                                 showMysnackbar(
//                                     context, "Nama dan Harga wajib diisi",
//                                     isError: true);
//                                 return;
//                               }

//                               context
//                                   .read<ProductBloc>()
//                                   .add(ProductEditRequested(
//                                     id: widget.productData.id!,
//                                     newName: nameC.text,
//                                     newPrice: int.parse(priceC.text
//                                         .replaceAll(RegExp(r'[^\d]'), '')),
//                                     newImage: _newSelectedImage,
//                                     publicId: widget.productData.publicId ?? "",
//                                   ));
//                             },
//                       child: isLoading
//                           ? const SizedBox(
//                               height: 20,
//                               width: 20,
//                               child: CircularProgressIndicator.adaptive(
//                                 strokeWidth: 2,
//                               ),
//                             )
//                           : const Text("Simpan Changes"),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/my_snackbar.dart';
import '../../../core/utils/rupiah_converter.dart';
import '../../../core/widgets/image_picker_field.dart'; // Import Custom Widget
import '../blocs/product_bloc.dart';
import '../models/product_model.dart';

class EditProductView extends StatefulWidget {
  final ProductModel productData;

  const EditProductView({super.key, required this.productData});

  @override
  State<EditProductView> createState() => _EditProductViewState();
}

class _EditProductViewState extends State<EditProductView> {
  late final TextEditingController productCode;
  late final TextEditingController nameC;
  late final TextEditingController priceC;

  // Local State untuk menampung file baru dari callback (Best Practice)
  File? _newSelectedImage;

  @override
  void initState() {
    super.initState();
    productCode = TextEditingController(text: widget.productData.id ?? '');
    nameC = TextEditingController(text: widget.productData.name ?? '');
    priceC = TextEditingController(
        text: rupiahConverter(widget.productData.price ?? 0));
  }

  @override
  void dispose() {
    productCode.dispose();
    nameC.dispose();
    priceC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Produk"),
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          // Pola Unified State: Sukses Edit otomatis kembali ke ProductSuccess (Refresh List)
          if (state is ProductSuccess) {
            Navigator.pop(context);
            showMysnackbar(context, "Produk berhasil diperbarui");
          }
          if (state is ProductFailed) {
            showMysnackbar(context, state.message, isError: true);
          }
        },
        builder: (context, state) {
          final isLoading = state is ProductLoading;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 🔹 PENERAPAN BEST PRACTICE: Menggunakan Reusable Custom Widget
                  Center(
                    child: ImagePickerField(
                      // Tampilkan gambar lama yang sudah tersimpan di cloud
                      initialImageUrl: widget.productData.image,
                      onImageSelected: (file) {
                        // Tangkap file baru jika user mengubah gambar
                        _newSelectedImage = file;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Product Code Field (Read Only)
                  TextField(
                    readOnly: true,
                    controller: productCode,
                    decoration: InputDecoration(
                      labelText: "Kode Produk",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Name Field
                  TextField(
                    controller: nameC,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: "Nama Produk",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Price Field
                  TextField(
                    controller: priceC,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      String rawValue = value.replaceAll(RegExp(r'[^\d]'), '');
                      int parsedValue = int.tryParse(rawValue) ?? 0;
                      priceC.value = TextEditingValue(
                        text: rupiahConverter(parsedValue),
                        selection: TextSelection.collapsed(
                            offset: rupiahConverter(parsedValue).length),
                      );
                    },
                    decoration: InputDecoration(
                      labelText: "Harga",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: isLoading
                          ? null
                          : () {
                              if (nameC.text.trim().isEmpty ||
                                  priceC.text.isEmpty) {
                                showMysnackbar(
                                    context, "Nama dan Harga wajib diisi",
                                    isError: true);
                                return;
                              }

                              context
                                  .read<ProductBloc>()
                                  .add(ProductEditRequested(
                                    id: widget.productData.id!,
                                    newName: nameC.text,
                                    newPrice: int.parse(priceC.text
                                        .replaceAll(RegExp(r'[^\d]'), '')),
                                    newImage:
                                        _newSelectedImage, // Passing file lokal hasil picking (bisa null jika gambar tak diganti)
                                    publicId: widget.productData.publicId ?? "",
                                  ));
                            },
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text("Simpan Perubahan",
                              style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
