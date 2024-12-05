import 'package:flutter/material.dart';
import 'package:smartgear_store/consts/consts.dart';
import 'package:smartgear_store/consts/lists.dart';
import 'package:smartgear_store/common_widgets/our_button.dart';
import 'package:smartgear_store/controllers/product_controller.dart';

class ItemDetails extends StatelessWidget {
  final String? title;
  final dynamic data;
  const ItemDetails({super.key, required this.title, this.data});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductController>();
    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        title: title!.text.color(darkFontGrey).fontFamily(bold).make(),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.share,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.favorite_border_outlined,
              )),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Swiper section <=== This section has error potential, be aware!
                  VxSwiper.builder(
                      autoPlay: true,
                      height: 350,
                      aspectRatio: 16 / 9,
                      itemCount: data['p_imgs'].length,
                      // viewportFraction: 0.8,
                      itemBuilder: (context, index) {
                        return Image.network(
                          data['p_imgs'][index],
                          width: double.infinity,
                          fit: BoxFit.cover,
                        );
                      }),

                  //title and details section
                  10.heightBox,
                  title!.text
                      .size(16)
                      .color(darkFontGrey)
                      .fontFamily(semibold)
                      .make(),

                  //rating
                  10.heightBox,
                  VxRating(
                    isSelectable: false,
                    value: double.parse(data['p_rating']),
                    onRatingUpdate: (value) {},
                    normalColor: textfieldGrey,
                    selectionColor: golden,
                    count: 5,
                    size: 25,
                    maxRating: 5,
                  ),

                  10.heightBox,
                  "${data['p_price']}"
                      .numCurrency //same shit
                      .text
                      .color(redColor)
                      .fontFamily(bold)
                      .size(18)
                      .make(),

                  10.heightBox,
                  Row(
                    children: [
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          "Seller".text.white.fontFamily(semibold).make(),
                          5.heightBox,
                          "${data['p_seller']}"
                              .text
                              .fontFamily(semibold)
                              .color(darkFontGrey)
                              .size(16)
                              .make(),
                        ],
                      )),
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.message_rounded,
                          color: darkFontGrey,
                        ),
                      ),
                    ],
                  )
                      .box
                      .height(60)
                      .padding(const EdgeInsets.symmetric(horizontal: 16))
                      .color(textfieldGrey)
                      .make(),

                  //Color selection section
                  20.heightBox,
                  Obx(
                    () => Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: "Color".text.color(textfieldGrey).make(),
                            ),
                            Row(
                              children: List.generate(
                                data['p_colors'].length,
                                (index) => Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      VxBox()
                                          .size(40, 40)
                                          .roundedFull
                                          .color(Color(data['p_colors'][index])
                                              .withOpacity(1.0))
                                          .margin(const EdgeInsets.symmetric(
                                              horizontal: 4))
                                          .make()
                                          .onTap(() {
                                        controller.changeColorIndex(index);
                                      }),
                                      Visibility(
                                          visible: index ==
                                              controller.colorIndex.value,
                                          child: const Icon(Icons.done,
                                              color: Colors.white))
                                    ]),
                              ),
                            ),
                          ],
                        ).box.padding(const EdgeInsets.all(8)).make(),

                        //Quantity selection
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child:
                                  "Quantity".text.color(textfieldGrey).make(),
                            ),
                            Obx(
                              () => Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        controller.decreaseQuantity();
                                        controller.calculatePrice(
                                            double.parse(data['p_price']));
                                      },
                                      icon: const Icon(Icons.remove)),
                                  controller.quantity.value.text
                                      .size(16)
                                      .color(darkFontGrey)
                                      .fontFamily(bold)
                                      .make(),
                                  IconButton(
                                      onPressed: () {
                                        controller.increaseQuantity(
                                            int.parse(data['p_quantity']));
                                        controller.calculatePrice(
                                            double.parse(data['p_price']));
                                      },
                                      icon: const Icon(Icons.add)),
                                  10.widthBox,
                                  "(${data['p_quantity']} available)"
                                      .text
                                      .color(textfieldGrey)
                                      .make(),
                                ],
                              ),
                            ),
                          ],
                        ).box.padding(const EdgeInsets.all(8)).make(),

                        //Total row
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: "Total: ".text.color(textfieldGrey).make(),
                            ),
                            "${controller.totalPrice.value}"
                                .numCurrency
                                .text
                                .color(redColor)
                                .size(16)
                                .fontFamily(bold)
                                .make(),
                          ],
                        ).box.padding(const EdgeInsets.all(8)).make(),
                      ],
                    ).box.white.shadowSm.make(),
                  ),

                  //Description section
                  10.heightBox,
                  "Description "
                      .text
                      .color(darkFontGrey)
                      .fontFamily(semibold)
                      .make(),
                  10.heightBox,
                  "${data['p_desc']}".text.color(darkFontGrey).make(),

                  //Button section
                  10.heightBox,
                  ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: List.generate(
                        itemDetailsButtonList.length,
                        (index) => ListTile(
                              title: "${itemDetailsButtonList[index]}"
                                  .text
                                  .fontFamily(semibold)
                                  .make(),
                              trailing: const Icon(Icons.arrow_forward),
                            )),
                  ),

                  //Relative products
                  20.heightBox,
                  productyoumaylike.text
                      .fontFamily(bold)
                      .size(16)
                      .color(darkFontGrey)
                      .make(),
                  10.heightBox,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                          6,
                          (index) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    imgP1,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                                  10.heightBox,
                                  "Laptop 6GB? 240GB"
                                      .text
                                      .fontFamily(semibold)
                                      .color(darkFontGrey)
                                      .make(),
                                  10.heightBox,
                                  "\$2000"
                                      .text
                                      .fontFamily(bold)
                                      .color(redColor)
                                      .make(),
                                ],
                              )
                                  .box
                                  .white
                                  .margin(
                                      const EdgeInsets.symmetric(horizontal: 4))
                                  .roundedSM
                                  .padding(const EdgeInsets.all(8))
                                  .make()),
                    ),
                  ),
                ],
              ),
            ),
          )),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ourButton(
                color: Colors.red,
                onPress: () {},
                textColor: whiteColor,
                title: "Add to cart"),
          )
        ],
      ),
    );
  }
}
