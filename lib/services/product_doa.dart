import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:watch_hub/models/product.dart';


class ProductDao{
  final _databaseRef = FirebaseDatabase.instance.ref("Products");

  void  saveProduct(Product product){
    _databaseRef.push().set(product.toJson());
  }

  Query getProductQuery(){
    if (!kIsWeb) {
      FirebaseDatabase.instance.setPersistenceEnabled(true);
    }
    return _databaseRef;
  }

  void deleteProduct(String key){
    _databaseRef.child(key).remove();
  }

  void updateProduct(String key, Product product){
    _databaseRef.child(key).update(product.toJson());




  }
}