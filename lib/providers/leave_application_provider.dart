import 'package:flutter/cupertino.dart';
import 'package:online_college/model/leave_application_model.dart';
import 'package:online_college/repositories/leave_application_firestore.dart';

class LeaveApplicationProvider extends ChangeNotifier {
  List<LeaveApplicationModel> _leaveApplicationList = [];

  List<LeaveApplicationModel> get leaveApplicationList => _leaveApplicationList;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  setIsLoading({required bool loading}) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> addLeaveApplication(
      {required BuildContext context, required LeaveApplicationModel leaveApplicationModel}) async {
    await LeaveApplicationFireStore().addLeaveApplicationToFireStore(
        context: context, leaveApplicationModel: leaveApplicationModel);

    if (!context.mounted) return;
    await getLeaveApplicationList(context: context);
  }

  Future<void> updateLeaveApplication(
      {required BuildContext context, required LeaveApplicationModel leaveApplicationModel}) async {
    await LeaveApplicationFireStore().updateLeaveApplicationAtFireStore(
        context: context, leaveApplicationModel: leaveApplicationModel);

    if (!context.mounted) return;
    await getLeaveApplicationList(context: context);
  }

  Future<void> deleteLeaveApplication({required BuildContext context, required String eid}) async {
    await LeaveApplicationFireStore()
        .deleteLeaveApplicationFromFireStore(context: context, eid: eid);

    if (!context.mounted) return;
    await getLeaveApplicationList(context: context);
  }

  Future<void> getLeaveApplicationList({required BuildContext context}) async {
    _leaveApplicationList = [];
    _isLoading = true;
    notifyListeners();

    List<LeaveApplicationModel> response =
        await LeaveApplicationFireStore().getLeaveApplicationListFromFireStore(context: context);

    if (response.isNotEmpty) {
      _leaveApplicationList = response;
    }

    _isLoading = false;
    notifyListeners();
  }
}
