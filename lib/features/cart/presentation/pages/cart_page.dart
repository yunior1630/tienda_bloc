import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import '../../domain/entities/cart_item_entity.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrito de Compras"),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartCargado) {
            if (state.productosEnCarrito.isEmpty) {
              return const Center(
                child: Text("Tu carrito está vacío"),
              );
            }
            return ListView.builder(
              itemCount: state.productosEnCarrito.length,
              itemBuilder: (context, index) {
                final item = state.productosEnCarrito[index];
                return _buildCartItem(context, item);
              },
            );
          } else if (state is CartCargando) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text("Error al cargar el carrito"));
          }
        },
      ),
      bottomNavigationBar: _buildBottomSection(context),
    );
  }

  // Widget para mostrar cada producto en el carrito
  Widget _buildCartItem(BuildContext context, CartItemEntity item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        leading: Image.network(
          item.producto.imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset("assets/imagen_no_disponible.png");
          },
        ),
        title: Text(item.producto.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Precio: \$${item.producto.price.toStringAsFixed(2)}"),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    if (item.cantidad > 1) {
                      BlocProvider.of<CartBloc>(context).add(
                        ModificarCantidadProducto(
                            item.producto.id, item.cantidad - 1),
                      );
                    } else {
                      BlocProvider.of<CartBloc>(context).add(
                        EliminarProductoDelCarrito(item.producto.id),
                      );
                    }
                  },
                ),
                Text(item.cantidad.toString(),
                    style: const TextStyle(fontSize: 18)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    BlocProvider.of<CartBloc>(context).add(
                      ModificarCantidadProducto(
                          item.producto.id, item.cantidad + 1),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            BlocProvider.of<CartBloc>(context).add(
              EliminarProductoDelCarrito(item.producto.id),
            );
          },
        ),
      ),
    );
  }

  // Sección inferior con total y botón de pagar
  Widget _buildBottomSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartCargado) {
                double total = state.productosEnCarrito.fold(
                  0.0,
                  (sum, item) => sum + (item.producto.price * item.cantidad),
                );
                return Column(
                  children: [
                    Text(
                      "Total: \$${total.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Acción para proceder con la compra
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Proceder al Pago",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
