import 'dart:developer';
import 'dart:io';
import 'package:firebase_demo/data/profileCUbit/state.dart';
import 'package:firebase_demo/data/signUp_cubit/sign_up_bloc.dart';
import 'package:firebase_demo/model/get_user_model_const.dart';
import 'package:firebase_demo/model/user_model.dart';
import 'package:firebase_demo/sahared_preference/shared_preference_data.dart';
import 'package:firebase_demo/sahared_preference/shared_preference_key.dart';
import 'package:firebase_demo/ui/const/alert_box.dart';
import 'package:firebase_demo/ui/const/container_const.dart';
import 'package:firebase_demo/ui/const/text_field_const.dart';
import 'package:firebase_demo/utils/colors.dart';
import 'package:firebase_demo/utils/image_path_const.dart';
import 'package:firebase_demo/utils/text_const.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/profileCUbit/bloc.dart';
import '../../../data/signUp_cubit/signup_state.dart';
import '../home_page.dart';

class ProfileScreen extends StatefulWidget {
  final bool isEdit;

  ProfileScreen({
    super.key,
    required this.isEdit,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  Size? size;
  bool isLoading = false;
  File image=File("");
  String pickedImage = "";
  String userImage = "";

  pickImage(ImageSource source) async {
    XFile? pickFile = await ImagePicker().pickImage(source: source);
    if (pickFile != null) {
      cropImage(pickFile);
    }
  }

  cropImage(XFile cropImage) async {
    final cropImages =
        await ImageCropper().cropImage(sourcePath: cropImage.path);
    if (cropImages != null) {
      setState(() {
        image = cropImages;
        pickedImage = cropImages.path;
      });
    }
  }

  Future<String> uploadImageToFirebaseStorage(File imageFile) async {
    try {
        final Reference storageReference = FirebaseStorage.instance
            .ref("ProfilePic")
            .child(SharedPrefsData()
            .getStringData(SharedPrefsKey.authKey)
            .toString());

        UploadTask uploadTask = storageReference.putFile(imageFile);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

        String downloadURL = await taskSnapshot.ref.getDownloadURL();
        log("url are==-=${downloadURL}");
        return downloadURL;


    } catch (e) {
      print("Error uploading image: $e");
      return "";
    }
  }

  updateProfile() async {
    // var email = BlocProvider.of<SignUpCubit>(context).userEmail;
    // emailController.text = email;

    UserModel? userModel = await GetUserModel().getModel(
        SharedPrefsData().getStringData(SharedPrefsKey.authKey).toString());
    if (widget.isEdit == true ) {
      firstNameController.text = userModel!.firstName.toString();
      lastNameController.text = userModel.lastName.toString();
      emailController.text = userModel.email.toString();
      mobileController.text = userModel.mobNumber.toString();
      ageController.text = userModel.age.toString();
      genderController.text = userModel.gender.toString();
      userImage=userModel.profilePicture.toString();
      setState(() {

      });
      log("image url are-===-${userModel.profilePicture.toString()}");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateProfile();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    log("profle picture are-===-=${userImage}");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: textBold(
              text: "Your Profile",
              fontSize: 16,
              topPadding: 0,
              fontColor: AppColors().whiteColor),
          // automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: AppColors().primaryColor,
        ),
        body: bodyData(),
      ),
    );
  }

  Widget bodyData() {
    return Center(
      child: SingleChildScrollView(
        child:emailController.text.isNotEmpty? Column(
          children: [profilePicConst(), formFieldConst(), submitButtonConst()],
        ):CircularProgressIndicator(color: AppColors().primaryColor,)
      ),
    );
  }

  Widget profilePicConst() {
    return InkWell(
      onTap: () {
        AlertBox().showCustomDialog(context, child: dialogConst());
      },
      child:widget.isEdit?CircleAvatar(radius: 50,backgroundImage:pickedImage==""?NetworkImage(userImage):FileImage(image!)as ImageProvider,): CircleAvatar(
        radius: 50,
        backgroundImage: pickedImage == ""
            ? AssetImage(ImagePathConst.profileImage)
            : FileImage(File(pickedImage)) as ImageProvider,
      ),
    );
  }

