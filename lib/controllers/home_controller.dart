import 'package:flutter/material.dart';
import 'package:smartgear_store/consts/consts.dart';

class HomeController extends GetxController {
  var searchController = TextEditingController();
  var currentNavIndex = 0.obs;
  var username = '';
  var isLoggedIn = false.obs;

  @override
  void onInit() {
    // Check log in state
    if (auth.currentUser != null) {
      isLoggedIn(true);
      getUsername();
    }
    super.onInit();
  }

  getUsername() async {
    var n = await firestore
        .collection(userCollection)
        .where('id', isEqualTo: auth.currentUser!.uid)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        return value.docs.single['name'];
      }
      return '';
    });
    username = n ?? '';
  }
}
