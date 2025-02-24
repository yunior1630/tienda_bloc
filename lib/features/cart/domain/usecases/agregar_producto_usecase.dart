import 'package:tienda_bloc/features/product/domain/entities/product_entity.dart';

import '../repositories/cart_repository.dart';

class AgregarProductoUseCase {
  final CartRepository repository;

  AgregarProductoUseCase(this.repository);

  Future<void> call(ProductEntity producto) async {
    return repository.agregarProducto(producto);
  }
}
