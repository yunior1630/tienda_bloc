import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
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
  StreamSubscription? _cartSubscription;
  StreamSubscription? _authSubscription;

  CartBloc({
    required this.agregarProducto,
    required this.eliminarProducto,
    required this.modificarCantidad,
    required this.vaciarCarrito,
    required this.cartRepository,
  }) : super(CartCargando()) {
    _iniciarEscuchaUsuario();

    on<AgregarProductoAlCarrito>(_agregarProducto);
    on<EliminarProductoDelCarrito>(_eliminarProducto);
    on<ModificarCantidadProducto>(_modificarCantidad);
    on<VaciarCarrito>(_vaciarCarrito);
    on<ActualizarCarritoEvent>(_actualizarCarrito);
    on<ActualizarUsuario>(_actualizarUsuario);
  }

  // 🔹 Escucha cambios en el usuario autenticado
  void _iniciarEscuchaUsuario() {
    _authSubscription?.cancel(); // Evita múltiples suscripciones

    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        add(ActualizarUsuario()); // 🔥 Dispara actualización del carrito
      } else {
        add(ActualizarCarritoEvent(const []));
      }
    });
  }

  // 🔄 Actualiza el carrito cuando cambia el usuario
  Future<void> _actualizarUsuario(
      ActualizarUsuario event, Emitter<CartState> emit) async {
    _iniciarEscuchaCarrito(); // Reiniciar la escucha del carrito con el nuevo usuario
  }

  // 🔹 Escucha en tiempo real los cambios del carrito en Firestore
  void _iniciarEscuchaCarrito() {
    _cartSubscription?.cancel(); // Evita múltiples suscripciones

    _cartSubscription = cartRepository.escucharCarrito().listen((productos) {
      add(ActualizarCarritoEvent(productos));
    }, onError: (error) {
      add(ActualizarCarritoEvent(const [])); // Evita que se quede cargando
    });
  }

  // 🔄 Actualiza el estado del carrito con los productos en Firestore
  Future<void> _actualizarCarrito(
      ActualizarCarritoEvent event, Emitter<CartState> emit) async {
    emit(CartCargado(event.productos));
  }

  // ➕ Agrega productos al carrito
  Future<void> _agregarProducto(
      AgregarProductoAlCarrito event, Emitter<CartState> emit) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(CartError("Usuario no autenticado"));
        return;
      }

      for (int i = 0; i < event.cantidad; i++) {
        await agregarProducto(event.producto);
      }
    } catch (e) {
      emit(CartError("Error al agregar producto: ${e.toString()}"));
    }
  }

  // ❌ Elimina un producto del carrito
  Future<void> _eliminarProducto(
      EliminarProductoDelCarrito event, Emitter<CartState> emit) async {
    try {
      await eliminarProducto(event.productoId);
    } catch (e) {
      emit(CartError("Error al eliminar producto: ${e.toString()}"));
    }
  }

  // 🔄 Modifica la cantidad de un producto en el carrito
  Future<void> _modificarCantidad(
      ModificarCantidadProducto event, Emitter<CartState> emit) async {
    try {
      await modificarCantidad(event.productoId, event.nuevaCantidad);
    } catch (e) {
      emit(CartError("Error al modificar cantidad: ${e.toString()}"));
    }
  }

  // 🗑️ Vacía todo el carrito
  Future<void> _vaciarCarrito(
      VaciarCarrito event, Emitter<CartState> emit) async {
    try {
      await vaciarCarrito();
    } catch (e) {
      emit(CartError("Error al vaciar el carrito: ${e.toString()}"));
    }
  }

  // 🛑 Libera la suscripción cuando se destruye el BLoC
  @override
  Future<void> close() {
    _cartSubscription?.cancel();
    _authSubscription?.cancel();
    return super.close();
  }
}
