import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:online_college/model/student_user_model.dart';
import 'package:online_college/repositories/user_data_firestore.dart';

class StudentDataFireStoreProvider extends ChangeNotifier {
  StudentUserModel? _studentData;

  StudentUserModel? get studentData => _studentData;

  String? _photoUrl;

  String? get photoUrl => _photoUrl;

  User? user = FirebaseAuth.instance.currentUser;

  Future<void> getStudentData({required BuildContext context, required String id}) async {
    _studentData = await UserDataFireStore().getStudentData(context: context, id: id);
  }

  Future<void> uploadProfilePhoto(
      {required BuildContext context, required PlatformFile pickedFile}) async {
    _photoUrl =
        await UserDataFireStore().uploadProfilePhoto(context: context, pickedFile: pickedFile);
  }

  Future<void> updateStudentName(
          {required BuildContext context, required String name, required String id}) =>
      UserDataFireStore().updateUser(context: context, title: 'name', data: name, id: id);

  Future<void> updateStudentRole(
          {required BuildContext context, required String role, required String id}) =>
      UserDataFireStore().updateUser(context: context, title: 'role', data: role, id: id);

  Future<void> updateStudentUid(
          {required BuildContext context, required String uid, required String id}) =>
      UserDataFireStore().updateUser(context: context, title: 'uid', data: uid, id: id);

  Future<void> updateStudentAdhar(
          {required BuildContext context, required String adhar, required String id}) =>
      UserDataFireStore().updateUser(context: context, title: 'adhar', data: adhar, id: id);

  Future<void> updateStudentDateOfBirth(
          {required BuildContext context, required String dateOfBirth, required String id}) =>
      UserDataFireStore()
          .updateUser(context: context, title: 'dateOfBirth', data: dateOfBirth, id: id);

  Future<void> updateStudentEmail(
          {required BuildContext context, required String email, required String id}) =>
      UserDataFireStore().updateUser(context: context, title: 'email', data: email, id: id);

  Future<void> updateStudentYear(
          {required BuildContext context, required String year, required String id}) =>
      UserDataFireStore().updateUser(context: context, title: 'year', data: year, id: id);

  Future<void> updateStudentRollNo(
          {required BuildContext context, required String rollNo, required String id}) =>
      UserDataFireStore().updateUser(context: context, title: 'rollNo', data: rollNo, id: id);

  Future<void> updateStudentMotherName(
          {required BuildContext context, required String motherName, required String id}) =>
      UserDataFireStore()
          .updateUser(context: context, title: 'motherName', data: motherName, id: id);

  Future<void> updateStudentFatherName(
          {required BuildContext context, required String fatherName, required String id}) =>
      UserDataFireStore()
          .updateUser(context: context, title: 'fatherName', data: fatherName, id: id);

  Future<void> updateStudentAddress(
          {required BuildContext context, required String address, required String id}) =>
      UserDataFireStore().updateUser(context: context, title: 'address', data: address, id: id);

  Future<void> updateStudentPhotoUrl(
          {required BuildContext context, required String photoUrl, required String id}) =>
      UserDataFireStore().updateUser(context: context, title: 'photoUrl', data: photoUrl, id: id);

  Future<void> updateStudentNotificationToken(
          {required BuildContext context, required String notificationToken, required String id}) =>
      UserDataFireStore().updateUser(
          context: context, title: 'notificationToken', data: notificationToken, id: id);

  Future<void> updateStudentLoginTime(
          {required BuildContext context, required String loginTime, required String id}) =>
      UserDataFireStore().updateUser(context: context, title: 'loginTime', data: loginTime, id: id);
}
