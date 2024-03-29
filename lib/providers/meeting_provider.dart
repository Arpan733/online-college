import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/model/meeting_model.dart';
import 'package:online_college/providers/all_user_provider.dart';
import 'package:online_college/repositories/meeting_firestore.dart';
import 'package:online_college/repositories/notifications.dart';
import 'package:online_college/widgets/dialog_for_meeting.dart';
import 'package:provider/provider.dart';

class MeetingProvider extends ChangeNotifier {
  List<MeetingModel> _meetingList = [];

  List<MeetingModel> get meetingList => _meetingList;

  MeetingModel _meeting = MeetingModel(
    mid: 'mid',
    title: 'title',
    year: [],
    agoraToken: '',
    channelName: '',
    time: '',
    createdTime: '',
  );

  MeetingModel get meeting => _meeting;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String get appId => '816ccbb1f55e453cb85ce1c9be33b6e0';

  Future<void> addMeeting(
      {required BuildContext context, required MeetingModel meetingModel}) async {
    await MeetingFireStore().addMeetingToFireStore(context: context, meetingModel: meetingModel);

    List<String> tokens = [];

    if (!context.mounted) return;
    Provider.of<AllUserProvider>(context, listen: false).studentsList.forEach((element) {
      if (meetingModel.year.contains(element.year) && element.notificationToken != "") {
        tokens.add(element.notificationToken);
      }
    });

    if (!context.mounted) return;
    Provider.of<AllUserProvider>(context, listen: false).teachersList.forEach((element) {
      if (element.notificationToken != "") {
        tokens.add(element.notificationToken);
      }
    });

    tokens.remove(UserSharedPreferences.notificationToken);

    NotificationServices().sendNotification(
      title: 'Discussion on ${meetingModel.title}',
      message:
          'Meeting for ${meetingModel.title} will start at ${DateFormat('dd/MM/yyyy hh:mm aa').format(DateTime.parse(meetingModel.time))}',
      tokens: tokens,
      pd: {
        'page': 'meetingDetail',
      },
    );

    if (!context.mounted) return;
    await getMeetingList(context: context);
  }

  Future<void> updateMeeting(
      {required BuildContext context, required MeetingModel meetingModel}) async {
    await MeetingFireStore().updateMeetingAtFireStore(context: context, meetingModel: meetingModel);

    if (!context.mounted) return;
    await getMeetingList(context: context);
  }

  Future<void> deleteMeeting({required BuildContext context, required String mid}) async {
    await MeetingFireStore().deleteMeetingFromFireStore(context: context, mid: mid);

    if (!context.mounted) return;
    await getMeetingList(context: context);
  }

  Future<void> getMeetingList({required BuildContext context}) async {
    _meetingList = [];
    _isLoading = true;
    notifyListeners();

    List<MeetingModel> response =
        await MeetingFireStore().getMeetingListFromFireStore(context: context);

    if (response.isNotEmpty) {
      _meetingList = response;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getMeeting({required BuildContext context, required String mid}) async {
    _meeting = MeetingModel(
      mid: 'mid',
      title: 'title',
      year: [],
      agoraToken: '',
      channelName: '',
      time: '',
      createdTime: '',
    );
    _isLoading = true;
    notifyListeners();

    MeetingModel? response =
        await MeetingFireStore().getMeetingFromFireStore(context: context, mid: mid);

    if (response != null) {
      _meeting = response;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> checkUpcomingMeeting({required BuildContext context}) async {
    await getMeetingList(context: context);

    for (var element in meetingList) {
      if (DateTime.now().year == DateTime.parse(element.time).year &&
          DateTime.now().month == DateTime.parse(element.time).month &&
          DateTime.now().day == DateTime.parse(element.time).day &&
          DateTime.now().isBefore(DateTime.parse(element.time))) {
        if (!context.mounted) return;
        await showDialogForMeeting(context: context, meeting: element, time: 'Today');
      }

      if (DateFormat('dd/MM/yyyy').format(DateTime.now().add(const Duration(days: 1))) ==
          DateFormat('dd/MM/yyyy').format(DateTime.parse(element.time))) {
        if (!context.mounted) return;
        await showDialogForMeeting(context: context, meeting: element, time: 'Tomorrow');
      }
    }
  }
}
