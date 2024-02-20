import 'package:flutter/cupertino.dart';
import 'package:online_college/model/time_table_model.dart';
import 'package:online_college/repositories/time_table_firestore.dart';

class TimeTableProvider extends ChangeNotifier {
  List<TimeTableModel> _timeTableList = [];

  List<TimeTableModel> get timeTableList => _timeTableList;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> getTimeTableList({required BuildContext context}) async {
    _timeTableList = [];
    _isLoading = true;
    notifyListeners();

    List<TimeTableModel> response =
        await TimeTableFireStore().getTimeTableFromGSheet(context: context);

    if (response.isNotEmpty) {
      _timeTableList = response;
    }

    _isLoading = false;
    notifyListeners();
  }
}
