import 'package:flutter/material.dart';
import 'package:e_commerce_store_with_bloc/products/ui/product_list_screen.dart';

class ProductListScreenWithThemeToggle extends StatelessWidget {
  final Function(bool) onThemeToggle;

  const ProductListScreenWithThemeToggle({
    Key? key,
    required this.onThemeToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const ProductListScreen(),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                final currentBrightness = Theme.of(context).brightness;
                onThemeToggle(currentBrightness == Brightness.light);
              },
              child: Icon(
                Theme.of(context).brightness == Brightness.light
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
