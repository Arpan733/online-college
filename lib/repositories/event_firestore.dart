import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:online_college/consts/utils.dart';
import 'package:online_college/model/event_model.dart';

class EventFireStore {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addEventToFireStore(
      {required BuildContext context, required EventModel eventModel}) async {
    try {
      await firestore.collection('events').doc(eventModel.eid).set(eventModel.toJson());

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Event Added');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<void> updateEventAtFireStore(
      {required BuildContext context, required EventModel eventModel}) async {
    try {
      await firestore.collection('events').doc(eventModel.eid).update(eventModel.toJson());

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Event Edited');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<void> deleteEventFromFireStore(
      {required BuildContext context, required String eid}) async {
    try {
      await firestore.collection('events').doc(eid).delete();

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Event Deleted');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<List<EventModel>> getEventListFromFireStore({required BuildContext context}) async {
    try {
      return (await firestore.collection('events').get())
          .docs
          .map((e) => EventModel.fromJson(e.data()))
          .toList();
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }

    return [];
  }

  Future<EventModel?> getEventFromFireStore(
      {required BuildContext context, required String eid}) async {
    try {
      return EventModel.fromJson((await firestore.collection('events').doc(eid).get()).data()!);
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }

    return null;
  }

  Future<String?> uploadFile({
    required BuildContext context,
    required PlatformFile pickedFile,
    required String eid,
  }) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('events/$eid/${pickedFile.name}');
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
