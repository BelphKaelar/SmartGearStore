import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartgear_store/common_widgets/loading_indicator.dart';
import 'package:smartgear_store/consts/consts.dart';
import 'package:smartgear_store/services/firestore_services.dart';
import 'package:smartgear_store/views/category_screen/item_details.dart';

class SearchScreen extends StatelessWidget {
  final String? title;
  const SearchScreen({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title!.text.color(darkFontGrey).make(),
      ),
      backgroundColor: whiteColor,
      body: FutureBuilder(
          future: FirestoreServices.searachProduct(title),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: loadingIndicator());
            } else if (snapshot.data!.docs.isEmpty) {
              return "No product found.".text.makeCentered();
            } else {
              var data = snapshot.data!.docs;
              var filtered = data
                  .where((element) => element['p_name']
                      .toString()
                      .toLowerCase()
                      .contains(title!.toLowerCase()))
                  .toList();
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      mainAxisExtent: 300),
                  children: filtered
                      .mapIndexed((currentValue, index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                filtered[index]['p_imgs'][0],
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                              const Spacer(),
                              "${filtered[index]['p_name']}"
                                  .text
                                  .fontFamily(semibold)
                                  .color(darkFontGrey)
                                  .make(),
                              10.heightBox,
                              "${filtered[index]['p_price']}"
                                  .text
                                  .fontFamily(bold)
                                  .color(redColor)
                                  .make(),
                            ],
                          )
                              .box
                              .white
                              .outerShadowMd
                              .margin(const EdgeInsets.symmetric(horizontal: 4))
                              .roundedSM
                              .padding(const EdgeInsets.all(12))
                              .make()
                              .onTap(() {
                            Get.to(ItemDetails(
                              title: "${filtered[index]['p_name']}",
                              data: filtered[index],
                            ));
                          }))
                      .toList(),
                ),
              );
            }
          }),
    );
  }
}
