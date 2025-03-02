import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:watch_hub/models/product.dart';

Widget getItemCardCar({required Product product}) {
  Uint8List? imageBytes;
  if (product.imageBase64.isNotEmpty) {
    imageBytes = base64Decode(product.imageBase64);
  }
  return Card(
    elevation: 1.0,
    color:  Color(0xFF003C40).withOpacity(0.3),
    margin: const EdgeInsets.all(8.0),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
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
          const SizedBox(height: 10),
          Text(
            product.name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: Colors.greenAccent, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}

Widget getItemCardSimple({required Product product,required BuildContext context}) {
  Uint8List? imageBytes;
  if (product.imageBase64.isNotEmpty) {
    imageBytes = base64Decode(product.imageBase64);
  }
  return Card(
    elevation: 1.0,
    color: Color(0xFF003C40).withOpacity(0.4),
    margin: const EdgeInsets.all(8.0),
    child: ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: imageBytes != null
            ? Image.memory(
                imageBytes,
                width: 50,
                height: 50,
                fit: BoxFit.fill,
              )
            : Container(
                color: Colors.grey[300],
                width: 50,
                height: 50,
                child: const Icon(Icons.image, color: Colors.white70, size: 50),
              ),
      ),
      title: Text(product.name,style:Theme.of(context).textTheme.titleMedium),
      subtitle: Text(product.desc,style:Theme.of(context).textTheme.titleMedium),
    ),
  );
}
