import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:online_college/consts/utils.dart';
import 'package:online_college/model/notice_model.dart';

class NoticeFireStore {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addNoticeToFireStore(
      {required BuildContext context, required NoticeModel noticeModel}) async {
    try {
      await firestore.collection('notices').doc(noticeModel.nid).set(noticeModel.toJson());

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Notice Added');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<void> updateNoticeAtFireStore(
      {required BuildContext context, required NoticeModel noticeModel}) async {
    try {
      await firestore.collection('notices').doc(noticeModel.nid).update(noticeModel.toJson());

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Notice Edited');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<void> deleteNoticeFromFireStore(
      {required BuildContext context, required String nid}) async {
    try {
      await firestore.collection('notices').doc(nid).delete();

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Notice Deleted');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<List<NoticeModel>> getNoticeListFromFireStore({required BuildContext context}) async {
    try {
      return (await firestore.collection('notices').get())
          .docs
          .map((e) => NoticeModel.fromJson(e.data()))
          .toList();
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }

    return [];
  }

  Future<NoticeModel?> getNoticeFromFireStore(
      {required BuildContext context, required String nid}) async {
    try {
      return NoticeModel.fromJson((await firestore.collection('notices').doc(nid).get()).data()!);
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }

    return null;
  }

  Future<String?> uploadFile({
    required BuildContext context,
    required PlatformFile pickedFile,
    required String nid,
  }) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('notices/$nid/${pickedFile.name}');
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
