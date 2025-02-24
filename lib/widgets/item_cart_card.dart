import 'package:flutter/material.dart';
import 'package:watch_hub/models/product.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:watch_hub/widgets/beveled_button.dart';

Widget getItemCard({
  required Product product,
  required int quantity,
  required GestureTapCallback onFavoriteTap,
  required GestureTapCallback onCartTap,
  required GestureTapCallback onIncreaseTap,
  required GestureTapCallback onDecreaseTap,
}) {
  Uint8List? imageBytes;
  if (product.imageBase64.isNotEmpty) {
    imageBytes = base64Decode(product.imageBase64);
  }
  return Card(
    elevation: 1.0,
    color: Colors.orange.withOpacity(0.4),
    margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Product code: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(product.code)
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Product Name: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(product.name)
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: imageBytes != null
                ? Image.memory(
              imageBytes,
              width: 150,
              height: 90,
              fit: BoxFit.fill,
            )
                : Container(
              color: Colors.grey[300],
              width: 150,
              height: 90,
              child: const Icon(Icons.image,
                  color: Colors.white70, size: 50),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Product Description: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                product.desc,
                textAlign: TextAlign.center,
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Product Price: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 5,
              ),
              Text("NFT ${product.price}")
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: onDecreaseTap,
                icon: const Icon(Icons.remove,color: Colors.yellow,),
              ),
              Text(
                "$quantity",
                style: const TextStyle(fontSize: 16),
              ),
              IconButton(
                onPressed: onIncreaseTap,
                icon: const Icon(Icons.add, color: Colors.yellow),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BeveledButton(title: "Add to favorite", onTap: onFavoriteTap),
              const SizedBox(
                width: 5,
              ),
              BeveledButton(title: "Add to cart", onTap: onCartTap),
            ],
          ),
        ],
      ),
    ),
  );
}
