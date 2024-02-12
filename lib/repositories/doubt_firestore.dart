import 'package:cloud_firestore/cloud_firestore.dart';

import '../consts/utils.dart';
import '../model/doubt_model.dart';

class DoubtFireStore {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addDoubtToFireStore({required DoubtModel doubtModel}) async {
    try {
      await firestore.collection('doubts').doc(doubtModel.did).set(doubtModel.toJson());

      Utils().showToast('Doubt Created');
    } catch (e) {
      Utils().showToast(e.toString());
    }
  }

  Future<void> updateDoubtAtFireStore({required DoubtModel doubtModel}) async {
    try {
      await firestore.collection('doubts').doc(doubtModel.did).update(doubtModel.toJson());
    } catch (e) {
      Utils().showToast(e.toString());
    }
  }

  Future<void> deleteDoubtFromFireStore({required String sid}) async {
    try {
      await firestore.collection('doubts').doc(sid).delete();

      Utils().showToast('Doubt Deleted');
    } catch (e) {
      Utils().showToast(e.toString());
    }
  }

  Future<List<DoubtModel>> getDoubtListFromFireStore() async {
    try {
      return (await firestore.collection('doubts').get())
          .docs
          .map((e) => DoubtModel.fromJson(e.data()))
          .toList();
    } catch (e) {
      Utils().showToast(e.toString());
    }

    return [];
  }

  Future<DoubtModel?> getDoubtFromFireStore({required String did}) async {
    try {
      return DoubtModel.fromJson((await firestore.collection('doubts').doc(did).get()).data()!);
    } catch (e) {
      Utils().showToast(e.toString());
    }

    return null;
  }
}
