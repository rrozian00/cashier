class ProductModel {
  String? id;
  String? storeId;
  String? category;
  String? name;
  int? price;
  String? image;
  String? publicId;
  DateTime? registeredDate;
  DateTime? expiredDate;
  int? quantity;
  DateTime? createdAt;
  ProductModel({
    this.id,
    this.storeId,
    this.category,
    this.name,
    this.price,
    this.image,
    this.publicId,
    this.registeredDate,
    this.expiredDate,
    this.quantity,
    this.createdAt,
  });

  ProductModel copyWith({
    String? id,
    String? storeId,
    String? category,
    String? name,
    int? price,
    String? image,
    String? publicId,
    DateTime? registeredDate,
    DateTime? expiredDate,
    int? quantity,
    DateTime? createdAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      category: category ?? this.category,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
      publicId: publicId ?? this.publicId,
      registeredDate: registeredDate ?? this.registeredDate,
      expiredDate: expiredDate ?? this.expiredDate,
      quantity: quantity ?? this.quantity,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'store_id': storeId,
      'category': category,
      'name': name,
      'price': price,
      'image_url': image,
      'public_id': publicId,
      'registered_date': registeredDate?.toIso8601String(),
      'expired_date': expiredDate?.toIso8601String(),
      'quantity': quantity,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] != null ? map['id'] as String : null,
      storeId: map['store_id'] != null ? map['store_id'] as String : null,
      category: map['category'] != null ? map['category'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      price: map['price'] != null ? map['price'] as int : null,
      image: map['image_url'] != null ? map['image_url'] as String : null,
      publicId: map['public_id'] != null ? map['public_id'] as String : null,
      registeredDate: DateTime.parse(map['registered_date']),
      expiredDate: DateTime.parse(map['expired_date']),
      quantity: map['quantity'] != null ? map['quantity'] as int : null,
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
