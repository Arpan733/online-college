import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/consts/utils.dart';
import 'package:online_college/model/leave_application_model.dart';

class LeaveApplicationFireStore {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addLeaveApplicationToFireStore(
      {required BuildContext context, required LeaveApplicationModel leaveApplicationModel}) async {
    try {
      await firestore
          .collection('leave-application')
          .doc(leaveApplicationModel.lid)
          .set(leaveApplicationModel.toJson());

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Leave Application Added');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<void> updateLeaveApplicationAtFireStore(
      {required BuildContext context, required LeaveApplicationModel leaveApplicationModel}) async {
    try {
      await firestore
          .collection('leave-application')
          .doc(leaveApplicationModel.lid)
          .update(leaveApplicationModel.toJson());

      if (!context.mounted) return;
      Utils().showToast(
        context: context,
        message: UserSharedPreferences.role == 'student'
            ? 'Leave Application Edited'
            : leaveApplicationModel.status == 'approved'
                ? 'Leave Approved'
                : 'Leave Rejected',
      );
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<void> deleteLeaveApplicationFromFireStore(
      {required BuildContext context, required String eid}) async {
    try {
      await firestore.collection('leave-application').doc(eid).delete();

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Leave Application Deleted');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<List<LeaveApplicationModel>> getLeaveApplicationListFromFireStore(
      {required BuildContext context}) async {
    try {
      return (await firestore.collection('leave-application').get())
          .docs
          .map((e) => LeaveApplicationModel.fromJson(e.data()))
          .toList();
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }

    return [];
  }
}
