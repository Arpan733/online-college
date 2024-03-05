import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../consts/utils.dart';
import '../model/material_model.dart';

class MaterialFireStore {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addMaterialToFireStore(
      {required BuildContext context, required MaterialModel materialModel}) async {
    try {
      await firestore.collection('materials').doc(materialModel.mid).set(materialModel.toJson());

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Materials Uploaded');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<void> updateMaterialAtFireStore(
      {required BuildContext context, required MaterialModel materialModel}) async {
    try {
      await firestore.collection('materials').doc(materialModel.mid).update(materialModel.toJson());

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Materials Updated');
    } catch (e) {
      if (!context.mounted) return;
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<void> deleteMaterialFromFireStore(
      {required BuildContext context, required String mid}) async {
    try {
      await firestore.collection('materials').doc(mid).delete();

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Materials Deleted');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<List<MaterialModel>> getMaterialListFromFireStore({required BuildContext context}) async {
    try {
      return (await firestore.collection('materials').get())
          .docs
          .map((e) => MaterialModel.fromJson(e.data()))
          .toList();
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }

    return [];
  }

  Future<MaterialModel?> getMaterialFromFireStore(
      {required BuildContext context, required String mid}) async {
    try {
      return MaterialModel.fromJson(
          (await firestore.collection('materials').doc(mid).get()).data()!);
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }

    return null;
  }

  Future<String?> uploadFile({
    required BuildContext context,
    required PlatformFile pickedFile,
    required String mid,
  }) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('materials/$mid/${pickedFile.name}');
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

  Future<void> deleteFiles({required BuildContext context, required String mid}) async {
    try {
      final folderRef = FirebaseStorage.instance.ref().child('materials/$mid');

      final items = await folderRef.listAll();

      await Future.forEach(items.items, (Reference ref) async {
        await ref.delete();
      });
    } catch (e) {
      if (!context.mounted) return;
      Utils().showToast(context: context, message: e.toString());
    }
  }
}
