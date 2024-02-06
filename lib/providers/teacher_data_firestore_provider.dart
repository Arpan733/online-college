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

  Future<void> getTeacherData() async {
    _teacherData = await UserDataFireStore().getTeacherData();
  }

  Future<void> uploadProfilePhoto({required PlatformFile pickedFile}) async {
    _photoUrl = await UserDataFireStore().uploadProfilePhoto(pickedFile: pickedFile);
  }

  Future<void> updateTeacherName({required String name}) =>
      UserDataFireStore().updateUser(title: 'name', data: name);

  Future<void> updateTeacherRole({required String role}) =>
      UserDataFireStore().updateUser(title: 'role', data: role);

  Future<void> updateTeacherAdhar({required String adhar}) =>
      UserDataFireStore().updateUser(title: 'adhar', data: adhar);

  Future<void> updateTeacherDateOfBirth({required String dateOfBirth}) =>
      UserDataFireStore().updateUser(title: 'dateOfBirth', data: dateOfBirth);

  Future<void> updateTeacherEmail({required String email}) =>
      UserDataFireStore().updateUser(title: 'email', data: email);

  Future<void> updateTeacherQualification({required String qualification}) =>
      UserDataFireStore().updateUser(title: 'qualification', data: qualification);

  Future<void> updateTeacherAddress({required String address}) =>
      UserDataFireStore().updateUser(title: 'address', data: address);

  Future<void> updateTeacherPhotoUrl({required String photoUrl}) =>
      UserDataFireStore().updateUser(title: 'photoUrl', data: photoUrl);
}
