import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';


class TextFormFieldConst extends StatelessWidget {
  TextFormFieldConst(
      {this.hintText,
      this.isObsecure,
      this.labelName,
      this.suffixIcon,
      this.controller,
      this.maxline,
      this.keyBoardType,
      this.prefixIcon,
      this.height,
      this.onChange,});

  String? labelName, hintText;
  bool? isObsecure;
  Widget? suffixIcon, prefixIcon;
  int? maxline;
  double? height;
  ValueChanged<String>? onChange;
  TextEditingController? controller;
  TextInputType? keyBoardType;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.020),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelName == null
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(left: 0.0),
                  child: Text(labelName!,
                     ),
                ),
          const SizedBox(
            height: 5,
          ),
          Container(
            height: height ?? 45,
            decoration: BoxDecoration(
                color: AppColors().grey89.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),),
            child: Padding(
              padding: EdgeInsets.only(left: prefixIcon == null ? 20.0 : 10),
              child: TextFormField(
                maxLines: maxline ?? 1,
                onChanged: onChange,
                keyboardType: keyBoardType ?? TextInputType.text,
                controller: controller,
                obscureText: isObsecure ?? false,
                cursorColor: AppColors().primaryBlackColor,
                decoration: InputDecoration(
                  border: InputBorder.none,
// border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                  contentPadding: isObsecure == null
                      ? prefixIcon == null
                          ? EdgeInsets.zero
                          : const EdgeInsets.only(top: 15, left: 12)
                      : const EdgeInsets.only(top: 15),

                  hintText: hintText,
                  suffixIcon: suffixIcon,
                  prefixIcon: prefixIcon,

                  ///Icon(iconsData!,color: AppColors().primaryColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
