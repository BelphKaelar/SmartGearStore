import 'package:flutter/material.dart';
import 'package:smartgear_store/consts/consts.dart';

Widget applogoWidget(){
  //Velocity X 
  return Image.asset(icAppLogo).box.white.size(77, 77).padding(const EdgeInsets.all(8)).rounded.make();
}