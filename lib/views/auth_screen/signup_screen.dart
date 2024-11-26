import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smartgear_store/consts/consts.dart';
import 'package:smartgear_store/controllers/auth_controller.dart';
import 'package:smartgear_store/views/home_screen/home.dart';
import 'package:smartgear_store/common_widgets/applogo_widget.dart';
import 'package:smartgear_store/common_widgets/bg_widget.dart';
import 'package:smartgear_store/common_widgets/custom_textfield.dart';
import 'package:smartgear_store/common_widgets/our_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool? isCheck = false;
  var controller = Get.put(AuthController());

  //text controllers
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordRetypeController = TextEditingController();

  String passwordMessage = "";
  Timer? _debounce; // Delay time to validate retypePassword

  @override
  void initState() {
    super.initState();
    // Pretty much self-explanatory
    passwordRetypeController.addListener(_checkPasswordMatch);
  }

  // Clear up memory
  @override
  void dispose() {
    passwordRetypeController.removeListener(_checkPasswordMatch);
    passwordRetypeController.dispose();
    passwordController.dispose();
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  // Validate after user stops typing for 500ms
  void _checkPasswordMatch() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (passwordRetypeController.text.isNotEmpty &&
          passwordController.text != passwordRetypeController.text) {
        setState(() {
          passwordMessage = "Passwords do not match!";
        });
      } else if (passwordRetypeController.text.isEmpty ||
          passwordController.text.isEmpty) {
        setState(() {
          passwordMessage = "";
        });
      } else {
        setState(() {
          passwordMessage = "Passwords match!";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return bgWidget(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            (context.screenHeight * 0.1).heightBox,
            applogoWidget(),
            10.heightBox,
            "Become $appnameShort member"
                .text
                .fontFamily(bold)
                .white
                .size(18)
                .make(),
            15.heightBox,
            Column(
              children: [
                customTextField(
                  hint: nameHint,
                  title: name,
                  controller: nameController,
                  isPass: false,
                ),
                customTextField(
                  hint: emailHint,
                  title: email,
                  controller: emailController,
                  isPass: false,
                ),
                customTextField(
                  hint: passwordHint,
                  title: password,
                  controller: passwordController,
                  isPass: true,
                ),
                customTextField(
                  hint: passwordHint,
                  title: retypePassword,
                  controller: passwordRetypeController,
                  isPass: true,
                ),
                Text(passwordMessage,
                    style: TextStyle(
                        color: passwordMessage == "Passwords match!"
                            ? Colors.green
                            : Colors.red,
                        fontSize: 14)),
                5.heightBox,
                Row(
                  children: [
                    Checkbox(
                      activeColor: redColor,
                      checkColor: whiteColor,
                      value: isCheck,
                      onChanged: (newValue) {
                        setState(() {
                          isCheck = newValue;
                        });
                      },
                    ),
                    10.widthBox,
                    Expanded(
                      child: RichText(
                          text: const TextSpan(children: [
                        TextSpan(
                            text: userAgreed,
                            style: TextStyle(
                                fontFamily: regular, color: fontGrey)),
                        TextSpan(
                            text: termsNcons,
                            style: TextStyle(
                                fontFamily: regular, color: redColor)),
                        TextSpan(
                            text: " & ",
                            style: TextStyle(
                                fontFamily: regular, color: fontGrey)),
                        TextSpan(
                            text: privacyPolicy,
                            style: TextStyle(
                                fontFamily: regular, color: redColor)),
                      ])),
                    )
                  ],
                ),
                5.heightBox,
                ourButton(
                  color: isCheck == true ? redColor : lightGrey,
                  title: signup,
                  textColor: whiteColor,
                  onPress: () async {
                    if (isCheck != false) {
                      try {
                        await controller
                            .signupMethod(
                          context: context,
                          email: emailController.text,
                          password: passwordController.text,
                        )
                            .then((value) {
                          return controller.storeUserData(
                            email: emailController.text,
                            password: passwordController.text,
                            name: nameController.text,
                          );
                        }).then((value) {
                          VxToast.show(context, msg: loggedIn);
                          Get.offAll(() => const Home());
                        });
                      } catch (e) {
                        auth.signOut();
                        VxToast.show(context, msg: e.toString());
                      }
                    }
                  },
                ).box.width(context.screenWidth - 50).make(),
                10.heightBox,
                // Velocity X can be used to redirect back to login screen (GestureDetector)
                RichText(
                    text: const TextSpan(children: [
                  TextSpan(
                    text: hadAccount,
                    style: TextStyle(fontFamily: bold, color: fontGrey),
                  ),
                  TextSpan(
                    text: login,
                    style: TextStyle(fontFamily: bold, color: redColor),
                  ),
                ])).onTap(() {
                  Get.back(); // GetX come to play again here.
                })
              ],
            )
                .box
                .white
                .rounded
                .padding(const EdgeInsets.all(16))
                .width(context.screenWidth - 70)
                .shadowSm
                .make(),
          ],
        ),
      ),
    ));
  }
}
