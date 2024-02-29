import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:online_college/consts/utils.dart';
import 'package:online_college/model/meeting_model.dart';

class MeetingFireStore {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addMeetingToFireStore(
      {required BuildContext context, required MeetingModel meetingModel}) async {
    try {
      await firestore.collection('meetings').doc(meetingModel.mid).set(meetingModel.toJson());

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Meeting Added');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<void> updateMeetingAtFireStore(
      {required BuildContext context, required MeetingModel meetingModel}) async {
    try {
      await firestore.collection('meetings').doc(meetingModel.mid).update(meetingModel.toJson());

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Meeting Edited');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<void> deleteMeetingFromFireStore(
      {required BuildContext context, required String mid}) async {
    try {
      await firestore.collection('meetings').doc(mid).delete();

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Meeting Deleted');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<List<MeetingModel>> getMeetingListFromFireStore({required BuildContext context}) async {
    try {
      return (await firestore.collection('meetings').get())
          .docs
          .map((e) => MeetingModel.fromJson(e.data()))
          .toList();
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }

    return [];
  }

  Future<MeetingModel?> getMeetingFromFireStore(
      {required BuildContext context, required String mid}) async {
    try {
      return MeetingModel.fromJson((await firestore.collection('meetings').doc(mid).get()).data()!);
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }

    return null;
  }

  Future<String> generateToken({
    required BuildContext context,
    required String channelName,
    required DateTime time,
  }) async {
    try {
      int expirationTime =
          (time.add(const Duration(hours: 3))).difference(DateTime.now()).inSeconds;

      final response = await http.get(Uri.parse(
        'https://agora-token-1db4.onrender.com/access_token?channelName=$channelName&uid=0&role=publisher&expirationTime=$expirationTime',
      ));

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        return data['token'].toString();
      }
    } catch (e) {
      if (!context.mounted) return '';
      Utils().showToast(context: context, message: e.toString());
    }

    return '';
  }
}
