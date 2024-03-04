import 'package:flutter/material.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/model/notice_model.dart';
import 'package:online_college/providers/all_user_provider.dart';
import 'package:online_college/repositories/notice_firestore.dart';
import 'package:online_college/repositories/notifications.dart';
import 'package:provider/provider.dart';

class NoticeProvider extends ChangeNotifier {
  List<NoticeModel> _noticeList = [];

  List<NoticeModel> get noticeList => _noticeList;

  NoticeModel _notice =
      NoticeModel(nid: '', title: '', description: '', photoUrl: '', createdTime: '', year: []);

  NoticeModel get notice => _notice;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> addNotice({required BuildContext context, required NoticeModel noticeModel}) async {
    await NoticeFireStore().addNoticeToFireStore(context: context, noticeModel: noticeModel);

    List<String> tokens = [];

    if (!context.mounted) return;
    Provider.of<AllUserProvider>(context, listen: false).studentsList.forEach((element) {
      if ((noticeModel.year.contains(element.year) || element.role == 'teacher') &&
          element.notificationToken != "") {
        tokens.add(element.notificationToken);
      }
    });

    tokens.remove(UserSharedPreferences.notificationToken);

    NotificationServices().sendNotification(
      title: 'Notice: ${noticeModel.title}',
      message: noticeModel.description,
      tokens: tokens,
      pd: {
        'page': 'noticeDetail',
      },
    );

    if (!context.mounted) return;
    await getNoticeList(context: context);
  }

  Future<void> updateNotice(
      {required BuildContext context, required NoticeModel noticeModel}) async {
    await NoticeFireStore().updateNoticeAtFireStore(context: context, noticeModel: noticeModel);

    if (!context.mounted) return;
    await getNoticeList(context: context);
  }

  Future<void> deleteNotice({required BuildContext context, required String nid}) async {
    await NoticeFireStore().deleteNoticeFromFireStore(context: context, nid: nid);

    if (!context.mounted) return;
    await getNoticeList(context: context);
  }

  Future<void> getNoticeList({required BuildContext context}) async {
    _noticeList = [];
    _isLoading = true;
    notifyListeners();

    List<NoticeModel> response =
        await NoticeFireStore().getNoticeListFromFireStore(context: context);

    if (response.isNotEmpty) {
      _noticeList = response;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getNotice({required BuildContext context, required String nid}) async {
    _notice =
        NoticeModel(nid: '', title: '', description: '', photoUrl: '', createdTime: '', year: []);
    _isLoading = true;
    notifyListeners();

    NoticeModel? response =
        await NoticeFireStore().getNoticeFromFireStore(context: context, nid: nid);

    if (response != null) {
      _notice = response;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> checkUpcomingNotice({required BuildContext context}) async {
    await getNoticeList(context: context);

    for (var element in noticeList) {
      if (DateTime.now()
              .add(const Duration(hours: 24))
              .isBefore(DateTime.parse(element.createdTime)) &&
          DateTime.now().isAfter(DateTime.parse(element.createdTime))) {
        if (!context.mounted) return;
        // await showDialogForNotice(context: context, notice: element, time: 'Today');
      }
    }
  }

  List<NoticeModel> sorting({
    required BuildContext context,
    required String sort,
  }) {
    List<NoticeModel> showNoticeList = [];
    List<NoticeModel> notices = [];

    if (UserSharedPreferences.role == 'student') {
      for (var element in noticeList) {
        if (element.year.contains(UserSharedPreferences.year)) {
          notices.add(element);
        }
      }
    } else {
      notices = noticeList;
    }

    if (sort == 'By Time') {
      showNoticeList = notices.map((element) => NoticeModel.fromJson(element.toJson())).toList();
      showNoticeList.sort(
        (a, b) {
          DateTime aDate = DateTime.parse(a.createdTime);
          DateTime bDate = DateTime.parse(b.createdTime);
          return aDate.compareTo(bDate);
        },
      );
    } else if (sort == 'Latest') {
      for (var element in notices) {
        if (DateTime.parse(element.createdTime)
            .isAfter(DateTime.now().subtract(const Duration(hours: 24)))) {
          showNoticeList.add(element);
        }
      }
    } else if (sort == 'All') {
      showNoticeList = notices;
    }

    return showNoticeList;
  }
}
