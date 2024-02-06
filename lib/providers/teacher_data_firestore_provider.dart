import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:online_college/repositories/teacher_data_firestore.dart';

import '../model/user_model.dart';

class TeacherDataFireStoreProvider extends ChangeNotifier {
  UserModel? _teacherData;

  UserModel? get teacherData => _teacherData;

  String? _photoUrl;

  String? get photoUrl => _photoUrl;

  User? user = FirebaseAuth.instance.currentUser;

  Future<void> makeTeacher() async {
    TeacherDataFireStore().updateTeacher(
        title: 'phoneNumber', data: user?.phoneNumber.toString() ?? '');
    TeacherDataFireStore()
        .updateTeacher(title: 'uid', data: user?.uid.toString() ?? '');
  }

  Future<void> getTeacherData() async {
    _teacherData = await TeacherDataFireStore().getTeacherData();
  }

  Future<void> uploadProfilePhoto({required PlatformFile pickedFile}) async {
    _photoUrl =
        await TeacherDataFireStore().uploadProfilePhoto(pickedFile: pickedFile);
  }

  Future<void> updateTeacherName({required String name}) =>
      TeacherDataFireStore().updateTeacher(title: 'name', data: name);

  Future<void> updateTeacherAdhar({required String adhar}) =>
      TeacherDataFireStore().updateTeacher(title: 'adhar', data: adhar);

  Future<void> updateTeacherDateOfBirth({required String dateOfBirth}) =>
      TeacherDataFireStore()
          .updateTeacher(title: 'dateOfBirth', data: dateOfBirth);

  Future<void> updateTeacherEmail({required String email}) =>
      TeacherDataFireStore().updateTeacher(title: 'email', data: email);

  Future<void> updateTeacherQualification({required String qualification}) =>
      TeacherDataFireStore()
          .updateTeacher(title: 'qualification', data: qualification);

  Future<void> updateTeacherAddress({required String address}) =>
      TeacherDataFireStore().updateTeacher(title: 'address', data: address);

  Future<void> updateTeacherPhotoUrl({required String photoUrl}) =>
      TeacherDataFireStore().updateTeacher(title: 'photoUrl', data: photoUrl);
}
