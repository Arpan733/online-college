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

  Future<void> getStudentData({required String id}) async {
    _studentData = await UserDataFireStore().getStudentData(id: id);
  }

  Future<void> uploadProfilePhoto({required PlatformFile pickedFile}) async {
    _photoUrl = await UserDataFireStore().uploadProfilePhoto(pickedFile: pickedFile);
  }

  Future<void> updateStudentName({required String name, required String id}) =>
      UserDataFireStore().updateUser(title: 'name', data: name, id: id);

  Future<void> updateStudentRole({required String role, required String id}) =>
      UserDataFireStore().updateUser(title: 'role', data: role, id: id);

  Future<void> updateStudentUid({required String uid, required String id}) =>
      UserDataFireStore().updateUser(title: 'uid', data: uid, id: id);

  Future<void> updateStudentAdhar({required String adhar, required String id}) =>
      UserDataFireStore().updateUser(title: 'adhar', data: adhar, id: id);

  Future<void> updateStudentDateOfBirth({required String dateOfBirth, required String id}) =>
      UserDataFireStore().updateUser(title: 'dateOfBirth', data: dateOfBirth, id: id);

  Future<void> updateStudentEmail({required String email, required String id}) =>
      UserDataFireStore().updateUser(title: 'email', data: email, id: id);

  Future<void> updateStudentYear({required String year, required String id}) =>
      UserDataFireStore().updateUser(title: 'year', data: year, id: id);

  Future<void> updateStudentRollNo({required String rollNo, required String id}) =>
      UserDataFireStore().updateUser(title: 'rollNo', data: rollNo, id: id);

  Future<void> updateStudentMotherName({required String motherName, required String id}) =>
      UserDataFireStore().updateUser(title: 'motherName', data: motherName, id: id);

  Future<void> updateStudentFatherName({required String fatherName, required String id}) =>
      UserDataFireStore().updateUser(title: 'fatherName', data: fatherName, id: id);

  Future<void> updateStudentAddress({required String address, required String id}) =>
      UserDataFireStore().updateUser(title: 'address', data: address, id: id);

  Future<void> updateStudentPhotoUrl({required String photoUrl, required String id}) =>
      UserDataFireStore().updateUser(title: 'photoUrl', data: photoUrl, id: id);
}
