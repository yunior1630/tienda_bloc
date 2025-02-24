import '../repositories/cart_repository.dart';

class VaciarCarritoUseCase {
  final CartRepository repository;

  VaciarCarritoUseCase(this.repository);

  Future<void> call() async {
    return repository.vaciarCarrito();
  }
}
