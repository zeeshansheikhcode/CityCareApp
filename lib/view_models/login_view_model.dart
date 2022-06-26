import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  String message = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<bool> login(String email, String password) async {
    bool isLoggedIn = false;
    try {
      print('here ');
       UserCredential result =
     await _auth.signInWithEmailAndPassword(email: email, password: email);
     User? user = result.user;
     // final result = await _auth.signInWithEmailAndPassword(email: email, password: password); 
        //    UserCredential result =
        //    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        //    final User user = result.user!;
        print('here 1');
          if(user!.uid != null)
           {  print('here 2');
             isLoggedIn = true;
           }  
    } on FirebaseAuthException catch (e) {
      if(e.code == "user-not-found") {
        message = "User is not registered!";
      }
       print('here 3');
      notifyListeners();
    } catch (e){
       print('here 4');
      print(e);
    }
     print('here 5');
    return isLoggedIn;
  }
}
