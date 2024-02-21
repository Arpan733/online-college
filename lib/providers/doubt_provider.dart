import 'package:flutter/cupertino.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/providers/all_user_provider.dart';
import 'package:online_college/repositories/notifications.dart';
import 'package:provider/provider.dart';

import '../model/doubt_model.dart';
import '../repositories/doubt_firestore.dart';

class DoubtProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<DoubtModel> _doubts = [];

  List<DoubtModel> get doubts => _doubts;

  DoubtModel _doubt =
      DoubtModel(year: '', subject: '', did: '', createdTime: '', title: '', chat: []);

  DoubtModel get doubt => _doubt;

  Future<void> addDoubt({required BuildContext context, required DoubtModel doubtModel}) async {
    await DoubtFireStore().addDoubtToFireStore(context: context, doubtModel: doubtModel);

    List<String> tokens = [];

    if (!context.mounted) return;
    Provider.of<AllUserProvider>(context, listen: false).studentsList.forEach((element) {
      if (element.role == 'teacher' && element.notificationToken != "") {
        tokens.add(element.notificationToken);
      }
    });

    NotificationServices().sendNotification(
      title: doubtModel.title,
      message:
          'You have a new query from a ${doubtModel.year} student regarding ${doubtModel.title} in ${doubtModel.subject}. Please address it at your earliest convenience.',
      tokens: tokens,
      page: 'doubts',
    );

    if (!context.mounted) return;
    await getDoubtList(context: context);
  }

  Future<void> updateDoubt({required BuildContext context, required DoubtModel doubtModel}) async {
    await DoubtFireStore().updateDoubtAtFireStore(context: context, doubtModel: doubtModel);

    List<String> tokens = [];
    String name = '';

    if (doubtModel.chat.last.role == 'teacher') {
      if (!context.mounted) return;
      Provider.of<AllUserProvider>(context, listen: false).studentsList.forEach((element) {
        if (doubtModel.year == element.year &&
            element.role == 'student' &&
            element.notificationToken != "") {
          tokens.add(element.notificationToken);
        }
      });

      tokens.remove(UserSharedPreferences.notificationToken);

      if (!context.mounted) return;
      Provider.of<AllUserProvider>(context, listen: false).teachersList.forEach((element) {
        if (doubtModel.chat.last.id == element.id) {
          name = element.name;
        }
      });
    } else {
      if (!context.mounted) return;
      Provider.of<AllUserProvider>(context, listen: false).teachersList.forEach((element) {
        if (element.role == 'teacher' && element.notificationToken != "") {
          tokens.add(element.notificationToken);
        }
      });

      if (!context.mounted) return;
      Provider.of<AllUserProvider>(context, listen: false).studentsList.forEach((element) {
        if (doubtModel.chat.last.id == element.id) {
          name = element.name;
        }
      });
    }

    NotificationServices().sendNotification(
      title: doubtModel.title,
      message:
          'From $name: ${doubtModel.chat.last.message}${doubtModel.chat.last.attach.isNotEmpty ? ' with ${doubtModel.chat.last.attach.length} attachment' : ''}',
      tokens: tokens,
      page: 'fees',
    );

    if (!context.mounted) return;
    await getDoubtList(context: context);
  }

  Future<void> deleteDoubt({required BuildContext context, required String sid}) async {
    await DoubtFireStore().deleteDoubtFromFireStore(context: context, sid: sid);

    if (!context.mounted) return;
    await getDoubtList(context: context);
  }

  Future<void> getDoubt({required BuildContext context, required String did}) async {
    _doubt = DoubtModel(year: '', subject: '', did: '', createdTime: '', title: '', chat: []);
    _isLoading = true;
    notifyListeners();

    DoubtModel? response = await DoubtFireStore().getDoubtFromFireStore(context: context, did: did);

    if (response != null) {
      _doubt = response;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getDoubtList({required BuildContext context}) async {
    _doubts = [];
    _isLoading = true;
    notifyListeners();

    List<DoubtModel> response = await DoubtFireStore().getDoubtListFromFireStore(context: context);

    if (response.isNotEmpty) {
      _doubts = response;
    }

    _isLoading = false;
    notifyListeners();
  }
}
