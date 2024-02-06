import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_college/model/holiday_model.dart';
import 'package:uuid/v4.dart';

import '../consts/utils.dart';

class HolidayFireStore {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addHoliday(
      {required String title, required String description, required String date}) async {
    try {
      String hid = const UuidV4().generate().toString();

      Map<String, String> data = {
        'title': title,
        'description': description,
        'date': date,
        'hid': hid,
      };

      await firestore.collection('holiday').doc(hid).set(data);
      Utils().showToast('Holiday Added');
    } catch (e) {
      Utils().showToast(e.toString());
    }
  }

  Future<void> editHoliday(
      {required String title,
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
      Utils().showToast('Holiday Edited');
    } catch (e) {
      Utils().showToast(e.toString());
    }
  }

  Future<List<HolidayModel>> getHoliday() async {
    try {
      return (await firestore.collection('holiday').get())
          .docs
          .map((e) => HolidayModel.fromJson(e.data()))
          .toList();
    } catch (e) {
      Utils().showToast(e.toString());
    }

    return [];
  }

  Future<void> deleteHoliday({required String hid}) async {
    try {
      firestore.collection('holiday').doc(hid).delete();
      Utils().showToast("Holiday Removed.");
    } catch (e) {
      Utils().showToast(e.toString());
    }
  }
}
