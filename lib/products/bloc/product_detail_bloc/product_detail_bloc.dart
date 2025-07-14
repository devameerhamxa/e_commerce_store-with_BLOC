import 'package:e_commerce_store_with_bloc/products/bloc/product_detail_bloc/product_detail_event.dart';
import 'package:e_commerce_store_with_bloc/products/bloc/product_detail_bloc/product_detail_state.dart';
import 'package:e_commerce_store_with_bloc/products/data/repositories/product_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final ProductRepository productRepository;

  ProductDetailBloc({required this.productRepository})
      : super(ProductDetailInitial()) {
    on<FetchProductDetail>(_onFetchProductDetail);
  }

  Future<void> _onFetchProductDetail(
    FetchProductDetail event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(ProductDetailLoading());
    try {
      final product =
          await productRepository.getProductDetails(event.productId);
      emit(ProductDetailLoaded(product));
    } catch (e) {
      emit(ProductDetailError(e.toString()));
    }
  }
}
