import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';
import '../widgets/product_detail_view.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().loadProduct(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ProductCubit>().refreshProduct(widget.productId);
            },
          ),
        ],
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder:
            (context, state) => switch (state) {
              ProductInitialState() => const Center(child: Text('Initializing...')),
              ProductLoadingState() => const Center(child: CircularProgressIndicator()),
              ProductErrorState(errorMessage: final message) => Center(child: Text('Error: $message')),
              ProductEmptyState() => const Center(child: Text('No product found!')),
              ProductLoadedState(product: final product) => ProductDetailView(product: product),
            },
      ),
    );
  }
}
