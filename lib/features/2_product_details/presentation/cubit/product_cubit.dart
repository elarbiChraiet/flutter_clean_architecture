import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_product_uc.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProductUC getProductUC;

  ProductCubit({required this.getProductUC}) : super(const ProductInitialState());

  Future<void> loadProduct(int productId) async {
    emit(const ProductLoadingState());

    try {
      final result = await getProductUC.execute(productId);

      if (result != null) {
        emit(ProductLoadedState(product: result));
      } else {
        emit(const ProductEmptyState());
      }
    } catch (e) {
      emit(ProductErrorState(errorMessage: 'Error loading product: ${e.toString()}'));
    }
  }

  Future<void> refreshProduct(int productId) async {
    emit(const ProductLoadingState());

    try {
      final result = await getProductUC.execute(productId);

      if (result != null) {
        emit(ProductLoadedState(product: result));
      } else {
        emit(const ProductEmptyState());
      }
    } catch (e) {
      emit(ProductErrorState(errorMessage: 'Error refreshing product: ${e.toString()}'));
    }
  }
}
