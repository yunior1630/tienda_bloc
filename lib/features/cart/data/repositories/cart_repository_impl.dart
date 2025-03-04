import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../../product/domain/entities/product_entity.dart';

class CartRepositoryImpl implements CartRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  CartRepositoryImpl({required this.firestore, required this.firebaseAuth});

  Future<String> _getUserId() async {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw Exception("Usuario no autenticado");
    }
    return user.uid;
  }

  @override
  Future<void> agregarProducto(ProductEntity producto) async {
    final userId = await _getUserId();

    final cartRef =
        firestore.collection("carritos").doc(userId).collection("items");
    final doc = await cartRef.doc(producto.id).get();

    if (doc.exists) {
      await cartRef.doc(producto.id).update({
        "cantidad": (doc["cantidad"] as int) + 1,
      });
    } else {
      await cartRef.doc(producto.id).set({
        "nombre": producto.name,
        "imagenUrl": producto.imageUrl,
        "precio": producto.price,
        "descuento": producto.discount,
        "rating": producto.rating,
        "descripcion": producto.description,
        "cantidad": 1,
      });
    }
  }

  @override
  Future<void> eliminarProducto(String productoId) async {
    final userId = await _getUserId();
    await firestore
        .collection("carritos")
        .doc(userId)
        .collection("items")
        .doc(productoId)
        .delete();
  }

  @override
  Future<void> modificarCantidad(String productoId, int nuevaCantidad) async {
    final userId = await _getUserId();
    if (nuevaCantidad > 0) {
      await firestore
          .collection("carritos")
          .doc(userId)
          .collection("items")
          .doc(productoId)
          .update({"cantidad": nuevaCantidad});
    } else {
      await eliminarProducto(productoId);
    }
  }

  @override
  Stream<List<CartItemEntity>> escucharCarrito() async* {
    final userId = await _getUserId();
    yield* firestore
        .collection("carritos")
        .doc(userId)
        .collection("items")
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return CartItemEntity(
          producto: ProductEntity(
            id: doc.id,
            name: doc["nombre"],
            imageUrl: doc["imagenUrl"],
            price: (doc["precio"] as num).toDouble(),
            discount: (doc["descuento"] as num).toDouble(),
            rating: (doc["rating"] as num).toDouble(),
            description: doc["descripcion"],
          ),
          cantidad: doc["cantidad"],
        );
      }).toList();
    });
  }

  @override
  Future<void> vaciarCarrito() async {
    final userId = await _getUserId();
    final cartRef =
        firestore.collection("carritos").doc(userId).collection("items");
    final docs = await cartRef.get();
    for (var doc in docs.docs) {
      await doc.reference.delete();
    }
  }
}
