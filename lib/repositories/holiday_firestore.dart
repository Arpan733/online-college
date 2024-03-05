import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:online_college/model/holiday_model.dart';
import 'package:uuid/v4.dart';

import '../consts/utils.dart';

class HolidayFireStore {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addHoliday(
      {required BuildContext context,
      required String title,
      required String description,
      required String date}) async {
    try {
      String hid = const UuidV4().generate().toString();

      Map<String, String> data = {
        'title': title,
        'description': description,
        'date': date,
        'hid': hid,
      };

      await firestore.collection('holiday').doc(hid).set(data);

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Holiday Added');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<void> editHoliday(
      {required BuildContext context,
      required String title,
      required String description,
      required String date,
      required String hid}) async {
    try {
      Map<String, String> data = {
        'title': title,
        'description': description,
        'date': date,
        'hid': hid,
      };

      await firestore.collection('holiday').doc(hid).update(data);

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Holiday Edited');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<List<HolidayModel>> getHoliday({required BuildContext context}) async {
    try {
      return (await firestore.collection('holiday').get())
          .docs
          .map((e) => HolidayModel.fromJson(e.data()))
          .toList();
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }

    return [];
  }

  Future<void> deleteHoliday({required BuildContext context, required String hid}) async {
    try {
      firestore.collection('holiday').doc(hid).delete();
      Utils().showToast(context: context, message: "Holiday Removed.");
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }
}
