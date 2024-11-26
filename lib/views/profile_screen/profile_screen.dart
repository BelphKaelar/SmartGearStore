import 'package:flutter/material.dart';
import 'package:smartgear_store/consts/consts.dart';
import 'package:smartgear_store/consts/lists.dart';
import 'package:smartgear_store/controllers/auth_controller.dart';
import 'package:smartgear_store/views/auth_screen/login_screen.dart';
import 'package:smartgear_store/views/profile_screen/components/details_card.dart';
import 'package:smartgear_store/common_widgets/bg_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        body: SafeArea(
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
                    )).onTap(() {}),
              ),

              //Users details section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Image.asset(
                      imgProfile2,
                      width: 100,
                      fit: BoxFit.cover,
                    ).box.roundedFull.clip(Clip.antiAlias).make(),
                    10.widthBox,
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        "Dummy User".text.fontFamily(semibold).white.make(),
                        "customer@example.com".text.white.make(),
                      ],
                    )),

                    //Logout button - I'll be back for this later UI changes
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                        color: whiteColor,
                      )),
                      onPressed: () async {
                        await Get.put(AuthController()).signoutMethod(context);
                        Get.offAll(() => const LoginScreen());
                      },
                      child: "Logout".text.fontFamily(semibold).white.make(),
                    ),
                  ],
                ),
              ),

              20.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  detailsCard(
                      count: "00",
                      title: "In your cart",
                      width: context.screenWidth / 3.4),
                  detailsCard(
                      count: "02",
                      title: "in your your wishlist",
                      width: context.screenWidth / 3.4),
                  detailsCard(
                      count: "3235",
                      title: "You Ordered",
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
                  .margin(EdgeInsets.all(12))
                  .padding(EdgeInsets.symmetric(horizontal: 16))
                  .shadowSm
                  .make()
                  .box
                  .color(redColor)
                  .make(),
            ],
          ),
        ),
      ),
    );
  }
}
