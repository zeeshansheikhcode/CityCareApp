
//import 'package:city_care/utils/constants.dart';
import 'package:city_care_app/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterViewModel extends ChangeNotifier {
  
  String message = ""; 

  Future<bool> register(String email, String password) async {

    bool isRegistered = false; 

    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      if(userCredential != null)
      {
       isRegistered = true; 
      }
    } 
    on FirebaseAuthException catch(e) 
    {
      if(e.code == "weak-password") {
        message = Constants.WEAK_PASSWORD; 
      } else if(e.code == "email-already-in-use") {
        message = Constants.EMAIL_ALREADY_IN_USE; 
      }
      notifyListeners(); 
    } catch(e) {
      print(e);
    }
    return isRegistered;

  }



}