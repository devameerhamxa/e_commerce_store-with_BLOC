import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_store_with_bloc/cart/bloc/cart_event.dart';
import 'package:e_commerce_store_with_bloc/cart/bloc/cart_state.dart';
import 'package:e_commerce_store_with_bloc/cart/data/repositories/cart_repository.dart';
import 'package:e_commerce_store_with_bloc/products/data/models/product_model.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;

  CartBloc({required this.cartRepository}) : super(CartInitial()) {
    on<FetchUserCarts>(_onFetchUserCarts);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateCartItemQuantity>(_onUpdateCartItemQuantity);
  }

  Future<void> _onFetchUserCarts(
    FetchUserCarts event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    try {
      final apiCarts = await cartRepository.getUserCarts(event.userId);
      final Map<int, int> combinedCartProductIds = {};

      if (apiCarts.isNotEmpty) {
        for (var item in apiCarts.first.products) {
          combinedCartProductIds[item.productId] =
              (combinedCartProductIds[item.productId] ?? 0) + item.quantity;
        }
      }

      cartRepository.getLocalCartItems().forEach((productId, quantity) {
        combinedCartProductIds[productId] =
            (combinedCartProductIds[productId] ?? 0) + quantity;
      });

      final Map<ProductModel, int> detailedCart = {};
      double total = 0.0;

      for (final entry in combinedCartProductIds.entries) {
        try {
          final product = await cartRepository.productRepository
              .getProductDetails(entry.key);
          detailedCart[product] = entry.value;
          total += product.price * entry.value;
        } catch (e) {
          print(
              'Error fetching product details for cart item ${entry.key}: $e');
        }
      }

      emit(CartLoaded(cartItems: detailedCart, cartTotal: total));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onAddToCart(
    AddToCart event,
    Emitter<CartState> emit,
  ) async {
    cartRepository.addLocalCartItem(event.productId, event.quantity);
    // Re-fetch cart to update UI
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final Map<ProductModel, int> updatedCartItems =
          Map.from(currentState.cartItems);
      try {
        final product = await cartRepository.productRepository
            .getProductDetails(event.productId);
        updatedCartItems.update(product, (value) => value + event.quantity,
            ifAbsent: () => event.quantity);
        double newTotal = updatedCartItems.entries
            .fold(0.0, (sum, entry) => sum + (entry.key.price * entry.value));
        emit(currentState.copyWith(
            cartItems: updatedCartItems, cartTotal: newTotal));
      } catch (e) {
        print('Error adding to cart locally: $e');
      }
    } else {}
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    cartRepository.removeLocalCartItem(event.productId);
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final Map<ProductModel, int> updatedCartItems =
          Map.from(currentState.cartItems);
      ProductModel? productToRemove;
      for (var entry in updatedCartItems.entries) {
        if (entry.key.id == event.productId) {
          productToRemove = entry.key;
          break;
        }
      }
      if (productToRemove != null) {
        updatedCartItems.remove(productToRemove);
      }
      double newTotal = updatedCartItems.entries
          .fold(0.0, (sum, entry) => sum + (entry.key.price * entry.value));
      emit(currentState.copyWith(
          cartItems: updatedCartItems, cartTotal: newTotal));
    }
  }

  Future<void> _onUpdateCartItemQuantity(
    UpdateCartItemQuantity event,
    Emitter<CartState> emit,
  ) async {
    if (event.quantity <= 0) {
      add(RemoveFromCart(productId: event.productId));
      return;
    }

    cartRepository.addLocalCartItem(
        event.productId,
        event.quantity -
            (cartRepository.getLocalCartItems()[event.productId] ?? 0));

    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final Map<ProductModel, int> updatedCartItems =
          Map.from(currentState.cartItems);
      ProductModel? productToUpdate;
      for (var entry in updatedCartItems.entries) {
        if (entry.key.id == event.productId) {
          productToUpdate = entry.key;
          break;
        }
      }
      if (productToUpdate != null) {
        updatedCartItems[productToUpdate] = event.quantity;
      }
      double newTotal = updatedCartItems.entries
          .fold(0.0, (sum, entry) => sum + (entry.key.price * entry.value));
      emit(currentState.copyWith(
          cartItems: updatedCartItems, cartTotal: newTotal));
    }
  }
}
