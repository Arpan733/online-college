import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:online_college/consts/utils.dart';
import 'package:online_college/model/school_gallery_model.dart';

class SchoolGalleryFireStore {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addSchoolGalleryToFireStore(
      {required BuildContext context, required SchoolGalleryModel schoolGalleryModel}) async {
    try {
      await firestore
          .collection('schoolGallery')
          .doc(schoolGalleryModel.sgid)
          .set(schoolGalleryModel.toJson());

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Photos Uploaded');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<void> updateSchoolGalleryAtFireStore(
      {required BuildContext context, required SchoolGalleryModel schoolGalleryModel}) async {
    try {
      await firestore
          .collection('schoolGallery')
          .doc(schoolGalleryModel.sgid)
          .update(schoolGalleryModel.toJson());
    } catch (e) {
      if (!context.mounted) return;
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<void> deleteSchoolGalleryFromFireStore(
      {required BuildContext context, required String sgid}) async {
    try {
      await firestore.collection('schoolGallery').doc(sgid).delete();

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Photo Deleted');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<List<SchoolGalleryModel>> getSchoolGalleryListFromFireStore(
      {required BuildContext context}) async {
    try {
      return (await firestore.collection('schoolGallery').get())
          .docs
          .map((e) => SchoolGalleryModel.fromJson(e.data()))
          .toList();
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }

    return [];
  }

  Future<String?> uploadFile({
    required BuildContext context,
    required PlatformFile pickedFile,
    required String sgid,
  }) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('school-gallery/$sgid/${pickedFile.name}');
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
