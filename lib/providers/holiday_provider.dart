import 'package:flutter/cupertino.dart';
import 'package:online_college/repositories/holiday_firestore.dart';
import 'package:provider/provider.dart';

import '../model/holiday_model.dart';

HolidayProvider getHolidayProvider(context) {
  return Provider.of<HolidayProvider>(context, listen: false);
}

class HolidayProvider extends ChangeNotifier {
  List<HolidayModel> _holidays = [];

  List<HolidayModel> get holidays => _holidays;

  DateTime _focusedDay = DateTime.now();

  DateTime get focusedDay => _focusedDay;

  setFocusDay(DateTime date) {
    _focusedDay = date;
  }

  DateTime? _selectedDay;

  DateTime? get selectedDay => _selectedDay;

  setSelectedDay(DateTime date) {
    _selectedDay = date;
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  HolidayFireStore holidayFireStore = HolidayFireStore();

  Future<void> addHoliday(
      {required String title, required String description, required String date}) async {
    await holidayFireStore.addHoliday(title: title, description: description, date: date);
  }

  Future<void> editHoliday(
      {required String title,
      required String description,
      required String date,
      required String hid}) async {
    await holidayFireStore.editHoliday(
        title: title, description: description, date: date, hid: hid);
  }

  Future<void> getHolidayList() async {
    _isLoading = true;
    notifyListeners();

    List<HolidayModel> list = await holidayFireStore.getHoliday();

    if (list.isNotEmpty) {
      _holidays = [];
      _holidays = list;
      sortList();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteHoliday({required String hid}) async {
    await holidayFireStore.deleteHoliday(hid: hid);
  }

  Future<void> sortList() async {
    _holidays.sort(
      (a, b) {
        DateTime aDate = DateTime.parse(a.date!);
        DateTime bDate = DateTime.parse(b.date!);
        return aDate.compareTo(bDate);
      },
    );
  }
}
