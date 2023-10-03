import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_demo/data/general_cubit/cubit.dart';
import 'package:firebase_demo/model/cahtroom_model.dart';
import 'package:firebase_demo/model/get_user_model_const.dart';
import 'package:firebase_demo/sahared_preference/shared_preference_data.dart';
import 'package:firebase_demo/sahared_preference/shared_preference_key.dart';
import 'package:firebase_demo/ui/const/alert_box.dart';
import 'package:firebase_demo/ui/screen/auth/complete_profile_page.dart';
import 'package:firebase_demo/ui/screen/auth/login_page.dart';
import 'package:firebase_demo/ui/screen/chat_page.dart';
import 'package:firebase_demo/utils/colors.dart';
import 'package:firebase_demo/model/user_model.dart';
import 'package:firebase_demo/ui/const/text_field_const.dart';
import 'package:firebase_demo/ui/screen/search_page.dart';
import 'package:firebase_demo/utils/image_path_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../utils/text_const.dart';
import 'package:intl/intl.dart' as intl;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  String dateAndTime = "";

  @override
  Widget build(BuildContext context) {
    final generalCubit=BlocProvider.of<GeneralCubit>(context);
    log("auth key are _-=-=-${SharedPrefsData().getStringData(SharedPrefsKey.authKey)}");
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(55), child: appBarConst()),
        floatingActionButton: FloatingButtonConst(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              TextFormFieldConst(
                hintText: "Search here...!",
                controller: searchController,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chatRooms")
                    .where(
                        "particepate.${SharedPrefsData().getStringData(SharedPrefsKey.authKey)}",
                        isEqualTo: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: AppColors().primaryColor,
                    ));
                  } else {
                    QuerySnapshot dataSnpShot = snapshot.data as QuerySnapshot;
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                              dataSnpShot.docs[index].data()
                                  as Map<String, dynamic>);
                          Map<String, dynamic> particeipante =
                              chatRoomModel.particepate!;

                          List<String> targetUser = particeipante.keys.toList();
                          targetUser.remove(SharedPrefsData()
                              .getStringData(SharedPrefsKey.authKey));
                          return FutureBuilder(
                            future: GetUserModel().getModel(targetUser[0]),
                            builder: (context, snapshot) {
                              UserModel? targetUser = snapshot.data;
                              if (!snapshot.hasData) {
                                return Shimmer.fromColors(
                                    baseColor:
                                        AppColors().grey89.withOpacity(0.3),
                                    highlightColor:
                                        AppColors().grey89.withOpacity(0.2),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Container(
                                        // Set the width and height according to your needs
                                        height: 50,
                                        color: Colors
                                            .white, // Set the initial background color of the container
                                      ),
                                    ));
                              }
                              return Padding(
                                padding:
                                    EdgeInsets.only(top: index == 0 ? 25 : 3),
                                child: Card(
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatPage(
                                              targetUser: targetUser,
                                              chatRoomModel: chatRoomModel),
                                        ),
                                      );
                                    },
                                    trailing: textRegular(
                                        text: generalCubit.dateTimeCountConst(chatRoomModel.createdOn!), fontSize: 12),
                                    title: textSemiBold(
                                        text: targetUser!.firstName.toString(),
                                        fontSize: 16,
                                        leftPadding: 0),
                                    subtitle: textRegular(
                                        text: chatRoomModel.lastMessage.toString()==""?"Say! Hi to your friend": chatRoomModel.lastMessage.toString(),
                                        fontSize: 12,
                                        leftPadding: 0,
                                        topPadding: 0),
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          targetUser.profilePicture == ""
                                              ? const AssetImage(
                                                  ImagePathConst.profileImage)
                                              : NetworkImage(targetUser
                                                  .profilePicture
                                                  .toString()) as ImageProvider,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget appBarConst() {
    return AppBar(
      backgroundColor: AppColors().primaryColor,
      title: const Text("user Detail"),
      centerTitle: true,
      actions: [popupMenuButtonConst()],
    );
  }

  Widget popupMenuButtonConst() {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == "Profile") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(isEdit: true),
            ),
          );
        } else if (value == "Sign Out") {
          AlertBox().showDiaLog(context,
              okTitle: "ok",
              subTitle: "Are you sure want to app sign out", okOnTap: () {
            SharedPrefsData().logOutClear();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
                (route) => false);
          });
        } else if (value == "Exit") {
          AlertBox().showDiaLog(context,
              okTitle: "ok",
              subTitle: "Are you sure want to app exit", okOnTap: () {
            exit(0);
          });
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'Profile',
          child: textRegular(
              text: "Profile",
              fontSize: 14,
              topPadding: 0,
              bottomPadding: 0,
              rightPadding: 0),
        ),
        PopupMenuItem<String>(
          value: 'Sign Out',
          child: textRegular(
              text: "Sign Out",
              fontSize: 14,
              topPadding: 0,
              bottomPadding: 0,
              rightPadding: 0),
        ),
        PopupMenuItem<String>(
          value: 'Exit',
          child: textRegular(
              text: "Exit",
              fontSize: 14,
              topPadding: 0,
              bottomPadding: 0,
              rightPadding: 0),
        ),
      ],
    );
  }

  Widget FloatingButtonConst() {
    return FloatingActionButton(
      backgroundColor: AppColors().primaryColor,
      child: Text("Add"),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddCollectionPage(),
          ),
        );
      },
    );
  }
  //

}
