import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo/data/login_cubit/state.dart';
import 'package:firebase_demo/ui/const/container_const.dart';
import 'package:firebase_demo/ui/const/text_field_const.dart';
import 'package:firebase_demo/ui/screen/auth/sign_up_page.dart';
import 'package:firebase_demo/ui/screen/home_page.dart';
import 'package:firebase_demo/utils/colors.dart';
import 'package:firebase_demo/utils/text_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/login_cubit/bloc.dart';
import '../../../data/signUp_cubit/sign_up_bloc.dart';
import '../../../data/signUp_cubit/signup_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

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
                  text: "Login Account",
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
              loginButtonConst(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textRegular(text: "Don't have an account?", fontSize: 14),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage(),
                          ),
                        );
                      },
                      child: textRegular(
                          text: "Sign Up",
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

  Widget loginButtonConst() {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) async {
        if (state is LoginLoadingState) {
          isLoading = true;
        }
        if (state is LoginSSuccessState) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),(route) => false,
          );
        }
      },
      builder: (context, state) {
        return ContainerConst(
          topPadding: 50,
          height: 50,
          onTap: () {


            BlocProvider.of<LoginCubit>(context).loginAccount(emailController.text, passwordController.text);
          },
          child: Center(
              child: isLoading
                  ? CircularProgressIndicator(
                      color: AppColors().whiteColor,
                    )
                  : textMedium(
                      text: "Login",
                      fontSize: 16,
                      fontColor: AppColors().whiteColor,
                      topPadding: 0)),
        );
      },
    );
  }
}
