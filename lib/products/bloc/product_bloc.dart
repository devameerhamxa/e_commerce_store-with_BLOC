import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_store_with_bloc/products/bloc/product_event.dart';
import 'package:e_commerce_store_with_bloc/products/bloc/product_state.dart';
import 'package:e_commerce_store_with_bloc/products/data/models/product_model.dart';
import 'package:e_commerce_store_with_bloc/products/data/repositories/product_repository.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;
  List<ProductModel> _allProducts = [];
  List<String> _allCategories = [];

  ProductBloc({required this.productRepository}) : super(ProductInitial()) {
    on<FetchProducts>(_onFetchProducts);
    on<FilterProductsByCategory>(_onFilterProductsByCategory);
    on<SearchProducts>(_onSearchProducts);
    // REMOVED: on<FetchProductDetails> - This handler now belongs to ProductDetailBloc.
    on<FetchProductCategories>(_onFetchProductCategories);
    on<ClearSearchAndFilters>(
        _onClearSearchAndFilters); // Handler for the new event
  }

  Future<void> _onFetchProducts(
    FetchProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      _allProducts = await productRepository.getProducts();
      _allCategories = await productRepository.getCategories();
      emit(ProductLoaded(products: _allProducts, categories: _allCategories));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> _onFilterProductsByCategory(
    FilterProductsByCategory event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      emit(ProductLoading()); // Show loading while filtering
      try {
        List<ProductModel> filteredProducts;
        if (event.category == 'All') {
          filteredProducts = _allProducts;
        } else {
          filteredProducts =
              await productRepository.getProductsByCategory(event.category);
        }
        emit(currentState.copyWith(
          products: filteredProducts,
          selectedCategory: event.category,
          searchQuery: '', // Clear search when filtering by category
        ));
      } catch (e) {
        emit(ProductError(message: e.toString()));
      }
    }
  }

  void _onSearchProducts(
    SearchProducts event,
    Emitter<ProductState> emit,
  ) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final filteredProducts = _allProducts.where((product) {
        return product.title
                .toLowerCase()
                .contains(event.query.toLowerCase()) ||
            product.description
                .toLowerCase()
                .contains(event.query.toLowerCase());
      }).toList();
      emit(currentState.copyWith(
        products: filteredProducts,
        searchQuery: event.query,
        selectedCategory: null, // Clear category selection when searching
      ));
    }
  }

  // REMOVED: _onFetchProductDetails handler - This now belongs to ProductDetailBloc.

  Future<void> _onFetchProductCategories(
    FetchProductCategories event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      try {
        _allCategories = await productRepository.getCategories();
        emit(currentState.copyWith(categories: _allCategories));
      } catch (e) {
        // If categories fail to load, don't block product display
        print('Failed to load categories: $e');
      }
    }
  }

  // New handler to clear search and filters, if you added the event
  void _onClearSearchAndFilters(
    ClearSearchAndFilters event,
    Emitter<ProductState> emit,
  ) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      emit(currentState.copyWith(
        products: _allProducts, // Reset to all original products
        searchQuery: '',
        selectedCategory: null,
      ));
    }
  }
}
