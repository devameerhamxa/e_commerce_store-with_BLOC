import 'package:e_commerce_store_with_bloc/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:e_commerce_store_with_bloc/products/bloc/product_bloc.dart';
import 'package:e_commerce_store_with_bloc/products/bloc/product_event.dart';
import 'package:e_commerce_store_with_bloc/products/bloc/product_state.dart';
import 'package:e_commerce_store_with_bloc/products/data/models/product_model.dart';
import 'package:e_commerce_store_with_bloc/cart/bloc/cart_bloc.dart';
import 'package:e_commerce_store_with_bloc/cart/bloc/cart_state.dart';
import 'package:e_commerce_store_with_bloc/core/widgets/app_drawer.dart';
import 'package:shimmer/shimmer.dart';

class ProductListScreen extends StatefulWidget {
  final Function(bool) onThemeToggle;

  const ProductListScreen({Key? key, required this.onThemeToggle})
      : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (context.read<ProductBloc>().state is ProductInitial) {
      context.read<ProductBloc>().add(FetchProducts());
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onRefresh() {
    context.read<ProductBloc>().add(FetchProducts());
    _refreshController.refreshCompleted();
  }

  void _onSearchChanged(String query) {
    context.read<ProductBloc>().add(SearchProducts(query));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: true,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                _searchFocusNode.unfocus();
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              int itemCount = 0;
              if (state is CartLoaded) {
                itemCount = state.cartItems.values
                    .fold(0, (sum, quantity) => sum + quantity);
              }
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () {
                        _searchFocusNode.unfocus();
                        Navigator.pushNamed(context, AppRoutes.cart);
                      },
                    ),
                  ),
                  if (itemCount > 0)
                    Positioned(
                      right: 12,
                      top: 7,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$itemCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer(
          onThemeToggle:
              widget.onThemeToggle), // Pass the theme toggle callback
      body: Column(
        children: [
          // ── Search Bar ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
            ),
          ),

          // ── Category Chips ───────────────────────────────────────
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoaded) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      _buildCategoryChip(
                          context, 'All', state.selectedCategory),
                      ...state.categories.map(
                        (c) => _buildCategoryChip(
                            context, c, state.selectedCategory),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // ── Product Grid ─────────────────────────────────────────
          Expanded(
            child: BlocConsumer<ProductBloc, ProductState>(
              listenWhen: (previous, current) => current is ProductError,
              listener: (context, state) {
                if (state is ProductError && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${state.message}')),
                  );
                }
              },
              builder: (context, state) {
                if (state is ProductLoading) {
                  return _buildShimmerGrid();
                } else if (state is ProductError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else if (state is ProductLoaded) {
                  if (state.products.isEmpty) {
                    return const Center(child: Text('No products found.'));
                  }
                  return SmartRefresher(
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    header: const WaterDropHeader(),
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return ProductCard(
                          product: product,
                          onTap: () {
                            _searchFocusNode
                                .unfocus(); // Unfocus before navigating
                            Navigator.pushNamed(
                              context,
                              AppRoutes.productDetail,
                              arguments: {'productId': product.id},
                            );
                          },
                        );
                      },
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
      BuildContext context, String category, String? selectedCategory) {
    final isSelected = selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (selected) {
          context.read<ProductBloc>().add(
                FilterProductsByCategory(selected ? category : 'All'),
              );
        },
        selectedColor: Theme.of(context).colorScheme.primary,
        labelStyle: TextStyle(
          color: isSelected
              ? Colors.white
              : Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 0.75,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    color: Colors.white,
                    margin: const EdgeInsets.all(8),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: double.infinity,
                          height: 16,
                          color: Colors.white),
                      const SizedBox(height: 8),
                      Container(width: 100, height: 14, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ProductCard (assuming this is in a separate file like lib/products/ui/product_card.dart)
// No changes needed here.
class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const ProductCard({Key? key, required this.product, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: Image.network(
                    product.image,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image, size: 50);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
