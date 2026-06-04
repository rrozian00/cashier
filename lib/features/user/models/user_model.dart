class UserModel {
  final String? id;
  final String? storeId;
  final String? email;
  final String? name;
  final String? address;
  final String? salary;
  final String? role;
  final String? phoneNumber;
  final String? photo;
  final DateTime? createdAt;

  const UserModel({
    this.id,
    this.storeId,
    this.email,
    this.name,
    this.address,
    this.salary,
    this.role,
    this.phoneNumber,
    this.photo,
    this.createdAt,
  });

  UserModel copyWith({
    String? storeId,
    String? email,
    String? name,
    String? address,
    String? salary,
    String? role,
    String? phoneNumber,
    String? photo,
    DateTime? createdAt,
  }) {
    return UserModel(
      storeId: storeId ?? this.storeId,
      email: email ?? this.email,
      name: name ?? this.name,
      address: address ?? this.address,
      salary: salary ?? this.salary,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photo: photo ?? this.photo,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'store_id': storeId,
      'email': email,
      'name': name,
      'address': address,
      'salary': salary,
      'role': role,
      'phone_number': phoneNumber,
      'photo_url': photo,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] != null ? map['id'] as String : null,
      storeId: map['store_id'] != null ? map['store_id'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      salary: map['salary'] != null ? map['salary'] as String : null,
      role: map['role'] != null ? map['role'] as String : null,
      phoneNumber:
          map['phone_number'] != null ? map['phone_number'] as String : null,
      photo: map['photo_url'] != null ? map['photo_url'] as String : null,
      createdAt:
          map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }
}
