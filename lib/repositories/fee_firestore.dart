import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_college/consts/utils.dart';
import 'package:online_college/model/fee_model.dart';

class FeeFireStore {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addFeeToFireStore(
      {required BuildContext context, required FeeModel feeModel}) async {
    try {
      await firestore.collection('fees').doc(feeModel.fid).set(feeModel.toJson());

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Fee Added');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<void> addStudentToFireStoreFeeList(
      {required BuildContext context,
      required String refNo,
      required String sid,
      required FeeModel feeModel}) async {
    try {
      PaidStudent data = PaidStudent(paidTime: DateTime.now().toString(), refNo: refNo, sid: sid);

      feeModel.paidStudents?.add(data);

      await firestore.collection('fees').doc(feeModel.fid).update(feeModel.toJson());
      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Fee Paid');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<void> updateFeeAtFireStore(
      {required BuildContext context, required FeeModel feeModel}) async {
    try {
      await firestore.collection('fees').doc(feeModel.fid).update(feeModel.toJson());

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Fee Edited');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<void> deleteFeeFromFireStore({required BuildContext context, required String fid}) async {
    try {
      await firestore.collection('fees').doc(fid).delete();

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Fee Deleted');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<List<FeeModel>> getFeeListFromFireStore({required BuildContext context}) async {
    try {
      return (await firestore.collection('fees').get())
          .docs
          .map((e) => FeeModel.fromJson(e.data()))
          .toList();
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }

    return [];
  }
}
