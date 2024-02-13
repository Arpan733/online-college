import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:online_college/consts/user_shared_preferences.dart';

import '../consts/utils.dart';
import '../model/result_model.dart';

class ResultFireStore {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addResultToFireStore(
      {required BuildContext context, required ResultModel resultModel}) async {
    try {
      await firestore.collection('results').doc(resultModel.sid).set(resultModel.toJson());

      Utils().showToast(context: context, message: 'Result Added');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<void> updateResultAtFireStore(
      {required BuildContext context, required ResultModel resultModel}) async {
    try {
      await firestore.collection('results').doc(resultModel.sid).update(resultModel.toJson());

      Utils().showToast(context: context, message: 'Result Updated');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<void> deleteResultFromFireStore(
      {required BuildContext context, required String sid}) async {
    try {
      await firestore.collection('results').doc(sid).delete();

      Utils().showToast(context: context, message: 'Result Deleted');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<List<ResultModel>> getResultListFromFireStore({required BuildContext context}) async {
    try {
      return (await firestore.collection('results').get())
          .docs
          .map((e) => ResultModel.fromJson(e.data()))
          .toList();
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }

    return [];
  }

  Future<ResultModel?> getResultFromFireStore({required BuildContext context}) async {
    try {
      return ResultModel.fromJson(
          (await firestore.collection('results').doc(UserSharedPreferences.id).get()).data()!);
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }

    return null;
  }
}
