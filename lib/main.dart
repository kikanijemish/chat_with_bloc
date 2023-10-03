import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_demo/sahared_preference/shared_preference_data.dart';
import 'package:firebase_demo/ui/screen/auth/login_page.dart';
import 'package:firebase_demo/ui/screen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import 'data/chat_room_cubit/blooc.dart';
import 'data/general_cubit/cubit.dart';
import 'data/login_cubit/bloc.dart';
import 'data/profileCUbit/bloc.dart';
import 'data/search_user_cubit/bloc.dart';
import 'data/signUp_cubit/sign_up_bloc.dart';
Uuid uuid=Uuid();
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.value(SharedPrefsData().initializeSharedPreference());
await Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
   final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers:[
          BlocProvider<SignUpCubit>(create: (_) => SignUpCubit()),
          BlocProvider<ProfileCubit>(create: (_) => ProfileCubit()),
          BlocProvider<LoginCubit>(create: (_) => LoginCubit()),
          BlocProvider<ChatRoomCubit>(create: (_) => ChatRoomCubit()),
          BlocProvider<SearchUserCubit>(create: (_) => SearchUserCubit()),
          BlocProvider<GeneralCubit>(create: (_) => GeneralCubit()),
        ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:user !=null?HomePage(): LoginPage()
      ),
    );
  }
}

