import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartgear_store/common_widgets/custom_textfield.dart';
import 'package:smartgear_store/common_widgets/our_button.dart';
import 'package:smartgear_store/consts/consts.dart';
import 'package:smartgear_store/controllers/cart_controller.dart';
import 'package:smartgear_store/views/cart_screen/payment_method.dart';

class ShippingDetails extends StatefulWidget {
  const ShippingDetails({super.key});

  @override
  State<ShippingDetails> createState() => _ShippingDetailsState();
}

class _ShippingDetailsState extends State<ShippingDetails> {
  final controller = Get.find<CartController>();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadShippingInfo();
  }

  // Hàm tải thông tin giao hàng từ Firestore
  void loadShippingInfo() async {
    try {
      var userDoc = await firestore
          .collection(userCollection)
          .doc(currentUser!.uid)
          .get();
      if (userDoc.exists) {
        var data = userDoc.data()!;
        controller.addressController.text = data['address'] ?? '';
        controller.cityController.text = data['city'] ?? '';
        controller.provinceController.text = data['province'] ?? '';
        controller.phoneController.text = data['phone'] ?? '';
      }
    } catch (e) {
      debugPrint("Error loading shipping info: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Hàm lưu thông tin giao hàng vào Firestore
  Future<void> saveShippingInfo() async {
    try {
      var data = {
        'address': controller.addressController.text,
        'city': controller.cityController.text,
        'province': controller.provinceController.text,
        'phone': controller.phoneController.text,
      };
      await firestore
          .collection(userCollection)
          .doc(currentUser!.uid)
          .set(data, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Error saving shipping info: $e");
      VxToast.show(context, msg: "Failed to save shipping info.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Shipping Info"
            .text
            .fontFamily(semibold)
            .color(darkFontGrey)
            .make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: ourButton(
          onPress: () async {
            if (controller.addressController.text.isNotEmpty &&
                controller.cityController.text.isNotEmpty &&
                controller.provinceController.text.isNotEmpty &&
                controller.phoneController.text.isNotEmpty) {
              await saveShippingInfo();
              Get.to(() => const PaymentMethod());
            } else {
              VxToast.show(context, msg: "Please fill out all fields");
            }
          },
          color: redColor,
          textColor: whiteColor,
          title: "Continue",
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  customTextField(
                      hint: "Address",
                      isPass: false,
                      title: "Address",
                      controller: controller.addressController),
                  customTextField(
                      hint: "City",
                      isPass: false,
                      title: "City",
                      controller: controller.cityController),
                  customTextField(
                      hint: "Province",
                      isPass: false,
                      title: "Province",
                      controller: controller.provinceController),
                  customTextField(
                      hint: "Phone",
                      isPass: false,
                      title: "Phone",
                      controller: controller.phoneController),
                ],
              ),
            ),
    );
  }
}
