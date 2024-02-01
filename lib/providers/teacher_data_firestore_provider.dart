import 'package:flutter/cupertino.dart';
import 'package:online_college/repositories/teacher_data_firestore.dart';

class TeacherDataFireStoreProvider extends ChangeNotifier {
  Map<String, dynamic>? _teacherData;
  Map<String, dynamic>? get teacherData => _teacherData;

  Future<void> makeTeacher(
      {required String phoneNumber, required String uid}) async {
    TeacherDataFireStore().createTeacher(phoneNumber: phoneNumber, uid: uid);
  }

  Future<void> getTeacherData({required String uid}) async {
    _teacherData = await TeacherDataFireStore().getTeacherData(uid: uid);
  }
}
