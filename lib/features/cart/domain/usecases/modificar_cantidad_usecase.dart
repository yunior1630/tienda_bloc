import '../repositories/cart_repository.dart';

class ModificarCantidadUseCase {
  final CartRepository repository;

  ModificarCantidadUseCase(this.repository);

  Future<void> call(String productoId, int nuevaCantidad) async {
    return repository.modificarCantidad(productoId, nuevaCantidad);
  }
}
