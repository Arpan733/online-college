import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_college/repositories/holiday_firestore.dart';
import 'package:online_college/widgets/dialog_for_holiday_show.dart';
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
      {required BuildContext context,
      required String title,
      required String description,
      required String date}) async {
    await holidayFireStore.addHoliday(
        title: title, description: description, date: date, context: context);
  }

  Future<void> editHoliday(
      {required BuildContext context,
      required String title,
      required String description,
      required String date,
      required String hid}) async {
    await holidayFireStore.editHoliday(
        title: title, description: description, date: date, hid: hid, context: context);
  }

  Future<void> getHolidayList({required BuildContext context}) async {
    _isLoading = true;
    notifyListeners();

    List<HolidayModel> list = await holidayFireStore.getHoliday(context: context);

    if (list.isNotEmpty) {
      _holidays = [];
      _holidays = list;
      sortList();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteHoliday({required BuildContext context, required String hid}) async {
    await holidayFireStore.deleteHoliday(hid: hid, context: context);
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

  Future<void> checkTomorrowIsHoliday({required BuildContext context}) async {
    await getHolidayList(context: context);

    for (var element in holidays) {
      if (DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 1))) ==
          DateFormat('yyyy-MM-dd').format(DateTime.parse(element.date!))) {
        if (!context.mounted) return;
        await showDialogForHolidayShow(context: context, hc: element, time: 'Tomorrow');
      }

      if (DateFormat('yyyy-MM-dd').format(DateTime.now()) ==
          DateFormat('yyyy-MM-dd').format(DateTime.parse(element.date!))) {
        if (!context.mounted) return;
        await showDialogForHolidayShow(context: context, hc: element, time: 'Today');
      }
    }
  }
}
