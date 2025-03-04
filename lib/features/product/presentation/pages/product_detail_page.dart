import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda_bloc/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:tienda_bloc/features/cart/presentation/bloc/cart_event.dart';
import '../../domain/entities/product_entity.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductEntity product;

  const ProductDetailPage({super.key, required this.product});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int cantidad = 1; // Contador de cantidad de productos

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Detalles del Producto"),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.blue),
            onPressed: () {
              // Compartir producto
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            Container(
              height: 250,
              width: double.infinity,
              color: Colors.grey[200], // Color de fondo para la imagen
              child: Image.network(
                widget.product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset("assets/imagen_no_disponible.png");
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Sección de calificación y opiniones
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
                              widget.product.rating.toString(),
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
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Precio y descuento
                  Row(
                    children: [
                      Text(
                        "\$${widget.product.price}",
                        style:
                            const TextStyle(fontSize: 22, color: Colors.blue),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "\$${(widget.product.price * 1.2).toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "${widget.product.discount} de descuento",
                        style:
                            const TextStyle(color: Colors.green, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Descripción del producto
                  const Text(
                    "Descripción",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(widget.product.description),
                ],
              ),
            ),
          ],
        ),
      ),

      // 🔻 Botón de agregar al carrito con contador
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  // 🔢 Selector de cantidad de productos
  Widget _buildCantidadSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: Colors.blue),
            onPressed: cantidad > 1
                ? () {
                    setState(() {
                      cantidad--;
                    });
                  }
                : null, // Desactiva si cantidad es 1
          ),
          Text(
            cantidad.toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
            onPressed: () {
              setState(() {
                cantidad++;
              });
            },
          ),
        ],
      ),
    );
  }

  // 🛍 Sección de la barra inferior con botón y contador
  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFF8F8F8),
        border: Border(
          top: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Contador de productos
          _buildCantidadSelector(),

          const SizedBox(width: 10),

          // Botón de agregar al carrito
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Agregar producto con la cantidad seleccionada
                  BlocProvider.of<CartBloc>(context).add(
                    AgregarProductoAlCarrito(widget.product, cantidad),
                  );

                  // Mostrar modal de confirmación
                  _mostrarModalConfirmacion(context, cantidad);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Añadir al Carrito",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Modal de confirmación tras agregar productos
  void _mostrarModalConfirmacion(BuildContext context, int cantidadAgregada) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Producto agregado"),
          content: Text("Se añadieron $cantidadAgregada unidades al carrito."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el modal
              },
              child: const Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }
}
