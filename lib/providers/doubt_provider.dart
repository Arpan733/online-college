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

  Future<void> addDoubt({required DoubtModel doubtModel}) async {
    await DoubtFireStore().addDoubtToFireStore(doubtModel: doubtModel);
    await getDoubtList();
  }

  Future<void> updateDoubt({required DoubtModel doubtModel}) async {
    await DoubtFireStore().updateDoubtAtFireStore(doubtModel: doubtModel);
    await getDoubtList();
  }

  Future<void> deleteDoubt({required String sid}) async {
    await DoubtFireStore().deleteDoubtFromFireStore(sid: sid);
    await getDoubtList();
  }

  Future<void> getDoubt({required String did}) async {
    _doubt = DoubtModel(year: '', subject: '', did: '', createdTime: '', title: '', chat: []);
    _isLoading = true;
    notifyListeners();

    DoubtModel? response = await DoubtFireStore().getDoubtFromFireStore(did: did);

    if (response != null) {
      _doubt = response;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getDoubtList() async {
    _doubts = [];
    _isLoading = true;
    notifyListeners();

    List<DoubtModel> response = await DoubtFireStore().getDoubtListFromFireStore();

    if (response.isNotEmpty) {
      _doubts = response;
    }

    _isLoading = false;
    notifyListeners();
  }
}
