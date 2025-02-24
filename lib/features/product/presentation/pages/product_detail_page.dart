import 'package:flutter/material.dart';
import 'package:tienda_bloc/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:tienda_bloc/features/cart/presentation/bloc/cart_event.dart';
import '../../domain/entities/product_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductEntity product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles del Producto"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset("assets/imagen_no_disponible.png");
                },
              ),
            ),
            const SizedBox(height: 10),
            // Información del producto
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.orange, size: 16),
                            Text(
                              product.rating.toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 5),
                            const Text("95 opiniones",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.blue),
                        onPressed: () {
                          // Compartir producto
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "\$${product.price}",
                        style:
                            const TextStyle(fontSize: 22, color: Colors.blue),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "\$${(product.price * 1.2).toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "${product.discount} de descuento",
                        style:
                            const TextStyle(color: Colors.green, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Descripción",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(product.description),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Sección de detalles del producto
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Detalles del Producto",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _filaDetalle("Marca", "ABC Brand"),
                  _filaDetalle("Tipo", "Móviles y accesorios"),
                  _filaDetalle("Peso", "382 gramos"),
                  _filaDetalle("Sistema Operativo", "Android 11"),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _botonAgregarCarrito(context),
    );
  }

  // Widget para mostrar detalles en filas
  Widget _filaDetalle(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titulo,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            valor,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Botón inferior para agregar al carrito
  Widget _botonAgregarCarrito(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () {
          BlocProvider.of<CartBloc>(context)
              .add(AgregarProductoAlCarrito(product));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: const Text(
          "Añadir al Carrito",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
