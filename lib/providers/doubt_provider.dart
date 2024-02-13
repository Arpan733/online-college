import 'package:flutter/cupertino.dart';

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
    await getDoubtList(context: context);
  }

  Future<void> updateDoubt({required BuildContext context, required DoubtModel doubtModel}) async {
    await DoubtFireStore().updateDoubtAtFireStore(context: context, doubtModel: doubtModel);
    await getDoubtList(context: context);
  }

  Future<void> deleteDoubt({required BuildContext context, required String sid}) async {
    await DoubtFireStore().deleteDoubtFromFireStore(context: context, sid: sid);
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
