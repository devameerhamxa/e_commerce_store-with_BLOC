import 'package:equatable/equatable.dart';

class CartModel extends Equatable {
  final int id;
  final int userId;
  final String date;
  final List<ProductInCart> products;

  const CartModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.products,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      date: json['date'] as String,
      products: (json['products'] as List)
          .map((e) => ProductInCart.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date,
      'products': products.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [id, userId, date, products];
}

class ProductInCart extends Equatable {
  final int productId;
  final int quantity;

  const ProductInCart({required this.productId, required this.quantity});

  factory ProductInCart.fromJson(Map<String, dynamic> json) {
    return ProductInCart(
      productId: json['productId'] as int,
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
    };
  }

  @override
  List<Object?> get props => [productId, quantity];
}
