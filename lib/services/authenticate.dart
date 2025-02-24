import 'package:firebase_auth/firebase_auth.dart';

class Authentication{
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future signIn({required String email, required String password})async{
    try{
     await  _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch(e){
      return e.message;
    }




  }

  Future signUp({required String email, required String password})async{
    try{
      _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch(e){
      return e.message;
    }
  }

  Future signOut() async{
    await _auth.signOut();
  }
}