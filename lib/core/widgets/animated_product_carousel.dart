// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:e_commerce_store_with_bloc/core/routes/app_routes.dart';
import 'package:e_commerce_store_with_bloc/products/ui/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_store_with_bloc/products/data/models/product_model.dart';

class AnimatedProductCarousel extends StatefulWidget {
  final List<ProductModel> products;

  const AnimatedProductCarousel({Key? key, required this.products})
      : super(key: key);

  @override
  State<AnimatedProductCarousel> createState() =>
      _AnimatedProductCarouselState();
}

class _AnimatedProductCarouselState extends State<AnimatedProductCarousel> {
  late PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Initialize PageController for a nearly full-width view with slight spacing
    _pageController =
        PageController(viewportFraction: 0.95); // Increased for wider products
    _startAutoScroll();
  }

  // Starts or restarts the automatic scrolling timer
  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients && widget.products.isNotEmpty) {
        _currentPage++;
        if (_currentPage >= widget.products.length) {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.products.length,
            onPageChanged: (index) {
              setState(() {
                // Update state to rebuild indicators
                _currentPage = index;
              });
              _startAutoScroll(); // Restart timer on manual scroll
            },
            itemBuilder: (context, index) {
              final product = widget.products[index];
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  // Calculate scale effect based on page position
                  if (_pageController.position.haveDimensions) {
                    value = _pageController.page! - index;
                    // Clamp value to create a subtle scale effect for nearby pages
                    value = (1 - (value.abs() * 0.1))
                        .clamp(0.9, 1.0); // Reduced scale effect
                  }
                  return Center(
                    child: SizedBox(
                      height: Curves.easeOut.transform(value) * 200,
                      child: child,
                    ),
                  );
                },
                child: ProductCard(
                  product: product,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.productDetail,
                      arguments: {'productId': product.id},
                    );
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 6), 
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.products.length, (index) {
            return AnimatedContainer(
              duration: const Duration(
                  milliseconds: 300), 
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              height: 8.0,
              width: _currentPage == index ? 24.0 : 8.0,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? Theme.of(context).colorScheme.primary 
                    : Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(4.0),
              ),
            );
          }),
        ),
      ],
    );
  }
}
