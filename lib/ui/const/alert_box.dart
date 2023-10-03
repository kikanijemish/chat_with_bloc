import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/font_style_const.dart';
import '../../utils/text_const.dart';

class AlertBox {
// Alert dialog with single button action

  void showDiaLog(context, {Function()? okOnTap, subTitle,okTitle}){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert!'),
          content: Text(subTitle),
          actions: [
            TextButton(onPressed: (){Navigator.pop(context);}, child:textBold(text: "cancel", fontSize: 14)),
            TextButton(onPressed: okOnTap, child:textBold(text: okTitle, fontSize: 14)),

          ],
        );
      },);
  }
  void show(BuildContext context, String title, String subtitle, {onTap}) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            title,
            style: const TextStyle(
              fontFamily: 'PoppinsMedium',
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: GestureDetector(
              onTap: onTap,
              child: Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: 'PoppinsRegular',
                ),
              ),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
                isDefaultAction: true,
                child: const Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: Text(
                    'Ok',
                    style: TextStyle(
                      fontFamily: 'PoppinsRegular',
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }

  showCustomDialog(BuildContext context, {Widget? child, double? radius}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          // You can customize the dialog background shape and other properties here
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            child: child,
          ),
        );
      },
    );
  }

//   void showSnackBar(
//       {required BuildContext context,
//         required String msg,
//         bool isError = false,}) {
//     ScaffoldMessenger.of(context).clearSnackBars();
//     SnackBar snackBar = SnackBar(
//         padding: const EdgeInsets.all(0),
//         margin: const EdgeInsets.all(5),
//         elevation: 10,
//         duration: const Duration(seconds: 5),
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: AppColors().grey89,
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 color: isError ? AppColors().red : AppColors().green,
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(3),
//                   bottomLeft: Radius.circular(3),
//                 ),
//               ),
//               padding: const EdgeInsets.only(
//                 left: 5,
//               ),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: AppColors().whiteFA,
//                   borderRadius:
//                   const BorderRadius.horizontal(right: Radius.circular(3)),
//                 ),
//                 padding: const EdgeInsets.only(top: 5, bottom: 5),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             isError ? "Failed" : "Success",
//                             style: AppFontStyle.poppinsBoldTextStyle(16,
//                                 fontColor: isError
//                                     ? AppColors().red
//                                     : AppColors().green),
//                           ),
//                           Text(
//                             msg,
//                             style: AppFontStyle.poppinsRegularTextStyle(11,
//                                 fontColor: AppColors().primaryColor),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(width: 10),
// // Center(
// //     child: IconButton(
// //         onPressed: () {
// //           ScaffoldMessenger.of(context).clearSnackBars();
// //         },
// //         icon: const Icon(Icons.close_outlined, size: 20, color: AppColors.blueColor))),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ));
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }




  closeIconCupertino({context, title, subtitle, buttonName, onButtonPress}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: dialogContent(
                context, title, subtitle, buttonName, onButtonPress),
          );
        });
  }

  Widget dialogContent(
      BuildContext context, title, subtitle, buttonName, onButtonPress) {
    return Container(
      margin: const EdgeInsets.only(left: 0.0, right: 0.0),
      child: Container(
        margin: const EdgeInsets.only(right: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 50),
                    alignment: Alignment.center,
                    child: Text(
                      title,
                      style: AppFontStyle.poppinsRegularTextStyle(18),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 30, right: 30, bottom: 10, top: 5),
              child: Text(
                subtitle,
                style: AppFontStyle.poppinsRegularTextStyle(16),
              ),
            ),
            const Divider(
              thickness: 1,
            ),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top: 13, bottom: 20),
              child: InkWell(
                child: Text(
                  buttonName.toUpperCase(),
                  style: AppFontStyle.poppinsRegularTextStyle(16,
                      fontColor: AppColors().primaryColor),
                ),
                onTap: () {
                  onButtonPress();
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  showModelBottomSheet(context, child, {isDismissible}) {
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        isDismissible: isDismissible ?? true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return Wrap(children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: AppColors().whiteColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0))),
              child: child,
            )
          ]);
        });
  }
}
