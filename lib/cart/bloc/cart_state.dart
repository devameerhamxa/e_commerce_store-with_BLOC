import 'package:equatable/equatable.dart';
import 'package:e_commerce_store_with_bloc/products/data/models/product_model.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  // Using a Map<ProductModel, int> to store detailed product info and quantity
  final Map<ProductModel, int> cartItems;
  final double cartTotal;

  const CartLoaded({required this.cartItems, required this.cartTotal});

  CartLoaded copyWith({
    Map<ProductModel, int>? cartItems,
    double? cartTotal,
  }) {
    return CartLoaded(
      cartItems: cartItems ?? this.cartItems,
      cartTotal: cartTotal ?? this.cartTotal,
    );
  }

  @override
  List<Object> get props => [cartItems, cartTotal];
}

class CartError extends CartState {
  final String message;

  const CartError({required this.message});

  @override
  List<Object> get props => [message];
}
