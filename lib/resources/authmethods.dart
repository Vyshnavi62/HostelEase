import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class Authmethods {
  Future<String> login(
      {required String email, required String password}) async {
    String res = "";
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        UserCredential cred = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        log(cred.toString());
        res = "success";
        return res;
      } else {
        res = "Please fill all the fields";
        return res;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        res = 'Wrong password provided for that user.';
      } else if (e.code == 'invalid-email') {
        res = 'The email address is not valid';
      } else {
        res = e.code;
      }
    }
    return res;
  }
}
