import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/model/student_user_model.dart';

import '../consts/utils.dart';
import '../model/teacher_user_model.dart';

class UserDataFireStore {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> updateUser(
      {required BuildContext context,
      required String title,
      required data,
      required String id}) async {
    try {
      Map<String, dynamic> userdata = {
        title: data,
      };

      await firestore.collection('users').doc(id).update(userdata);
    } catch (e) {
      if (!context.mounted) return;
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<TeacherUserModel?> getTeacherData(
      {required BuildContext context, required String id}) async {
    try {
      DocumentSnapshot snapshot = await firestore.collection("users").doc(id).get();

      if (snapshot.exists) {
        TeacherUserModel? data = TeacherUserModel.fromJson(snapshot.data() as Map<String, dynamic>);

        return data;
      }
    } catch (e) {
      if (!context.mounted) return null;
      Utils().showToast(context: context, message: e.toString());
    }

    return null;
  }

  Future<StudentUserModel?> getStudentData(
      {required BuildContext context, required String id}) async {
    try {
      DocumentSnapshot snapshot = await firestore.collection("users").doc(id).get();

      if (snapshot.exists) {
        StudentUserModel? data = StudentUserModel.fromJson(snapshot.data() as Map<String, dynamic>);

        return data;
      }
    } catch (e) {
      if (!context.mounted) return null;
      Utils().showToast(context: context, message: e.toString());
    }

    return null;
  }

  Future<String?> uploadProfilePhoto(
      {required BuildContext context, required PlatformFile pickedFile}) async {
    try {
      final folderRef = FirebaseStorage.instance.ref().child(UserSharedPreferences.id);

      final items = await folderRef.listAll();

      await Future.forEach(items.items, (Reference ref) async {
        await ref.delete();
      });

      final ref =
          FirebaseStorage.instance.ref().child('${UserSharedPreferences.id}/${pickedFile.name}');
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
