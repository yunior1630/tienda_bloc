import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Details"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset("assets/sample_product.png", height: 250),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Samsung Galaxy S6 Edge",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange),
                      Text("4.5"),
                      SizedBox(width: 10),
                      Text("\$6",
                          style: TextStyle(fontSize: 18, color: Colors.blue)),
                      SizedBox(width: 5),
                      Text("5% off", style: TextStyle(color: Colors.green)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Product Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                      "• Brand: ABC\n• Type: Mobile & Accessories\n• Weight: 389g\n• OS: Android"),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Agregar al carrito
                    },
                    child: Text("Add to Cart"),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
