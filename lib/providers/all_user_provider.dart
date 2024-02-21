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

  Future<void> getAllUser({required BuildContext context}) async {
    _isLoading = true;
    _studentsList = [];
    _teachersList = [];
    notifyListeners();

    List<Map<String, dynamic>> data = await AllUserFireStore().getAllUser(context: context);

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

  Future<void> addStudentUser(
      {required BuildContext context, required StudentUserModel studentUserModel}) async {
    await AllUserFireStore().addStudentUser(context: context, studentUserModel: studentUserModel);

    if (!context.mounted) return;
    await getAllUser(context: context);
  }

  Future<void> addTeacherUser(
      {required BuildContext context, required TeacherUserModel teacherUserModel}) async {
    await AllUserFireStore().addTeacherUser(context: context, teacherUserModel: teacherUserModel);

    if (!context.mounted) return;
    await getAllUser(context: context);
  }
}
