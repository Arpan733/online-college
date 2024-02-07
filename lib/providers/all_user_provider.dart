import 'package:flutter/cupertino.dart';
import 'package:online_college/repositories/all_user_firestore.dart';

import '../model/student_user_model.dart';
import '../model/teacher_user_model.dart';

class AllUserProvider extends ChangeNotifier {
  List<TeacherUserModel> _teachersList = [];

  List<TeacherUserModel> get teachersList => _teachersList;

  List<StudentUserModel> _studentsList = [];

  List<StudentUserModel> get studentsList => _studentsList;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> getAllUser() async {
    _isLoading = true;
    _studentsList = [];
    _teachersList = [];
    notifyListeners();

    List<Map<String, dynamic>> data = await AllUserFireStore().getAllUser();

    if (data.isNotEmpty) {
      for (var element in data) {
        if (element['role'] == 'teacher') {
          _teachersList.add(TeacherUserModel.fromJson(element));
        } else if (element['role'] == 'student') {
          _studentsList.add(StudentUserModel.fromJson(element));
        }
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addStudentUser({required StudentUserModel studentUserModel}) async {
    await AllUserFireStore().addStudentUser(studentUserModel: studentUserModel);
    await getAllUser();
  }

  Future<void> addTeacherUser({required TeacherUserModel teacherUserModel}) async {
    await AllUserFireStore().addTeacherUser(teacherUserModel: teacherUserModel);
    await getAllUser();
  }
}
