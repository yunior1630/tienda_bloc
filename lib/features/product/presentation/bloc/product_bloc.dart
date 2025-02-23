import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda_bloc/features/product/domain/usecases/get_products_usecase.dart';
import 'package:tienda_bloc/features/product/presentation/bloc/product_event.dart';
import 'package:tienda_bloc/features/product/presentation/bloc/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase getProducts;

  ProductBloc({required this.getProducts}) : super(ProductInitial()) {
    on<LoadProductsEvent>(_onLoadProducts);
  }

  Future<void> _onLoadProducts(
      LoadProductsEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final products = await getProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError("Error al cargar productos"));
    }
  }
}
