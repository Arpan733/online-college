import 'package:flutter/cupertino.dart';
import 'package:online_college/repositories/teacher_data_firestore.dart';

class TeacherDataProvider extends ChangeNotifier {
  Future<void> makeUser(
      {required String phoneNumber, required String uid}) async {
    TeacherDataFireStore().createTeacher(phoneNumber: phoneNumber, uid: uid);
  }
}
