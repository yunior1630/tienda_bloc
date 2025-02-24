import 'package:equatable/equatable.dart';
import 'package:tienda_bloc/features/product/domain/entities/product_entity.dart';
import '../../domain/entities/cart_item_entity.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AgregarProductoAlCarrito extends CartEvent {
  final ProductEntity producto;

  AgregarProductoAlCarrito(this.producto);

  @override
  List<Object?> get props => [producto];
}

class EliminarProductoDelCarrito extends CartEvent {
  final String productoId;

  EliminarProductoDelCarrito(this.productoId);

  @override
  List<Object?> get props => [productoId];
}

class ModificarCantidadProducto extends CartEvent {
  final String productoId;
  final int nuevaCantidad;

  ModificarCantidadProducto(this.productoId, this.nuevaCantidad);

  @override
  List<Object?> get props => [productoId, nuevaCantidad];
}

// Evento para vaciar el carrito (faltaba definirlo)
class VaciarCarrito extends CartEvent {}

// Evento para recibir actualizaciones en tiempo real
class ActualizarCarritoEvent extends CartEvent {
  final List<CartItemEntity> productos;

  ActualizarCarritoEvent(this.productos);

  @override
  List<Object?> get props => [productos];
}
