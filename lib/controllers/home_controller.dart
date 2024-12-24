import 'package:flutter/material.dart';
import 'package:smartgear_store/consts/consts.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    getUsername();
    super.onInit();
  }

  var searchController = TextEditingController();
  var currentNavIndex = 0.obs;
  var username = '';
  getUsername() async {
    if (auth.currentUser == null) return;
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
