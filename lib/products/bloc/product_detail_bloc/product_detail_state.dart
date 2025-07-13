import 'package:e_commerce_store_with_bloc/products/data/models/product_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProductDetailState extends Equatable {
  const ProductDetailState();
  @override
  List<Object> get props => [];
}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailLoaded extends ProductDetailState {
  final ProductModel product;
  const ProductDetailLoaded(this.product);
  @override
  List<Object> get props => [product];
}

class ProductDetailError extends ProductDetailState {
  final String message;
  const ProductDetailError(this.message);
  @override
  List<Object> get props => [message];
}
