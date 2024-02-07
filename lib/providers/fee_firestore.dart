import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_college/consts/utils.dart';
import 'package:online_college/model/fee_model.dart';

class FeeFireStore {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addFeeToFireStore({required FeeModel feeModel}) async {
    try {
      await firestore.collection('fees').doc(feeModel.fid).set(feeModel.toJson());

      Utils().showToast('Fee Added');
    } catch (e) {
      Utils().showToast(e.toString());
    }
  }

  Future<void> updateFeeAtFireStore({required FeeModel feeModel}) async {
    try {
      await firestore.collection('fees').doc(feeModel.fid).update(feeModel.toJson());

      Utils().showToast('Fee Edited');
    } catch (e) {
      Utils().showToast(e.toString());
    }
  }

  Future<void> deleteFeeFromFireStore({required String fid}) async {
    try {
      await firestore.collection('fees').doc(fid).delete();

      Utils().showToast('Fee Deleted');
    } catch (e) {
      Utils().showToast(e.toString());
    }
  }

  Future<List<FeeModel>> getFeeListFromFireStore() async {
    try {
      return (await firestore.collection('fees').get())
          .docs
          .map((e) => FeeModel.fromJson(e.data()))
          .toList();
    } catch (e) {
      Utils().showToast(e.toString());
    }

    return [];
  }
}
