import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_college/consts/utils.dart';
import 'package:online_college/model/student_user_model.dart';

import '../model/teacher_user_model.dart';

class AllUserFireStore {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getAllUser({required BuildContext context}) async {
    try {
      return (await firestore.collection('users').get()).docs.map((e) => e.data()).toList();
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }

    return [];
  }

  Future<void> deleteUserFromFireStore({required BuildContext context, required String id}) async {
    try {
      await firestore.collection('users').doc(id).delete();

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'User Deleted');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<void> addStudentUser(
      {required BuildContext context, required StudentUserModel studentUserModel}) async {
    try {
      await firestore.collection('users').doc(studentUserModel.id).set(studentUserModel.toJson());

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Student Added');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<void> addTeacherUser(
      {required BuildContext context, required TeacherUserModel teacherUserModel}) async {
    try {
      await firestore.collection('users').doc(teacherUserModel.id).set(teacherUserModel.toJson());

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Teacher Added');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }
}
