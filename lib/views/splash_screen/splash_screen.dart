import 'package:flutter/material.dart';
import 'package:smartgear_store/consts/consts.dart';
import 'package:smartgear_store/views/auth_screen/login_screen.dart';
import 'package:smartgear_store/common_widgets/applogo_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //Method to change screen
  changeScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      //getX in play
      Get.to(() => const LoginScreen());
    });
  }

  @override
  void initState() {
    changeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: redColor,
      body: Center(
        child: Column(
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Image.asset(icSplashBg, width: 300)),
            20.heightBox,
            applogoWidget(),
            10.heightBox,
            appname.text.fontFamily(bold).size(27).white.make(),
            // 5.heightBox,
            // appversion.text.white.make(),
            const Spacer(),
            studentID.text.white.fontFamily(semibold).make(),
            30.heightBox,
            //This should be enough
          ],
        ),
      ),
    );
  }
}
