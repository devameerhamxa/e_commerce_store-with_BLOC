import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class FetchProducts extends ProductEvent {}

class FilterProductsByCategory extends ProductEvent {
  final String category;

  const FilterProductsByCategory(this.category);

  @override
  List<Object> get props => [category];
}

class SearchProducts extends ProductEvent {
  final String query;

  const SearchProducts(this.query);

  @override
  List<Object> get props => [query];
}

class FetchProductDetails extends ProductEvent {
  final int productId;

  const FetchProductDetails(this.productId);

  @override
  List<Object> get props => [productId];
}

class FetchProductCategories extends ProductEvent {}
