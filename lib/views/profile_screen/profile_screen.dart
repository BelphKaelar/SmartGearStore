import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartgear_store/common_widgets/loading_indicator.dart';
import 'package:smartgear_store/consts/consts.dart';
import 'package:smartgear_store/consts/lists.dart';
import 'package:smartgear_store/controllers/auth_controller.dart';
import 'package:smartgear_store/controllers/profile_controller.dart';
import 'package:smartgear_store/services/firestore_services.dart';
import 'package:smartgear_store/views/auth_screen/login_screen.dart';
import 'package:smartgear_store/views/order_screen/order_screen.dart';
import 'package:smartgear_store/views/profile_screen/components/details_card.dart';
import 'package:smartgear_store/common_widgets/bg_widget.dart';
import 'package:smartgear_store/views/profile_screen/editprofile_screen.dart';
import 'package:smartgear_store/views/wishlist_screen/wishlist_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Force it to return back to LoginScreen
    // because idk what cause it return to HomeScreen after Logout once
    if (auth.currentUser == null) {
      return const LoginScreen(); //  H E L P !
    }
    var controller = Get.put(ProfileController());
    return bgWidget(
      child: Scaffold(
        body: StreamBuilder(
          stream: FirestoreServices.getUser(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshots) {
            if (!snapshots.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(redColor),
                ),
              );
            } else if (snapshots.data!.docs.isEmpty) {
              return Center(
                child: "No data found.".text.make(),
              );
            } else {
              var data = snapshots.data!.docs[0];

              return SafeArea(
                child: Column(
                  children: [
                    // Edit profile button
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.edit,
                          color: whiteColor,
                        ),
                      ).onTap(() {
                        controller.namecontroller.text = data['name'] ?? '';
                        Get.to(() => EditprofileScreen(data: data));
                      }),
                    ),
                    //Users details section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          data['imageUrl'] == ''
                              ? Image.asset(
                                  imgProfile2,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ).box.roundedFull.clip(Clip.antiAlias).make()
                              : Image.network(
                                  data['imageUrl'],
                                  width: 100,
                                  fit: BoxFit.cover,
                                ).box.roundedFull.clip(Clip.antiAlias).make(),
                          10.widthBox,
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "${data['name']}"
                                  .text
                                  .fontFamily(semibold)
                                  .white
                                  .make(),
                              "${data['email']}".text.white.make(),
                            ],
                          )),

                          //Logout button - Idk bout dis but there seem to be a problem back and fort Logout and Home/Login
                          //Patched but at what cost T_T
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                              color: whiteColor,
                            )),
                            onPressed: () async {
                              await Get.put(AuthController())
                                  .signoutMethod(context);
                              Get.offAll(() => const LoginScreen());
                            },
                            child:
                                "Logout".text.fontFamily(semibold).white.make(),
                          ),
                        ],
                      ),
                    ),

                    20.heightBox,
                    FutureBuilder(
                        future: FirestoreServices.getCounts(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: loadingIndicator());
                          } else {
                            var countData = snapshot.data;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                detailsCard(
                                    count: countData[0].toString(),
                                    title: "In your cart",
                                    width: context.screenWidth / 3.4),
                                detailsCard(
                                    count: countData[1].toString(),
                                    title: "In your wishlist",
                                    width: context.screenWidth / 3.4),
                                detailsCard(
                                    count: countData[2].toString(),
                                    title: "Orders",
                                    width: context.screenWidth / 3.4),
                              ],
                            );
                          }
                        }),
                    //Buttons section
                    ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                onTap: () {
                                  switch (index) {
                                    case 0:
                                      Get.to(OrderScreen());
                                      break;
                                    case 1:
                                      Get.to(WishlistScreen());
                                      break;
                                  }
                                },
                                leading: Image.asset(
                                  profileButtonIcon[index],
                                  width: 22,
                                ),
                                title: profileButtonList[index]
                                    .text
                                    .fontFamily(semibold)
                                    .color(darkFontGrey)
                                    .make(),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Divider(
                                color: lightGrey,
                              );
                            },
                            itemCount: profileButtonList.length)
                        .box
                        .white
                        .rounded
                        .margin(const EdgeInsets.all(12))
                        .padding(const EdgeInsets.symmetric(horizontal: 16))
                        .shadowSm
                        .make()
                        .box
                        .color(redColor)
                        .make(),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
