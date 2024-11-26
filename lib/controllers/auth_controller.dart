import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartgear_store/consts/consts.dart';

class AuthController extends GetxController {
  //text controllers
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  //Login method
  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? userCredential;
    try {
      await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  //Sign up method
  Future<UserCredential?> signupMethod({email, password, context}) async {
    UserCredential? userCredential;
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  //Store data method
  storeUserData({name, email, password}) async {
    DocumentReference store =
        firestore.collection(userCollection).doc(currentUser!.uid);
    await store.set({
      'name': name,
      'email': email,
      'password': password,
      'imgUrl': '',
    });
  }

  //Sign out method
  signoutMethod(context) async {
    try {
      await auth.signOut();
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }
}
