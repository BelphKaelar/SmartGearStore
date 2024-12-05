import 'dart:io';
import 'package:flutter/material.dart';
import 'package:smartgear_store/common_widgets/bg_widget.dart';
import 'package:smartgear_store/common_widgets/custom_textfield.dart';
import 'package:smartgear_store/common_widgets/our_button.dart';
import 'package:smartgear_store/consts/consts.dart';
import 'package:smartgear_store/controllers/profile_controller.dart';

class EditprofileScreen extends StatelessWidget {
  final dynamic data;
  const EditprofileScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();

    return bgWidget(
      child: Scaffold(
        appBar: AppBar(),
        body: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // If data image url and controller path is empty
              data['imageUrl'] == '' && controller.profileImgPath.isEmpty
                  ? Image.asset(
                      imgProfile2,
                      width: 100,
                      fit: BoxFit.cover,
                    ).box.roundedFull.clip(Clip.antiAlias).make()

                  // If data is not empty but controller path is empty
                  : data['imageUrl'] != '' && controller.profileImgPath.isEmpty
                      ? Image.network(
                          data['imageUrl'],
                          width: 100,
                          fit: BoxFit.cover,
                        ).box.roundedFull.clip(Clip.antiAlias).make()

                      // Else if controller path is not empty but data image url is
                      : Image.file(
                          File(controller.profileImgPath.value),
                          width: 100,
                          fit: BoxFit.cover,
                        ).box.roundedFull.clip(Clip.antiAlias).make(),
              10.heightBox,
              ourButton(
                  color: redColor,
                  onPress: () {
                    controller.changeImage(context);
                  },
                  textColor: whiteColor,
                  title: "Change"),
              const Divider(),
              20.heightBox,
              customTextField(
                  controller: controller.namecontroller,
                  hint: nameHint,
                  title: name,
                  isPass: false),
              10.heightBox,
              customTextField(
                  controller: controller.oldpasscontroller,
                  hint: passwordHint,
                  title: oldPass,
                  isPass: true),
              10.heightBox,
              customTextField(
                  controller: controller.newpasscontroller,
                  hint: passwordHint,
                  title: newPass,
                  isPass: true),
              20.heightBox,
              controller.isLoading.value
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(redColor),
                    )
                  : SizedBox(
                      width: context.screenWidth - 60,
                      child: ourButton(
                          color: redColor,
                          onPress: () async {
                            controller.isLoading(true);
                            // If image is not selected
                            if (controller.profileImgPath.value.isNotEmpty) {
                              await controller.uploadProfileImage();
                            } else {
                              controller.profileImageLink = data['imageUrl'];
                            }
                            // If old password matches database
                            if (data['password'] ==
                                controller.oldpasscontroller.text) {
                              await controller.changeAuthPassword(
                                  email: data['email'],
                                  password: controller.oldpasscontroller.text,
                                  newpassword:
                                      controller.newpasscontroller.text);

                              await controller.updateProfile(
                                  controller.namecontroller.text,
                                  controller.newpasscontroller.text,
                                  controller.profileImageLink);
                              VxToast.show(context, msg: "Updated");
                            } else {
                              VxToast.show(context, msg: "Wrong old password");
                              controller.isLoading(false);
                            }
                          },
                          textColor: whiteColor,
                          title: "Save"),
                    ),
            ],
          )
              .box
              .white
              .shadowSm
              .padding(const EdgeInsets.all(16))
              .margin(const EdgeInsets.only(top: 50, left: 12, right: 12))
              .make(),
        ),
      ),
    );
  }
}
