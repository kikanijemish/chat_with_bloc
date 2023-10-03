import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo/data/signUp_cubit/signup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpCubit extends Cubit<AuthState> {
  SignUpCubit() : super(initialState());

  UserCredential? credential;
  String userEmail = "No have an email id";
  String uid = "123";
 loginAccount(String email, String password) async {
   emit(LoadState());
    try {
      credential=   await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if(credential !=null){
        emit(SuccessState(credential!.user!.uid));
      }
    } catch (e) {
      log("login error are => ${e.toString()}");
      emit(ErrorState(e.toString()));
      print(e);
    }
  }

  signUp(String email, String password) async {
    emit(LoadState());
    try {
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      log("error of signUp are => ${e.toString()}");
      emit(ErrorState(e.toString()));
      print(e);
    }

    if (credential != null) {
      emit(SuccessState(credential!.user!.uid.toString()));
      userEmail = email;
      uid=credential!.user!.uid.toString();
    }
  }


}
