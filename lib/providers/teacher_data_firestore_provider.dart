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

  Future<void> getTeacherData({required String id}) async {
    _teacherData = await UserDataFireStore().getTeacherData(id: id);
  }

  Future<void> uploadProfilePhoto({required PlatformFile pickedFile}) async {
    _photoUrl = await UserDataFireStore().uploadProfilePhoto(pickedFile: pickedFile);
  }

  Future<void> updateTeacherName({required String name, required String id}) =>
      UserDataFireStore().updateUser(title: 'name', data: name, id: id);

  Future<void> updateTeacherUid({required String uid, required String id}) =>
      UserDataFireStore().updateUser(title: 'uid', data: uid, id: id);

  Future<void> updateTeacherRole({required String role, required String id}) =>
      UserDataFireStore().updateUser(title: 'role', data: role, id: id);

  Future<void> updateTeacherAdhar({required String adhar, required String id}) =>
      UserDataFireStore().updateUser(title: 'adhar', data: adhar, id: id);

  Future<void> updateTeacherDateOfBirth({required String dateOfBirth, required String id}) =>
      UserDataFireStore().updateUser(title: 'dateOfBirth', data: dateOfBirth, id: id);

  Future<void> updateTeacherEmail({required String email, required String id}) =>
      UserDataFireStore().updateUser(title: 'email', data: email, id: id);

  Future<void> updateTeacherQualification({required String qualification, required String id}) =>
      UserDataFireStore().updateUser(title: 'qualification', data: qualification, id: id);

  Future<void> updateTeacherAddress({required String address, required String id}) =>
      UserDataFireStore().updateUser(title: 'address', data: address, id: id);

  Future<void> updateTeacherPhotoUrl({required String photoUrl, required String id}) =>
      UserDataFireStore().updateUser(title: 'photoUrl', data: photoUrl, id: id);
}
