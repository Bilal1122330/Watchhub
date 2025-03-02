import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:watch_hub/models/product.dart';
import 'package:watch_hub/services/product_doa.dart';
import 'package:watch_hub/widgets/admin_cus_drawer.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});
  static const routeName = "/ProductListScreen";

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductDao _productDao = ProductDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:const AdminCusDrawer(),
      appBar: AppBar(
          title:  Text("Product List",
            style: Theme
                .of(context)
                .textTheme
                .titleMedium,
          ),
        iconTheme: const IconThemeData(color: Colors.deepOrange),
      ),
      body: StreamBuilder(
        stream: _productDao.getProductQuery().onValue,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          // Check if snapshot has data and that the data has a non-null value
          if (!snapshot.hasData || snapshot.data.snapshot.value == null) {
            return const Center(child: Text("No Products Found"));
          }

          // Explicitly cast Firebase data to Map<String, dynamic>
          Map<String, dynamic> productsMap = Map<String, dynamic>.from(
              snapshot.data.snapshot.value as Map);

          List<Product> products = productsMap.entries
              .map((e) => Product.fromJson(Map<String, dynamic>.from(e.value)))
              .toList();



          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              Product product = products[index];
              // Get the corresponding key from productsMap keys
              String key = productsMap.keys.toList()[index];

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: product.imageBase64.isNotEmpty
                      ? Image.memory(
                    base64Decode(product.imageBase64),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                      : const Icon(Icons.image_not_supported, size: 50),
                  title: Text(product.name),
                  subtitle: Text("\$${product.price.toStringAsFixed(2)}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () =>
                            _editProduct(context, product, key),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteProduct(key),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _deleteProduct(String key) {
    _productDao.deleteProduct(key);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Product Deleted")));
  }

  void _editProduct(BuildContext context, Product product, String key) {
    Navigator.pushNamed(
      context,
      "/AddProductPage", // or PageRoutes.addProductPage
      arguments: {
        'key': key,
        'product': product,
      },
    );
  }




// void _editProduct(BuildContext context, Product product, String key) {
  //   TextEditingController nameController =
  //   TextEditingController(text: product.name);
  //   TextEditingController priceController =
  //   TextEditingController(text: product.price.toString());
  //   TextEditingController descriptionController =
  //   TextEditingController(text: product.desc);
  //
  //
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text("Edit Product"),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           TextField(
  //               controller: nameController,
  //               decoration: const InputDecoration(labelText: "Name")),
  //           const SizedBox(height: 24),
  //           TextField(
  //               controller: priceController,
  //               decoration: const InputDecoration(labelText: "Price"),
  //               keyboardType: TextInputType.number),
  //           const SizedBox(height: 24),
  //           TextField(
  //               controller: descriptionController,
  //               decoration: const InputDecoration(labelText: "Description")),
  //
  //         ],
  //       ),
  //       actions: [
  //         TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text("Cancel")),
  //         ElevatedButton(
  //           onPressed: () {
  //             Product updatedProduct = Product(
  //               code: product.code,
  //               name: nameController.text,
  //               desc: descriptionController.text,
  //               category: product.category,
  //               price: double.parse(priceController.text),
  //               imageBase64: product.imageBase64,
  //               status: product.status,
  //             );
  //             _productDao.updateProduct(key, updatedProduct);
  //             Navigator.pop(context);
  //             ScaffoldMessenger.of(context).showSnackBar(
  //                 const SnackBar(content: Text("Product Updated")));
  //           },
  //           child: const Text("Update"),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
