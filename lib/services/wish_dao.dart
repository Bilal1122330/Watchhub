import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:watch_hub/models/wish.dart';

class WishDao{
  final _databaseReference = FirebaseDatabase.instance.ref('Wishes');

  Query getWishListQuery (String uid){
    if(!kIsWeb){
      FirebaseDatabase.instance.setPersistenceEnabled(true);
    }
    return _databaseReference.child(uid);
  }

  void saveWish(Wish wish, String uuid){
    _databaseReference.child(uuid).push().set(wish.toJson());
  }

  void deleteWish(String uuid,String key){
    _databaseReference.child(uuid.toString()).child(key).remove();
  }

  void updateWish(Wish wish,String uuid,  String key){
    _databaseReference.child(uuid).child(key).update(wish.toJson());
  }
}