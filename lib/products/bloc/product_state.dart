import 'package:equatable/equatable.dart';
import 'package:e_commerce_store_with_bloc/products/data/models/product_model.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductModel> products;
  final List<String> categories;
  final String? selectedCategory;
  final String searchQuery;

  const ProductLoaded({
    required this.products,
    this.categories = const [],
    this.selectedCategory,
    this.searchQuery = '',
  });

  ProductLoaded copyWith({
    List<ProductModel>? products,
    List<String>? categories,
    String? selectedCategory,
    String? searchQuery,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props =>
      [products, categories, selectedCategory ?? '', searchQuery];
}

class ProductError extends ProductState {
  final String message;

  const ProductError({required this.message});

  @override
  List<Object> get props => [message];
}
