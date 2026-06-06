import 'cart_model.dart';

class OrderModel {
  String? id;
  String? name;
  List<CartModel>? products;
  int? total;
  int? change;
  int? payment;
  DateTime? createdAt;
  OrderModel({
    this.id,
    this.name,
    this.products,
    this.total,
    this.change,
    this.payment,
    this.createdAt,
  });

  OrderModel copyWith({
    String? id,
    String? name,
    List<CartModel>? products,
    int? total,
    int? change,
    int? payment,
    DateTime? createdAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      name: name ?? this.name,
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
      'products': products?.map((x) => x.toMap()).toList(),
      'total': total,
      'change': change,
      'payment': payment,
      'created_at': createdAt,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
        id: map['id'] != null ? map['id'] as String : null,
        name: map['name'] != null ? map['name'] as String : null,
        products: map['products'] != null
            ? List<CartModel>.from(
                (map['products'] as List).map<CartModel?>(
                  (x) => CartModel.fromMap(x as Map<String, dynamic>),
                ),
              )
            : null,
        total: map['total'] != null ? map['total'] as int : null,
        change: map['change'] != null ? map['change'] as int : null,
        payment: map['payment'] != null ? map['payment'] as int : null,
        createdAt: DateTime.tryParse(map['created_at']));
  }
}
