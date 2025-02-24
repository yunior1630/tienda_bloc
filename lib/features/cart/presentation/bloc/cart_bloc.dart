import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/agregar_producto_usecase.dart';
import '../../domain/usecases/eliminar_producto_usecase.dart';
import '../../domain/usecases/modificar_cantidad_usecase.dart';
import '../../domain/usecases/vaciar_carrito_usecase.dart';
import '../../domain/repositories/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final AgregarProductoUseCase agregarProducto;
  final EliminarProductoUseCase eliminarProducto;
  final ModificarCantidadUseCase modificarCantidad;
  final VaciarCarritoUseCase vaciarCarrito;
  final CartRepository cartRepository;

  CartBloc({
    required this.agregarProducto,
    required this.eliminarProducto,
    required this.modificarCantidad,
    required this.vaciarCarrito,
    required this.cartRepository,
  }) : super(CartCargando()) {
    _iniciarEscuchaCarrito();

    on<AgregarProductoAlCarrito>(_agregarProducto);
    on<EliminarProductoDelCarrito>(_eliminarProducto);
    on<ModificarCantidadProducto>(_modificarCantidad);
    on<VaciarCarrito>(_vaciarCarrito);
    on<ActualizarCarritoEvent>(
        _actualizarCarrito); // <-- Agregar este manejador
  }

  void _iniciarEscuchaCarrito() {
    cartRepository.escucharCarrito().listen((productos) {
      add(ActualizarCarritoEvent(
          productos)); // <-- Emitir evento para actualizar el estado
    });
  }

  Future<void> _actualizarCarrito(
      ActualizarCarritoEvent event, Emitter<CartState> emit) async {
    emit(CartCargado(
        event.productos)); // <-- Actualizar el estado con los productos
  }

  Future<void> _agregarProducto(
      AgregarProductoAlCarrito event, Emitter<CartState> emit) async {
    await agregarProducto(event.producto);
  }

  Future<void> _eliminarProducto(
      EliminarProductoDelCarrito event, Emitter<CartState> emit) async {
    await eliminarProducto(event.productoId);
  }

  Future<void> _modificarCantidad(
      ModificarCantidadProducto event, Emitter<CartState> emit) async {
    await modificarCantidad(event.productoId, event.nuevaCantidad);
  }

  Future<void> _vaciarCarrito(
      VaciarCarrito event, Emitter<CartState> emit) async {
    await vaciarCarrito();
  }
}
