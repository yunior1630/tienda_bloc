import 'package:tienda_bloc/features/product/domain/entities/product_entity.dart';

import '../entities/cart_item_entity.dart';

abstract class CartRepository {
  Future<void> agregarProducto(ProductEntity producto);
  Future<void> eliminarProducto(String productoId);
  Future<void> modificarCantidad(String productoId, int nuevaCantidad);
  Stream<List<CartItemEntity>> escucharCarrito();
  Future<void> vaciarCarrito();
}
