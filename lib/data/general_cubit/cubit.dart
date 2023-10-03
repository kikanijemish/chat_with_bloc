import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_demo/data/general_cubit/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class GeneralCubit extends Cubit<GeneralState> {
  GeneralCubit() : super(InitialState());

  String dateTimeCountConst(Timestamp dateTime) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime.toDate());
    String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    String yesterDay = DateFormat('dd-MM-yyyy').format(
        DateFormat('dd-MM-yyyy').parse(todayDate).subtract(Duration(days: 1)));
    if (formattedDate == todayDate) {
      return DateFormat('h:mm a').format(dateTime.toDate());
    } else if (formattedDate == yesterDay) {
      return "Yesterday";
    } else {
      return formattedDate;
    }
  }
}
