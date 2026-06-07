import 'package:cashier/features/order/order/models/cart_model.dart';

class OrderModel {
  String? id;
  String? name;
  String? storeId;
  List<CartModel>? products;
  int? total;
  int? change;
  int? payment;
  DateTime? createdAt;
  OrderModel({
    this.id,
    this.name,
    this.storeId,
    this.products,
    this.total,
    this.change,
    this.payment,
    this.createdAt,
  });

  OrderModel copyWith({
    String? id,
    String? name,
    String? storeId,
    List<CartModel>? products,
    int? total,
    int? change,
    int? payment,
    DateTime? createdAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      name: name ?? this.name,
      storeId: storeId ?? this.storeId,
      products: products ?? this.products,
      total: total ?? this.total,
      change: change ?? this.change,
      payment: payment ?? this.payment,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'store_id': storeId,
      'products': products?.map((x) => x.toMap()).toList(),
      'total': total,
      'change': change,
      'payment': payment,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
        id: map['id'] != null ? map['id'] as String : null,
        name: map['name'] != null ? map['name'] as String : null,
        storeId: map['store_id'] != null ? map['store_id'] as String : null,
        products: map['products'] != null
            ? List<CartModel>.from(
                (map['products'] as List).map(
                  (e) => CartModel.fromMap(e),
                ),
              )
            : null,
        total: map['total'] != null ? map['total'] as int : null,
        change: map['change'] != null ? map['change'] as int : null,
        payment: map['payment'] != null ? map['payment'] as int : null,
        createdAt: DateTime.tryParse(map['created_at']));
  }
}
