import 'package:cloud_firestore/cloud_firestore.dart';

import '../consts/utils.dart';
import '../model/result_model.dart';

class ResultFireStore {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addResultToFireStore({required ResultModel resultModel}) async {
    try {
      await firestore.collection('results').doc(resultModel.sid).set(resultModel.toJson());

      Utils().showToast('Result Added');
    } catch (e) {
      Utils().showToast(e.toString());
    }
  }

  Future<void> updateResultAtFireStore({required ResultModel resultModel}) async {
    try {
      await firestore.collection('results').doc(resultModel.sid).update(resultModel.toJson());

      Utils().showToast('Result Updated');
    } catch (e) {
      Utils().showToast(e.toString());
    }
  }

  Future<void> deleteResultFromFireStore({required String sid}) async {
    try {
      await firestore.collection('results').doc(sid).delete();

      Utils().showToast('Result Deleted');
    } catch (e) {
      Utils().showToast(e.toString());
    }
  }

  Future<List<ResultModel>> getResultListFromFireStore() async {
    try {
      return (await firestore.collection('results').get())
          .docs
          .map((e) => ResultModel.fromJson(e.data()))
          .toList();
    } catch (e) {
      Utils().showToast(e.toString());
    }

    return [];
  }
}
