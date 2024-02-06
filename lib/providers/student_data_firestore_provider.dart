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

  Future<void> getStudentData() async {
    _studentData = await UserDataFireStore().getStudentData();
  }

  Future<void> uploadProfilePhoto({required PlatformFile pickedFile}) async {
    _photoUrl = await UserDataFireStore().uploadProfilePhoto(pickedFile: pickedFile);
  }

  Future<void> updateStudentName({required String name}) =>
      UserDataFireStore().updateUser(title: 'name', data: name);

  Future<void> updateStudentRole({required String role}) =>
      UserDataFireStore().updateUser(title: 'role', data: role);

  Future<void> updateStudentAdhar({required String adhar}) =>
      UserDataFireStore().updateUser(title: 'adhar', data: adhar);

  Future<void> updateStudentDateOfBirth({required String dateOfBirth}) =>
      UserDataFireStore().updateUser(title: 'dateOfBirth', data: dateOfBirth);

  Future<void> updateStudentEmail({required String email}) =>
      UserDataFireStore().updateUser(title: 'email', data: email);

  Future<void> updateStudentYear({required String year}) =>
      UserDataFireStore().updateUser(title: 'year', data: year);

  Future<void> updateStudentRollNo({required String rollNo}) =>
      UserDataFireStore().updateUser(title: 'rollNo', data: rollNo);

  Future<void> updateStudentMotherName({required String motherName}) =>
      UserDataFireStore().updateUser(title: 'motherName', data: motherName);

  Future<void> updateStudentFatherName({required String fatherName}) =>
      UserDataFireStore().updateUser(title: 'fatherName', data: fatherName);

  Future<void> updateStudentAddress({required String address}) =>
      UserDataFireStore().updateUser(title: 'address', data: address);

  Future<void> updateStudentPhotoUrl({required String photoUrl}) =>
      UserDataFireStore().updateUser(title: 'photoUrl', data: photoUrl);
}
