import '../repositories/cart_repository.dart';

class EliminarProductoUseCase {
  final CartRepository repository;

  EliminarProductoUseCase(this.repository);

  Future<void> call(String productoId) async {
    return repository.eliminarProducto(productoId);
  }
}
