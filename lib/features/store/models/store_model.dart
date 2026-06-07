class StoreModel {
  String? id;
  String? name;
  String? ownerId;
  String? address;
  String? phone;
  String? logoUrl;
  bool? isActive;
  List<String>? employees;
  DateTime? createdAt;

  StoreModel({
    this.id,
    this.name,
    this.ownerId,
    this.address,
    this.phone,
    this.logoUrl,
    this.isActive,
    this.employees,
    this.createdAt,
  });

  StoreModel copyWith({
    String? id,
    String? name,
    String? ownerId,
    String? address,
    String? phone,
    String? logoUrl,
    bool? isActive,
    List<String>? employees,
    DateTime? createdAt,
  }) {
    return StoreModel(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      logoUrl: logoUrl ?? this.logoUrl,
      isActive: isActive ?? this.isActive,
      employees: employees ?? this.employees,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'owner_id': ownerId,
      'address': address,
      'phone': phone,
      'logo_url': logoUrl,
      'is_active': isActive,
      'employees': employees,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory StoreModel.fromMap(Map<String, dynamic> map) {
    return StoreModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      ownerId: map['owner_id'] != null ? map['owner_id'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      logoUrl: map['logo_url'] != null ? map['logo_url'] as String : null,
      isActive: map['is_active'] != null ? map['is_active'] as bool : null,
      employees:
          map['employees'] != null ? List<String>.from(map['employees']) : null,
      createdAt: DateTime.tryParse(map['created_at']) as DateTime,
    );
  }
}
