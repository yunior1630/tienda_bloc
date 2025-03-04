import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/usecases/agregar_producto_usecase.dart';
import '../../domain/usecases/eliminar_producto_usecase.dart';
import '../../domain/usecases/modificar_cantidad_usecase.dart';
import '../../domain/usecases/vaciar_carrito_usecase.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/entities/cart_item_entity.dart';
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
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  CartBloc({
    required this.agregarProducto,
    required this.eliminarProducto,
    required this.modificarCantidad,
    required this.vaciarCarrito,
    required this.cartRepository,
  }) : super(CartCargando()) {
    _iniciarEscuchaUsuario();
    _escucharConectividad();

    on<AgregarProductoAlCarrito>(_agregarProducto);
    on<EliminarProductoDelCarrito>(_eliminarProducto);
    on<ModificarCantidadProducto>(_modificarCantidad);
    on<VaciarCarrito>(_vaciarCarrito);
    on<ActualizarCarritoEvent>(_actualizarCarrito);
    on<ActualizarUsuario>(_actualizarUsuario);
    on<SincronizarCarrito>(_sincronizarCarrito);
  }

  // 🔹 Escucha cambios en el usuario autenticado
  void _iniciarEscuchaUsuario() {
    _authSubscription?.cancel();
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        add(ActualizarUsuario());
      } else {
        add(ActualizarCarritoEvent([]));
      }
    });
  }

  // 🔹 Escucha cambios en la conectividad
  void _escucharConectividad() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) {
      if (result.isNotEmpty && result.first != ConnectivityResult.none) {
        add(SincronizarCarrito());
      }
    });
  }

  // 🔄 Verifica si hay conexión a internet
  Future<bool> _tieneConexion() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  // 🔄 Actualiza el carrito cuando cambia el usuario
  Future<void> _actualizarUsuario(
      ActualizarUsuario event, Emitter<CartState> emit) async {
    if (await _tieneConexion()) {
      _iniciarEscuchaCarrito();
    } else {
      final prefs = await SharedPreferences.getInstance();
      final carritoJson = prefs.getString("CART_ITEMS") ?? "[]";
      final List<dynamic> carritoMap = jsonDecode(carritoJson);
      final List<CartItemEntity> carritoLocal =
          carritoMap.map((item) => CartItemEntity.fromJson(item)).toList();

      emit(CartCargado(carritoLocal));
    }
  }

  // 🔹 Escucha en tiempo real los cambios del carrito en Firestore
  void _iniciarEscuchaCarrito() {
    _cartSubscription?.cancel();
    _cartSubscription = cartRepository.escucharCarrito().listen((productos) {
      add(ActualizarCarritoEvent(productos));
    }, onError: (error) {
      add(ActualizarCarritoEvent([]));
    });
  }

  // 🔄 Actualiza el estado del carrito con los productos en Firestore
  Future<void> _actualizarCarrito(
      ActualizarCarritoEvent event, Emitter<CartState> emit) async {
    emit(CartCargado(event.productos));
  }

  // ➕ Agrega productos al carrito (online y offline)
  Future<void> _agregarProducto(
      AgregarProductoAlCarrito event, Emitter<CartState> emit) async {
    try {
      if (await _tieneConexion()) {
        for (int i = 0; i < event.cantidad; i++) {
          await agregarProducto(event.producto);
        }
      } else {
        final prefs = await SharedPreferences.getInstance();
        final carritoJson = prefs.getString("CART_ITEMS") ?? "[]";
        final List<dynamic> carritoMap = jsonDecode(carritoJson);
        final List<CartItemEntity> carritoLocal =
            carritoMap.map((item) => CartItemEntity.fromJson(item)).toList();

        carritoLocal.add(
            CartItemEntity(producto: event.producto, cantidad: event.cantidad));
        await prefs.setString("CART_ITEMS",
            jsonEncode(carritoLocal.map((e) => e.toJson()).toList()));
      }
    } catch (e) {
      emit(CartError("Error al agregar producto: ${e.toString()}"));
    }
  }

  // ❌ Elimina un producto del carrito (online y offline)
  Future<void> _eliminarProducto(
      EliminarProductoDelCarrito event, Emitter<CartState> emit) async {
    try {
      if (await _tieneConexion()) {
        await eliminarProducto(event.productoId);
      } else {
        final prefs = await SharedPreferences.getInstance();
        final carritoJson = prefs.getString("CART_ITEMS") ?? "[]";
        final List<dynamic> carritoMap = jsonDecode(carritoJson);
        final List<CartItemEntity> carritoLocal =
            carritoMap.map((item) => CartItemEntity.fromJson(item)).toList();

        carritoLocal
            .removeWhere((item) => item.producto.id == event.productoId);
        await prefs.setString("CART_ITEMS",
            jsonEncode(carritoLocal.map((e) => e.toJson()).toList()));
      }
    } catch (e) {
      emit(CartError("Error al eliminar producto: ${e.toString()}"));
    }
  }

  // 🔄 Modifica la cantidad de un producto en el carrito (online y offline)
  Future<void> _modificarCantidad(
      ModificarCantidadProducto event, Emitter<CartState> emit) async {
    try {
      if (await _tieneConexion()) {
        await modificarCantidad(event.productoId, event.nuevaCantidad);
      } else {
        final prefs = await SharedPreferences.getInstance();
        final carritoJson = prefs.getString("CART_ITEMS") ?? "[]";
        final List<dynamic> carritoMap = jsonDecode(carritoJson);
        final List<CartItemEntity> carritoLocal =
            carritoMap.map((item) => CartItemEntity.fromJson(item)).toList();

        carritoLocal.forEach((item) {
          if (item.producto.id == event.productoId) {
            item = item.copyWith(cantidad: event.nuevaCantidad);
          }
        });

        await prefs.setString("CART_ITEMS",
            jsonEncode(carritoLocal.map((e) => e.toJson()).toList()));
      }
    } catch (e) {
      emit(CartError("Error al modificar cantidad: ${e.toString()}"));
    }
  }

  // 🔄 Sincroniza el carrito local con Firestore
  Future<void> _sincronizarCarrito(
      SincronizarCarrito event, Emitter<CartState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final carritoJson = prefs.getString("CART_ITEMS");
      if (carritoJson == null) return;

      final List<dynamic> carritoMap = jsonDecode(carritoJson);
      final List<CartItemEntity> carritoLocal =
          carritoMap.map((item) => CartItemEntity.fromJson(item)).toList();

      for (var item in carritoLocal) {
        await agregarProducto(item.producto);
      }

      await prefs.remove("CART_ITEMS");
    } catch (e) {
      emit(CartError("Error al sincronizar carrito: ${e.toString()}"));
    }
  }

  Future<void> _vaciarCarrito(
      VaciarCarrito event, Emitter<CartState> emit) async {
    try {
      await vaciarCarrito();
    } catch (e) {
      emit(CartError("Error al vaciar el carrito: ${e.toString()}"));
    }
  }

  @override
  Future<void> close() {
    _cartSubscription?.cancel();
    _authSubscription?.cancel();
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
