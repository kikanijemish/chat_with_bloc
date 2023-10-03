import 'package:flutter/cupertino.dart';

class AppColors {
  factory AppColors() {
    return _singleton;
  }
  AppColors._internal();
  static final AppColors _singleton = AppColors._internal();
  final Color whiteColor = const Color(0XFFFFFFFF);
  final Color whiteFA = const Color(0XFFFAFAFA);
  final Color primaryColor = const Color(0XFF5d2768);
  final Color primaryBlackColor = const Color(0XFF344142);
  final Color bottomNavigationColor = const Color(0XFFFFFFFF);
  final Color bgColor = const Color(0XFFFDFDFD);
  final Color blueAssentColor = const Color(0XFF2DCBD0);
  final Color grey89 = const Color(0XFF858D8E);
  final Color lyricsGreyColor = const Color(0XFFAEB9BA);
  final Color fontColor00 = const Color(0XFF003F40);
  final Color imageColor = const Color(0XFFF9F9F9);
  final Color balck27 = const Color(0XFF272727);
  final Color circleBorderColor = const Color(0XFF2ebdce);
  final Color green = const Color(0XFF4D8901);
  final Color red = const Color(0XFFEC0101);

  /// gradient
  final Color leftGradient=const Color(0xFF2FC9CE);
  final Color rightGradient=const Color(0xFF2F9ECE);

  final Gradient linearGradint= LinearGradient(colors: [Color(0xFF2FC9CE),Color(0xFF2F9ECE)],);
  final Gradient circleLinearGradient= LinearGradient(colors: [Color(0xFF2FC9CE).withOpacity(0.7),Color(0xFF2F9ECE)],);

  final Gradient prograssiveColor=const LinearGradient(colors: [Color(0xFFFF9A9E),Color(0xFFFAD0C4),Color(0xFFFAD0C4)]);
  final Gradient MourningColor=const LinearGradient(colors: [Color(0xFF4FACFE),Color(0xFF00F2FE),]);
  final Gradient loveColor=const LinearGradient(colors: [Color(0xFFC471F5),Color(0xFFFA71CD),]);
  final Gradient celebratingColor=const LinearGradient(colors: [Color(0xFFFBC2EB),Color(0xFFA6C1EE),]);
  final Gradient darkColor=const LinearGradient(colors: [Color(0xFFA1C4FD),Color(0xFFC2E9FB),]);
  final Gradient minorColor=const LinearGradient(colors: [Color(0xFFA18CD1),Color(0xFFFBC2EB),]);


}