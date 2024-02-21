import 'package:flutter/material.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/model/assignment_model.dart';
import 'package:online_college/providers/all_user_provider.dart';
import 'package:online_college/repositories/assignment_firestore.dart';
import 'package:online_college/repositories/notifications.dart';
import 'package:provider/provider.dart';

class AssignmentProvider extends ChangeNotifier {
  List<AssignmentModel> _assignmentList = [];

  List<AssignmentModel> get assignmentList => _assignmentList;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  setIsLoading({required bool loading}) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> addAssignment(
      {required BuildContext context, required AssignmentModel assignmentModel}) async {
    await AssignmentFireStore()
        .addAssignmentToFireStore(context: context, assignmentModel: assignmentModel);

    List<String> tokens = [];

    if (!context.mounted) return;
    Provider.of<AllUserProvider>(context, listen: false).studentsList.forEach((element) {
      if (assignmentModel.year == element.year && element.notificationToken != "") {
        tokens.add(element.notificationToken);
      }
    });

    NotificationServices().sendNotification(
      title: 'About Fee',
      message:
          'Reminder: You have an assignment due for ${assignmentModel.subject}. Please ensure it\'s completed by ${assignmentModel.lastDateTime}.',
      tokens: tokens,
      page: 'assignments',
    );

    if (!context.mounted) return;
    await getAssignmentList(context: context);
  }

  Future<void> addStudentInAssignmentList(
      {required BuildContext context,
      required Submitted submitted,
      required AssignmentModel assignmentModel}) async {
    await AssignmentFireStore().addStudentToFireStoreAssignmentList(
        context: context, assignmentModel: assignmentModel, submitted: submitted);

    if (!context.mounted) return;
    await getAssignmentList(context: context);
  }

  Future<void> updateAssignment(
      {required BuildContext context, required AssignmentModel assignmentModel}) async {
    await AssignmentFireStore()
        .updateAssignmentAtFireStore(context: context, assignmentModel: assignmentModel);

    if (!context.mounted) return;
    await getAssignmentList(context: context);
  }

  Future<void> deleteAssignment({required BuildContext context, required String aid}) async {
    await AssignmentFireStore().deleteAssignmentFromFireStore(context: context, aid: aid);

    if (!context.mounted) return;
    await getAssignmentList(context: context);
  }

  Future<void> getAssignmentList({required BuildContext context}) async {
    _assignmentList = [];
    _isLoading = true;
    notifyListeners();

    List<AssignmentModel> response =
        await AssignmentFireStore().getAssignmentListFromFireStore(context: context);

    if (response.isNotEmpty) {
      _assignmentList = response;
    }

    _isLoading = false;
    notifyListeners();
  }

  bool checkStudentInList({required AssignmentModel assignment}) {
    for (var element in assignment.submitted) {
      if (element.sid == UserSharedPreferences.id) {
        return true;
      }
    }

    return false;
  }
}
