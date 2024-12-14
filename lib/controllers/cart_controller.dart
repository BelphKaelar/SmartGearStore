import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartgear_store/consts/consts.dart';
import 'package:smartgear_store/controllers/home_controller.dart';

class CartController extends GetxController {
  var totalP = 0.0.obs;

  //Text controllers for shipping details
  var addressController = TextEditingController();
  var cityController = TextEditingController();
  var phoneController = TextEditingController();
  var provinceController = TextEditingController();

  var paymentIndex = 0.obs;

  late dynamic productSnapshot;
  var products = [];

  calculate(data) {
    totalP.value = 0.0;
    for (var i = 0; i < data.length; i++) {
      var price = double.tryParse(data[i]['tprice'].toString()) ?? 0.0;
      totalP.value += price;
    }
    // Fixed price number to 2 decimal places
    totalP.value = double.parse(totalP.value.toStringAsFixed(2));
  }

  changePyamentIndex(index) {
    paymentIndex.value = index;
  }

  placeMyOrder({required orderPaymentMethod, required totalAmount}) async {
    await getProductDetails();
    await firestore.collection(orderCollection).doc().set({
      'order_by': currentUser!.uid,
      'order_by_name': Get.find<HomeController>().username,
      'order_by_email': currentUser!.email,
      'order_by_address': addressController.text,
      'order_by_city': cityController.text,
      'order_by_phone': phoneController.text,
      'order_by_province': provinceController.text,
      'shipping_method': "Home Delivery",
      'payment_method': orderPaymentMethod,
      'order_placed': true,
      'order_confirmed': false,
      'order_delivered': false,
      'order_on_delivery': false,
      'total_amount': totalAmount,
      'orders': FieldValue.arrayUnion(products)
    });
  }

  getProductDetails() {
    products.clear();
    for (var i = 0; i < productSnapshot.length; i++) {
      products.add({
        'color': productSnapshot[i]['color'],
        'img': productSnapshot[i]['img'],
        'qty': productSnapshot[i]['qty'],
        'title': productSnapshot[i]['title']
      });
    }
  }
}