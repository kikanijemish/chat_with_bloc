import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo/data/login_cubit/state.dart';
import 'package:firebase_demo/sahared_preference/shared_preference_data.dart';
import 'package:firebase_demo/sahared_preference/shared_preference_key.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState>{
  LoginCubit():super(LoginInitialState());
  UserCredential? credential;
  loginAccount(String email, String password) async {
    emit(LoginLoadingState());
    try {
      credential=   await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if(credential !=null){
        emit(LoginSSuccessState(credential!.user!.uid));
        SharedPrefsData().setStringData(SharedPrefsKey.authKey,credential!.user!.uid );
      }
    } catch (e) {
      log("login error are => ${e.toString()}");
      emit(LoginErrorState(e.toString()));
      print(e);
    }
  }
}