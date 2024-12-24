import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smartgear_store/consts/consts.dart';
import 'package:smartgear_store/views/auth_screen/login_screen.dart';
import 'package:smartgear_store/views/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    //Still using getX here so 'MaterialApp' change to 'GetMaterialApp'
    return GetMaterialApp(
        debugShowCheckedModeBanner: false, // remove goddamn debug banner
        title: appname,
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.transparent,
            appBarTheme: const AppBarTheme(
                //To set app bar icons color
                iconTheme: IconThemeData(color: darkFontGrey),
                //Set elevation to 0
                elevation: 0,
                backgroundColor: Colors.transparent),
            fontFamily: regular),
        home: const SplashScreen());
    // home:
    //     const LoginScreen()); //Use this to return if you logged in with auth not user
    // Validate loggin info before if needed
    //     home: auth.currentUser == null ? const LoginScreen() : const SplashScreen(),
    // );
  }
}
