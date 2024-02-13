import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../consts/utils.dart';
import '../model/doubt_model.dart';

class DoubtFireStore {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addDoubtToFireStore(
      {required BuildContext context, required DoubtModel doubtModel}) async {
    try {
      await firestore.collection('doubts').doc(doubtModel.did).set(doubtModel.toJson());

      Utils().showToast(context: context, message: 'Doubt Created');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<void> updateDoubtAtFireStore(
      {required BuildContext context, required DoubtModel doubtModel}) async {
    try {
      await firestore.collection('doubts').doc(doubtModel.did).update(doubtModel.toJson());
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<void> deleteDoubtFromFireStore(
      {required BuildContext context, required String sid}) async {
    try {
      await firestore.collection('doubts').doc(sid).delete();

      Utils().showToast(context: context, message: 'Doubt Deleted');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<List<DoubtModel>> getDoubtListFromFireStore({required BuildContext context}) async {
    try {
      return (await firestore.collection('doubts').get())
          .docs
          .map((e) => DoubtModel.fromJson(e.data()))
          .toList();
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }

    return [];
  }

  Future<DoubtModel?> getDoubtFromFireStore(
      {required BuildContext context, required String did}) async {
    try {
      return DoubtModel.fromJson((await firestore.collection('doubts').doc(did).get()).data()!);
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }

    return null;
  }

  Future<String?> uploadFile(
      {required BuildContext context,
      required PlatformFile pickedFile,
      required String did,
      required String time}) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('doubts/$did/$time/${pickedFile.name}');
      UploadTask upload = ref.putFile(File(pickedFile.path!));

      final snapshot = await upload.whenComplete(() {});
      final url = await snapshot.ref.getDownloadURL();

      if (url.isNotEmpty) {
        return url;
      }
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }

    return null;
  }
}
