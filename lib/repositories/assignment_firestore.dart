import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:online_college/consts/utils.dart';
import 'package:online_college/model/assignment_model.dart';

class AssignmentFireStore {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addAssignmentToFireStore(
      {required BuildContext context, required AssignmentModel assignmentModel}) async {
    try {
      await firestore
          .collection('assignments')
          .doc(assignmentModel.aid)
          .set(assignmentModel.toJson());

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Assignment Added');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<void> addStudentToFireStoreAssignmentList(
      {required BuildContext context,
      required Submitted submitted,
      required AssignmentModel assignmentModel}) async {
    try {
      Submitted data = submitted;

      assignmentModel.submitted.add(data);

      await firestore
          .collection('assignments')
          .doc(assignmentModel.aid)
          .update(assignmentModel.toJson());

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Assignment Submitted');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<void> updateAssignmentAtFireStore(
      {required BuildContext context, required AssignmentModel assignmentModel}) async {
    try {
      await firestore
          .collection('assignments')
          .doc(assignmentModel.aid)
          .update(assignmentModel.toJson());

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Assignment Edited');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<void> deleteAssignmentFromFireStore(
      {required BuildContext context, required String aid}) async {
    try {
      await firestore.collection('assignments').doc(aid).delete();

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Assignment Deleted');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<List<AssignmentModel>> getAssignmentListFromFireStore(
      {required BuildContext context}) async {
    try {
      return (await firestore.collection('assignments').get())
          .docs
          .map((e) => AssignmentModel.fromJson(e.data()))
          .toList();
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }

    return [];
  }

  Future<AssignmentModel?> getAssignmentFromFireStore(
      {required BuildContext context, required String aid}) async {
    try {
      return AssignmentModel.fromJson(
          (await firestore.collection('assignments').doc(aid).get()).data()!);
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }

    return null;
  }

  Future<String?> uploadFile({
    required BuildContext context,
    required PlatformFile pickedFile,
    required String aid,
  }) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('assignments/$aid/${pickedFile.name}');
      UploadTask upload = ref.putFile(File(pickedFile.path!));

      final snapshot = await upload.whenComplete(() {});
      final url = await snapshot.ref.getDownloadURL();

      if (url.isNotEmpty) {
        return url;
      }
    } catch (e) {
      if (!context.mounted) return null;
      Utils().showToast(context: context, message: e.toString());
    }

    return null;
  }
}
