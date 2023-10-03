import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_demo/data/signUp_cubit/sign_up_bloc.dart';
import 'package:firebase_demo/data/signUp_cubit/signup_state.dart';
import 'package:firebase_demo/model/user_model.dart';
import 'package:firebase_demo/ui/screen/auth/complete_profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/colors.dart';
import '../../../utils/text_const.dart';
import '../../const/container_const.dart';
import '../../const/text_field_const.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    isLoading=false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().whiteColor,
      body: bodyData(),
    );
  }

  Widget bodyData() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/login image.png",
                scale: 1.5,
              ),
              textBold(
                  text: "SignUP Account",
                  fontSize: 22,
                  fontColor: AppColors().primaryColor,
                  topPadding: 30),
              TextFormFieldConst(
                hintText: "Enter Email",
                controller: emailController,
              ),
              TextFormFieldConst(
                hintText: "Enter password",
                controller: passwordController,
              ),
              TextFormFieldConst(
                hintText: "Enter ConfirmPassword",
                controller: confirmPasswordController,
              ),
              signUpButtonConst(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textRegular(text: "Already have an account?", fontSize: 14),
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: textRegular(
                          text: "Login",
                          fontSize: 15,
                          fontColor: AppColors().primaryColor,
                          leftPadding: 0)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget signUpButtonConst() {
    return BlocConsumer<SignUpCubit, AuthState>(
      listener: (context, state) async {
        if (state is LoadState) {
          isLoading = true;
        }
        if (state is SuccessState) {
          String uid = state.uid;
          UserModel userModel = UserModel(
              createdOn: Timestamp.now(),
              uid: uid,
              lastName: "",
              firstName: "",
              age: "",
              email: emailController.text.trim(),
              gender: "",
              mobNumber: "",
              profilePicture: "",
              status: "");
          await FirebaseFirestore.instance
              .collection("users")
              .doc(uid)
              .set(userModel.toMap())
              .then((value) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(isEdit: false),
                ));
            isLoading=false;
            setState(() {

            },);
          },);
        }
      },
      builder: (context, state) {
          return ContainerConst(
            topPadding: 50,
            height: 50,
            onTap: () {
              // signUp(emailController.text.trim(),
              //     passwordController.text.trim());

              BlocProvider.of<SignUpCubit>(context).signUp(
                emailController.text.trim(),
                passwordController.text.trim(),
              );
            },
            child: Center(
                child: isLoading
                    ? CircularProgressIndicator(
                        color: AppColors().whiteColor,
                      )
                    : textMedium(
                        text: "Sign UP",
                        fontSize: 16,
                        fontColor: AppColors().whiteColor,
                        topPadding: 0)),
          );

      },
    );
  }
}