  Widget formFieldConst() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          TextFormFieldConst(
            hintText: "Enter Firstname",
            controller: firstNameController,
          ),
          TextFormFieldConst(
            hintText: "Enter lastname",
            controller: lastNameController,
          ),
          TextFormFieldConst(
            hintText: "Enter email",
            controller: emailController,
          ),
          TextFormFieldConst(
            hintText: "Enter mobile number",
            controller: mobileController,
          ),
          TextFormFieldConst(
            hintText: "Enter age",
            controller: ageController,
          ),
          TextFormFieldConst(
            hintText: "Enter Gender",
            controller: genderController,
          ),
        ],
      ),
    );
  }

  Widget dialogConst() {
    return ContainerConst(
      height: 150,
      topPadding: 0,
      color: AppColors().whiteColor,
      child: Column(
        children: [
          textBold(text: "Select Image by...", fontSize: 14),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ContainerConstWithoutHW(
                  onTap: () {
                    Navigator.pop(context);

                    pickImage(ImageSource.camera);
                  },
                  child: Center(
                    child: textSemiBold(
                        text: "Camera",
                        fontSize: 14,
                        fontColor: AppColors().whiteColor,
                        leftPadding: 15,
                        rightPadding: 15,
                        bottomPadding: 10,
                        topPadding: 10),
                  ),
                ),
                ContainerConstWithoutHW(
                  onTap: () {
                    Navigator.pop(context);

                    pickImage(ImageSource.gallery);
                  },
                  child: Center(
                    child: textSemiBold(
                        text: "Gallery",
                        fontSize: 14,
                        fontColor: AppColors().whiteColor,
                        leftPadding: 15,
                        rightPadding: 15,
                        bottomPadding: 10,
                        topPadding: 10),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget submitButtonConst() {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) async {
        if (state is LoadState) {
          isLoading = true;
        }
        if (state is ProfileSuccessState) {

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        return ContainerConst(
          topPadding: 35,
          height: 50,
          onTap: () async {
            String? picture="";
            if(image!=""){
              log("call if=f=f===f==");
              picture= await uploadImageToFirebaseStorage(image);
              log("picture are-=-=-${picture}");

            }else{
              picture="";
            }
            // setState(() async {
            //   // isLoading=true;
            //
            // });
            if (picture != "") {
              log("call if condition-=f-s=-fs=-f=s-f=sf-s=-s=${picture}");

              var uid = SharedPrefsData().getStringData(SharedPrefsKey.authKey);
              log("uid are -=-=${uid}");
              UserModel userModel = UserModel(
                status: "",
                profilePicture: "${picture}",
                mobNumber: mobileController.text.toString(),
                gender: genderController.text,
                email: "",
                age: ageController.text,
                firstName: firstNameController.text,
                lastName: lastNameController.text,
              );
              BlocProvider.of<ProfileCubit>(context)
                  .updateProfile(userModel, uid);

            }
            else{
              log("call else condition=-=--=");
              var uid = SharedPrefsData().getStringData(SharedPrefsKey.authKey);
              log("uid are -=-=${uid}");
              UserModel userModel = UserModel(
                status: "",
                profilePicture: "${userImage}",
                mobNumber: mobileController.text.toString(),
                gender: genderController.text,
                email: "",
                age: ageController.text,
                firstName: firstNameController.text,
                lastName: lastNameController.text,
              );
              BlocProvider.of<ProfileCubit>(context)
                  .updateProfile(userModel, uid);
            }

          },
          child: Center(
            child: isLoading==true?CircularProgressIndicator(color: AppColors().whiteColor,): textBold(
                text: "Submit",
                fontSize: 15,
                topPadding: 0,
                fontColor: AppColors().whiteColor),
          ),
        );
      },
    );
  }
}
