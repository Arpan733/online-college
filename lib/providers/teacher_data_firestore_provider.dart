import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:online_college/repositories/user_data_firestore.dart';

import '../model/teacher_user_model.dart';

class TeacherDataFireStoreProvider extends ChangeNotifier {
  TeacherUserModel? _teacherData;

  TeacherUserModel? get teacherData => _teacherData;

  String? _photoUrl;

  String? get photoUrl => _photoUrl;

  User? user = FirebaseAuth.instance.currentUser;

  Future<void> getTeacherData({required BuildContext context, required String id}) async {
    _teacherData = await UserDataFireStore().getTeacherData(context: context, id: id);
  }

  Future<void> uploadProfilePhoto(
      {required BuildContext context, required PlatformFile pickedFile}) async {
    _photoUrl =
        await UserDataFireStore().uploadProfilePhoto(context: context, pickedFile: pickedFile);
  }

  Future<void> updateTeacherName(
          {required BuildContext context, required String name, required String id}) =>
      UserDataFireStore().updateUser(context: context, title: 'name', data: name, id: id);

  Future<void> updateTeacherUid(
          {required BuildContext context, required String uid, required String id}) =>
      UserDataFireStore().updateUser(context: context, title: 'uid', data: uid, id: id);

  Future<void> updateTeacherRole(
          {required BuildContext context, required String role, required String id}) =>
      UserDataFireStore().updateUser(context: context, title: 'role', data: role, id: id);

  Future<void> updateTeacherAdhar(
          {required BuildContext context, required String adhar, required String id}) =>
      UserDataFireStore().updateUser(context: context, title: 'adhar', data: adhar, id: id);

  Future<void> updateTeacherDateOfBirth(
          {required BuildContext context, required String dateOfBirth, required String id}) =>
      UserDataFireStore()
          .updateUser(context: context, title: 'dateOfBirth', data: dateOfBirth, id: id);

  Future<void> updateTeacherEmail(
          {required BuildContext context, required String email, required String id}) =>
      UserDataFireStore().updateUser(context: context, title: 'email', data: email, id: id);

  Future<void> updateTeacherQualification(
          {required BuildContext context, required String qualification, required String id}) =>
      UserDataFireStore()
          .updateUser(context: context, title: 'qualification', data: qualification, id: id);

  Future<void> updateTeacherAddress(
          {required BuildContext context, required String address, required String id}) =>
      UserDataFireStore().updateUser(context: context, title: 'address', data: address, id: id);

  Future<void> updateTeacherPhotoUrl(
          {required BuildContext context, required String photoUrl, required String id}) =>
      UserDataFireStore().updateUser(context: context, title: 'photoUrl', data: photoUrl, id: id);
}
