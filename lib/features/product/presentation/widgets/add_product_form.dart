import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/product_model.dart';
import '../../data/datasources/product_remote_data_source.dart';

class AddProductForm extends StatelessWidget {
  final ProductRemoteDataSourceImpl productDataSource =
      ProductRemoteDataSourceImpl(firestore: FirebaseFirestore.instance);

  AddProductForm({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController imageUrlController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController discountController = TextEditingController();
    final TextEditingController ratingController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    return AlertDialog(
      title: const Text("Agregar Producto"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            _buildTextField(nameController, "Nombre"),
            _buildTextField(imageUrlController, "URL de Imagen"),
            _buildTextField(priceController, "Precio", isNumber: true),
            _buildTextField(discountController, "Descuento", isNumber: true),
            _buildTextField(ratingController, "Rating", isNumber: true),
            _buildTextField(descriptionController, "Descripción"),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final product = ProductModel(
              id: "",
              name: nameController.text,
              imageUrl: imageUrlController.text,
              price: double.parse(priceController.text),
              discount: double.parse(discountController.text),
              rating: double.parse(ratingController.text),
              description: descriptionController.text,
            );
            final navigator = Navigator.of(context);
            await productDataSource.addProduct(product);
            navigator.pop();
          },
          child: const Text("Guardar"),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
