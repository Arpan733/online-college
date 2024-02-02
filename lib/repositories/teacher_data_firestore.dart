import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../consts/utils.dart';

class TeacherDataFireStore {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> updateTeacher(
      {required String title, required String data}) async {
    try {
      Map<String, String> userdata = {
        title: data,
      };

      await firestore.collection('users').doc(user?.uid).update(userdata);
    } catch (e) {
      Utils().showToast(e.toString());
    }
  }

  Future<Map<String, dynamic>?> getTeacherData() async {
    try {
      DocumentSnapshot snapshot =
          await firestore.collection("user").doc(user?.uid).get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        return data;
      }
    } catch (e) {
      Utils().showToast(e.toString());
    }

    return null;
  }

  Future<String?> uploadProfilePhoto({required PlatformFile pickedFile}) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('${user?.uid}/${pickedFile.name}');
      UploadTask upload = ref.putFile(File(pickedFile.path!));

      final snapshot = await upload.whenComplete(() {});
      final url = await snapshot.ref.getDownloadURL();
      user?.updatePhotoURL(url.toString());

      if (url.isNotEmpty) {
        return url;
      }
    } catch (e) {
      Utils().showToast(e.toString());
    }

    return null;
  }
}
