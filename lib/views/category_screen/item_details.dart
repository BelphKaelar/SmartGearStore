import 'package:flutter/material.dart';
import 'package:smartgear_store/consts/consts.dart';
import 'package:smartgear_store/common_widgets/our_button.dart';
import 'package:smartgear_store/controllers/product_controller.dart';

class ItemDetails extends StatelessWidget {
  final String? title;
  final dynamic data;

  const ItemDetails({super.key, required this.title, this.data});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());
    bool isLoggedIn = currentUser != null; // Kiểm tra đăng nhập

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        controller.resetValue();
        return true;
      },
      child: Scaffold(
        backgroundColor: lightGrey,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              controller.resetValue();
              Get.back();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: title!.text.color(darkFontGrey).fontFamily(bold).make(),
          actions: [
            IconButton(
              onPressed: () {
                if (!isLoggedIn) {
                  VxToast.show(context,
                      msg: "Please log in to use this feature.");
                  return;
                }
                if (controller.isFav.value) {
                  controller.removeFromWishlist(data.id, context);
                } else {
                  controller.addToWishlist(data.id, context);
                }
              },
              icon: Icon(
                Icons.favorite,
                color: isLoggedIn
                    ? (controller.isFav.value ? redColor : darkFontGrey)
                    : darkFontGrey,
              ),
            ),
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
                      // Swiper Section
                      VxSwiper.builder(
                        autoPlay: true,
                        height: 350,
                        aspectRatio: 16 / 9,
                        itemCount: data['p_imgs'].length,
                        itemBuilder: (context, index) {
                          return Image.network(
                            data['p_imgs'][index],
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                      10.heightBox,

                      // Title and Rating Section
                      title!.text
                          .size(16)
                          .color(darkFontGrey)
                          .fontFamily(semibold)
                          .make(),
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

                      // Price
                      "${data['p_price']}"
                          .numCurrency
                          .text
                          .color(redColor)
                          .fontFamily(bold)
                          .size(18)
                          .make(),
                      10.heightBox,

                      // Seller Info
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "Seller".text.fontFamily(semibold).make(),
                                "${data['p_seller']}"
                                    .text
                                    .fontFamily(semibold)
                                    .color(darkFontGrey)
                                    .make(),
                              ],
                            ),
                          ),
                          const CircleAvatar(
                            backgroundColor: whiteColor,
                            child: Icon(
                              Icons.message_rounded,
                              color: darkFontGrey,
                            ),
                          ),
                        ],
                      )
                          .box
                          .padding(const EdgeInsets.all(12))
                          .color(textfieldGrey)
                          .make(),
                      20.heightBox,

                      // Color Selection
                      "Select Color"
                          .text
                          .color(darkFontGrey)
                          .fontFamily(semibold)
                          .make(),
                      Obx(
                        () => Row(
                          children: List.generate(
                            data['p_colors'].length,
                            (index) => GestureDetector(
                              onTap: () {
                                controller.changeColorIndex(index);
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  VxBox()
                                      .size(40, 40)
                                      .roundedFull
                                      .color(
                                        Color(data['p_colors'][index])
                                            .withOpacity(1.0),
                                      )
                                      .margin(const EdgeInsets.symmetric(
                                          horizontal: 4))
                                      .make(),
                                  if (index == controller.colorIndex.value) ...[
                                    const Icon(Icons.done, color: Colors.white),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ).box.padding(const EdgeInsets.all(8)).make(),

                      // Quantity Selection
                      "Select Quantity"
                          .text
                          .color(darkFontGrey)
                          .fontFamily(semibold)
                          .make(),
                      Obx(
                        () => Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                controller.decreaseQuantity();
                                controller.calculatePrice(
                                    double.parse(data['p_price']));
                              },
                              icon: const Icon(Icons.remove),
                            ),
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
                              icon: const Icon(Icons.add),
                            ),
                            10.widthBox,
                            "(${data['p_quantity']} available)"
                                .text
                                .color(textfieldGrey)
                                .make(),
                          ],
                        ),
                      ).box.padding(const EdgeInsets.all(8)).make(),
                      20.heightBox,

                      // Description
                      "Description".text.fontFamily(semibold).make(),
                      "${data['p_desc']}".text.color(darkFontGrey).make(),
                      20.heightBox,

                      // Policies
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          3,
                          (index) => Column(
                            children: [
                              Icon(
                                index == 0
                                    ? Icons.local_shipping
                                    : index == 1
                                        ? Icons.access_time
                                        : Icons.cached,
                                color: darkFontGrey,
                              ),
                              5.heightBox,
                              (index == 0
                                      ? "Free Shipping"
                                      : index == 1
                                          ? "Fast Delivery"
                                          : "Easy Return")
                                  .text
                                  .color(darkFontGrey)
                                  .fontFamily(semibold)
                                  .make(),
                            ],
                          ),
                        ),
                      ),
                      20.heightBox,

                      // Related Products
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
                              children: [
                                Image.asset(
                                  imgP1,
                                  width: 150,
                                  fit: BoxFit.cover,
                                ),
                                10.heightBox,
                                "Product $index"
                                    .text
                                    .fontFamily(semibold)
                                    .make(),
                                10.heightBox,
                                "\$100"
                                    .text
                                    .color(redColor)
                                    .fontFamily(bold)
                                    .make(),
                              ],
                            ).box.margin(const EdgeInsets.all(8)).make(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Add to Cart Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ourButton(
                color: Colors.red,
                onPress: () {
                  if (!isLoggedIn) {
                    VxToast.show(context, msg: "Please log in to add to cart.");
                    return;
                  }
                  if (controller.quantity.value > 0) {
                    controller.addToCart(
                      color: data['p_colors'][controller.colorIndex.value],
                      context: context,
                      vendorID: data['vendor_id'],
                      img: data['p_imgs'][0],
                      qty: controller.quantity.value,
                      sellername: data['p_seller'],
                      title: data['p_name'],
                      tprice: controller.totalPrice.value,
                    );
                    VxToast.show(context, msg: "Added to cart");
                  } else {
                    VxToast.show(context,
                        msg: "Please select at least 1 product.");
                  }
                },
                textColor: whiteColor,
                title: "Add to cart",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
