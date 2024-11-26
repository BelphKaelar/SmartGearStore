import 'package:flutter/material.dart';
import 'package:smartgear_store/consts/consts.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: "Cart is Empty!"
          .text
          .fontFamily(semibold)
          .color(darkFontGrey)
          .makeCentered(),
    );
  }
}
