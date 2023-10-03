import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_demo/data/chat_room_cubit/blooc.dart';
import 'package:firebase_demo/data/chat_room_cubit/state.dart';
import 'package:firebase_demo/data/search_user_cubit/bloc.dart';
import 'package:firebase_demo/data/search_user_cubit/state.dart';
import 'package:firebase_demo/model/user_model.dart';
import 'package:firebase_demo/ui/const/container_const.dart';
import 'package:firebase_demo/ui/const/text_field_const.dart';
import 'package:firebase_demo/ui/screen/auth/complete_profile_page.dart';
import 'package:firebase_demo/ui/screen/chat_page.dart';
import 'package:firebase_demo/utils/colors.dart';
import 'package:firebase_demo/utils/image_path_const.dart';
import 'package:firebase_demo/utils/text_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCollectionPage extends StatefulWidget {
  const AddCollectionPage({super.key});

  @override
  State<AddCollectionPage> createState() => _AddCollectionPageState();
}

class _AddCollectionPageState extends State<AddCollectionPage> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final SearchController = TextEditingController();
  Size? size;
  List<UserModel> searchedUser = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final searchCubit = BlocProvider.of<SearchUserCubit>(context);
    searchCubit.getAllUser();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors().whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors().primaryColor,
          title: const Text("User Collection"),
          centerTitle: true,
        ),
        body: bodyData(),
      ),
    );
  }

  Widget bodyData() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // searchFieldConst(),
          userConst(),
          fetchSearchUSerConst(),
        ],
      ),
    );
  }

  Widget userConst() {
    return BlocBuilder<SearchUserCubit, SearchUserState>(
      builder: (context, state) {
        if (state is SearchSuccessState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                searchFieldConst(),
                textBold(
                    text: "You",
                    fontSize: 14,
                    fontColor: AppColors().primaryColor),
                const Divider(endIndent: 20, indent: 20),
                Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(isEdit: true),
                        ),
                      );
                    },
                    title: textBold(
                        text: state.currentUserModel.firstName.toString(),
                        fontSize: 14,
                        topPadding: 0,
                        leftPadding: 3),
                    leading: CircleAvatar(
                      radius: 23,
                      backgroundImage: state.currentUserModel.profilePicture ==
                              ""
                          ? const AssetImage(ImagePathConst.profileImage)
                          : NetworkImage(state.currentUserModel.profilePicture
                              .toString()) as ImageProvider,
                    ),
                  ),
                )
              ],
            ),
          );
        }
        return textRegular(text: "", fontSize: 12);
      },
    );
  }

  Widget searchFieldConst() {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 12),
      child: Row(
        children: [
          Container(
            width: size!.width / 1.55,
            child: TextFormFieldConst(
              hintText: "Search Hear...!",
              controller: SearchController,
              onChange: (e) {
                final searchCubit = BlocProvider.of<SearchUserCubit>(context);
                searchCubit
                    .getSearchedUser(SearchController.text.toLowerCase());
              },
            ),
          ),
          ContainerConst(
            topPadding: 20,
            rightPadding: 0,
            height: 40,
            width: 90,
            onTap: () {
              // setState(() {
              //   searchedUser = users.where((user) =>
              //       user.firstName!.toLowerCase().contains(SearchController.text.toLowerCase())).toList();
              // });
            },
            child: Center(
                child: textRegular(
                    text: "Search",
                    fontSize: 16,
                    topPadding: 0,
                    fontColor: AppColors().whiteColor)),
          )
        ],
      ),
    );
  }

  Widget fetchSearchUSerConst() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textBold(
              text: "All", fontSize: 14, fontColor: AppColors().primaryColor),
          const Divider(endIndent: 20, indent: 20),
          BlocConsumer<SearchUserCubit, SearchUserState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is SearchEmptyState) {
                return Center(
                  child: textSemiBold(text: "No user Found", fontSize: 14),
                );
              }
              if (state is SearchLoadingState) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors().primaryColor,
                  ),
                );
              }
              if (state is SearchSuccessState) {
                return Column(
                  children: [
                    ContainerConst(
                      leftPadding: 0,
                      rightPadding: 0,
                      topPadding: 0,
                      color: AppColors().whiteColor,
                      height: size!.height * 0.56,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.userList.length,
                        // shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Card(
                              child: ListTile(
                            onTap: () async {
                              UserModel targetUser = state.userList[index];
                              final myCubit = context.read<ChatRoomCubit>();
                              var chatRoomModel =
                                  await myCubit.getChatRoom(targetUser);
                              if (myCubit.state is ChatRoomSuccessState) {
                                if (context.mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatPage(
                                          targetUser: targetUser,
                                          chatRoomModel: chatRoomModel!),
                                    ),
                                  );
                                }
                              }
                            },
                            title: textBold(
                                text:
                                    state.userList[index].firstName.toString(),
                                fontSize: 14,
                                topPadding: 0,
                                leftPadding: 3),
                            leading: CircleAvatar(
                              radius: 23,
                              backgroundImage:
                                  state.userList[index].profilePicture == ""
                                      ? const AssetImage(
                                          ImagePathConst.profileImage)
                                      : NetworkImage(state
                                          .userList[index].profilePicture
                                          .toString()) as ImageProvider,
                            ),
                          ));
                        },
                      ),
                    ),
                  ],
                );
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: AppColors().primaryColor,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

// Widget fetchSearchUSerConst() {
//   return StreamBuilder(
//     stream: FirebaseFirestore.instance
//         .collection("users")
//         .snapshots(),
//     builder: (context, snapshot) {
//       if (snapshot.hasData) {
//         QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
//         if (dataSnapshot.docs.length > 0) {
//           UserModel searchuser = UserModel.fromMap(
//               dataSnapshot.docs[0].data() as Map<String, dynamic>);
//           return ContainerConstWithoutHW(
//             color: AppColors().whiteColor,
//             child: BlocConsumer<ChatRoomCubit, ChatRoomState>(
//               listener: (context, state) {
//                 if (state is ChatRoomSuccessState) {
//                   if (state.chatRoomModel != null) {
//                     Navigator.pop(context);
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ChatPage(
//                             targetUser: searchuser,
//                             chatRoomModel: state.chatRoomModel),
//                       ),
//                     );
//                   }
//                 }
//               },
//               builder: (context, state) {
//                 return ListTile(
//                   onTap: () async {
//                     BlocProvider.of<ChatRoomCubit>(context)
//                         .getChatRoom(searchuser);
//                   },
//                   leading: CircleAvatar(),
//                   title: textRegular(
//                       text: searchuser.firstName.toString(), fontSize: 14),
//                 );
//               },
//             ),
//           );
//         } else {
//           return Center(
//             child: textSemiBold(text: "NO user Found", fontSize: 12),
//           );
//         }
//       }
//       return Center(
//         child: CircularProgressIndicator(
//           color: AppColors().primaryColor,
//         ),
//       );
//     },
//   );
// }
}
