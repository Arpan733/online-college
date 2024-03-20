import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/model/assignment_model.dart';
import 'package:online_college/providers/all_user_provider.dart';
import 'package:online_college/repositories/assignment_firestore.dart';
import 'package:online_college/repositories/notifications.dart';
import 'package:online_college/widgets/dialog_for_assignment.dart';
import 'package:provider/provider.dart';

class AssignmentProvider extends ChangeNotifier {
  List<AssignmentModel> _assignmentList = [];

  List<AssignmentModel> get assignmentList => _assignmentList;

  AssignmentModel _assignment = AssignmentModel(
    aid: 'aid',
    title: 'title',
    year: 'year',
    submitted: [],
    lastDateTime: '',
    createdDateTime: '',
    subject: '',
  );

  AssignmentModel get assignment => _assignment;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  setIsLoading({required bool loading}) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> addAssignment(
      {required BuildContext context, required AssignmentModel assignmentModel}) async {
    List<String> tokens = [];

    if (!context.mounted) return;
    Provider.of<AllUserProvider>(context, listen: false).studentsList.forEach((element) {
      if (assignmentModel.year == element.year && element.notificationToken != "") {
        tokens.add(element.notificationToken);
      }
    });

    NotificationServices().sendNotification(
      title: 'Assignment assigned',
      message:
          'Reminder: You have an assignment due for ${assignmentModel.subject}. Please ensure it\'s completed by ${DateFormat('dd/MM/yyyy').format(DateTime.parse(assignmentModel.lastDateTime))}.',
      tokens: tokens,
      pd: {'page': 'assignments'},
    );

    await AssignmentFireStore()
        .addAssignmentToFireStore(context: context, assignmentModel: assignmentModel);

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

  Future<void> getAssignment({required BuildContext context, required String aid}) async {
    _assignment = AssignmentModel(
        aid: 'aid',
        title: 'title',
        year: 'year',
        submitted: [],
        lastDateTime: '',
        createdDateTime: '',
        subject: '');
    _isLoading = true;
    notifyListeners();

    AssignmentModel? response =
        await AssignmentFireStore().getAssignmentFromFireStore(context: context, aid: aid);

    if (response != null) {
      _assignment = response;
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

  Future<void> checkRemainingSubmission({required BuildContext context}) async {
    await getAssignmentList(context: context);

    for (var element in assignmentList) {
      if (DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 1))) ==
              DateFormat('yyyy-MM-dd').format(DateTime.parse(element.lastDateTime)) &&
          element.year == UserSharedPreferences.year) {
        if (!checkStudentInList(assignment: element)) {
          if (!context.mounted) return;
          await showDialogForAssignment(
              context: context, assignmentModel: element, time: 'Tomorrow');
        }
      }

      if (DateFormat('yyyy-MM-dd').format(DateTime.now()) ==
              DateFormat('yyyy-MM-dd').format(DateTime.parse(element.lastDateTime)) &&
          element.year == UserSharedPreferences.year) {
        if (!checkStudentInList(assignment: element)) {
          if (!context.mounted) return;
          await showDialogForAssignment(context: context, assignmentModel: element, time: 'Today');
        }
      }
    }
  }
}
