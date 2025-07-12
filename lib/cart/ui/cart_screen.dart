// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_store_with_bloc/cart/bloc/cart_bloc.dart';
import 'package:e_commerce_store_with_bloc/cart/bloc/cart_event.dart';
import 'package:e_commerce_store_with_bloc/cart/bloc/cart_state.dart';
import 'package:e_commerce_store_with_bloc/auth/bloc/auth_bloc.dart';
import 'package:e_commerce_store_with_bloc/auth/bloc/auth_state.dart';
import 'package:e_commerce_store_with_bloc/products/data/models/product_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    final authState = BlocProvider.of<AuthBloc>(context).state;
    if (authState is AuthAuthenticated) {
      BlocProvider.of<CartBloc>(context).add(FetchUserCarts(authState.userId));
    } else {
      // Handle unauthenticated state, maybe redirect to login or show a message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to view your cart.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        centerTitle: true,
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartLoaded) {
            if (state.cartItems.isEmpty) {
              return const Center(child: Text('Your cart is empty.'));
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: state.cartItems.length,
                    itemBuilder: (context, index) {
                      final productEntry =
                          state.cartItems.entries.elementAt(index);
                      final product = productEntry.key;
                      final quantity = productEntry.value;
                      return CartItemCard(product: product, quantity: quantity);
                    },
                  ),
                ),
                _buildCartSummary(context, state.cartTotal),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCartSummary(BuildContext context, double total) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cart Total:',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Proceeding to Checkout (Not implemented)')),
              );
              // Implement checkout logic here
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Proceed to Checkout',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class CartItemCard extends StatelessWidget {
  final ProductModel product;
  final int quantity;

  const CartItemCard({
    Key? key,
    required this.product,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 50);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          if (quantity > 1) {
                            BlocProvider.of<CartBloc>(context).add(
                              UpdateCartItemQuantity(
                                  productId: product.id,
                                  quantity: quantity - 1),
                            );
                          } else {
                            BlocProvider.of<CartBloc>(context).add(
                              RemoveFromCart(productId: product.id),
                            );
                          }
                        },
                      ),
                      Text('$quantity',
                          style: Theme.of(context).textTheme.titleMedium),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          BlocProvider.of<CartBloc>(context).add(
                            UpdateCartItemQuantity(
                                productId: product.id, quantity: quantity + 1),
                          );
                        },
                      ),
                      const Spacer(),
                      IconButton(
                        icon:
                            const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () {
                          BlocProvider.of<CartBloc>(context).add(
                            RemoveFromCart(productId: product.id),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    '${product.title} removed from cart.')),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
