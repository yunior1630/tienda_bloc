import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<void> addProduct(ProductModel product); // 🔥 Nueva función
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final FirebaseFirestore firestore;

  ProductRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<ProductModel>> getProducts() async {
    final querySnapshot = await firestore.collection('products').get();
    return querySnapshot.docs
        .map((doc) => ProductModel.fromJson(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> addProduct(ProductModel product) async {
    await firestore
        .collection('products')
        .add(product.toJson()); // 🔥 Subir a Firestore
  }
}
