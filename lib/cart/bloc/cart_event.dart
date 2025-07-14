import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class FetchUserCarts extends CartEvent {
  final int userId;

  const FetchUserCarts(this.userId);

  @override
  List<Object> get props => [userId];
}

class AddToCart extends CartEvent {
  final int productId;
  final int quantity;

  const AddToCart({required this.productId, required this.quantity});

  @override
  List<Object> get props => [productId, quantity];
}

class RemoveFromCart extends CartEvent {
  final int productId;

  const RemoveFromCart({required this.productId});

  @override
  List<Object> get props => [productId];
}

class UpdateCartItemQuantity extends CartEvent {
  final int productId;
  final int quantity;

  const UpdateCartItemQuantity(
      {required this.productId, required this.quantity});

  @override
  List<Object> get props => [productId, quantity];
}
