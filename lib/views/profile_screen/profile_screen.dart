import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartgear_store/consts/consts.dart';
import 'package:smartgear_store/consts/lists.dart';
import 'package:smartgear_store/controllers/auth_controller.dart';
import 'package:smartgear_store/controllers/profile_controller.dart';
import 'package:smartgear_store/services/firestore_services.dart';
import 'package:smartgear_store/views/auth_screen/login_screen.dart';
import 'package:smartgear_store/views/profile_screen/components/details_card.dart';
import 'package:smartgear_store/common_widgets/bg_widget.dart';
import 'package:smartgear_store/views/profile_screen/editprofile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Force it to return back to LoginScreen
    // because idk what cause it return to HomeScreen after Logout once
    if (currentUser == null) {
      // SEND HELP! T_T
      return const LoginScreen();
    }
    var controller = Get.put(ProfileController());
    return bgWidget(
      child: Scaffold(
          body: StreamBuilder(
              stream: FirestoreServices.getUser(currentUser!.uid),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshots) {
                if (!snapshots.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(redColor),
                    ),
                  );
                } else {
                  var data = snapshots.data!.docs[0];

                  return SafeArea(
                    child: Column(
                      children: [
                        //Edit profile button
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Align(
                              alignment: Alignment.topRight,
                              child: Icon(
                                Icons.edit,
                                color: whiteColor,
                              )).onTap(() {
                            controller.namecontroller.text = data['name'];
                            // controller.passcontroller.text = data['password'];
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
                                    )
                                      .box
                                      .roundedFull
                                      .clip(Clip.antiAlias)
                                      .make()
                                  : Image.network(
                                      data['imageUrl'],
                                      width: 100,
                                      fit: BoxFit.cover,
                                    )
                                      .box
                                      .roundedFull
                                      .clip(Clip.antiAlias)
                                      .make(),
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
                                child: "Logout"
                                    .text
                                    .fontFamily(semibold)
                                    .white
                                    .make(),
                              ),
                            ],
                          ),
                        ),

                        20.heightBox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            detailsCard(
                                count: data['cart_count'],
                                title: "In your cart",
                                width: context.screenWidth / 3.4),
                            detailsCard(
                                count: data['wish_count'],
                                title: "In your wishlist",
                                width: context.screenWidth / 3.4),
                            detailsCard(
                                count: data['order_count'],
                                title: "Orders",
                                width: context.screenWidth / 3.4),
                          ],
                        ),

                        //Buttons section
                        ListView.separated(
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    leading: Image.asset(
                                      profileButtonIcon[index],
                                      width: 22,
                                    ),
                                    title: "${profileButtonList[index]}"
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
              })),
    );
  }
}
