import 'package:flutter/material.dart';
import 'package:smartgear_store/common_widgets/our_button.dart';
import 'package:smartgear_store/consts/consts.dart';
import 'package:smartgear_store/consts/lists.dart';
import 'package:smartgear_store/controllers/cart_controller.dart';

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return Scaffold(
      backgroundColor: whiteColor,
      bottomNavigationBar: SizedBox(
        height: 60,
        child: ourButton(
            onPress: () {
              controller.placeMyOrder(
                  orderPaymentMethod:
                      paymentMethod[controller.paymentIndex.value],
                  totalAmount: controller.totalP.value);
            },
            color: redColor,
            textColor: whiteColor,
            title: "Place my order"),
      ),
      appBar: AppBar(
        title: "Choose Payment Method"
            .text
            .fontFamily(semibold)
            .color(darkFontGrey)
            .make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Obx(
          () => Column(
            children: List.generate(paymentMethodImgs.length, (index) {
              return GestureDetector(
                onTap: () {
                  controller.changePyamentIndex(index);
                },
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: controller.paymentIndex.value == index
                            ? redColor
                            : Colors.transparent,
                        width: 5,
                      )),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Stack(alignment: Alignment.topRight, children: [
                    Image.asset(
                      paymentMethodImgs[index],
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                      colorBlendMode: controller.paymentIndex.value == index
                          ? BlendMode.darken
                          : BlendMode.color,
                      color: controller.paymentIndex.value == index
                          ? Colors.black.withOpacity(0.3)
                          : Colors.transparent,
                    ),
                    controller.paymentIndex.value == index
                        ? Transform.scale(
                            scale: 1.3,
                            child: Checkbox(
                                activeColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                value: true,
                                onChanged: (value) {}),
                          )
                        : Container(),
                    Positioned(
                        bottom: 0,
                        right: 10,
                        child: "${paymentMethod[index]}"
                            .text
                            .white
                            .fontFamily(semibold)
                            .size(16)
                            .make()),
                  ]),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
