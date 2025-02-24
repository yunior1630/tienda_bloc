import '../repositories/cart_repository.dart';
import '../entities/cart_item_entity.dart';

class ObtenerCarritoUseCase {
  final CartRepository repository;

  ObtenerCarritoUseCase(this.repository);

  Stream<List<CartItemEntity>> call() {
    return repository.escucharCarrito();
  }
}
