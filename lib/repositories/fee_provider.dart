import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:online_college/providers/fee_firestore.dart';

import '../model/fee_model.dart';

class FeeProvider extends ChangeNotifier {
  List<FeeModel> _feeList = [];

  List<FeeModel> get feeList => _feeList;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> addFee({required FeeModel feeModel}) async {
    await FeeFireStore().addFeeToFireStore(feeModel: feeModel);
    await getFeeList();
  }

  Future<void> updateFee({required FeeModel feeModel}) async {
    await FeeFireStore().updateFeeAtFireStore(feeModel: feeModel);
    await getFeeList();
  }

  Future<void> deleteFee({required String fid}) async {
    await FeeFireStore().deleteFeeFromFireStore(fid: fid);
    await getFeeList();
  }

  Future<void> getFeeList() async {
    _feeList = [];
    _isLoading = true;
    notifyListeners();

    List<FeeModel> response = await FeeFireStore().getFeeListFromFireStore();

    if (response.isNotEmpty) {
      _feeList = response;
      await sortFee();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> sortFee() async {
    _feeList.sort(
      (a, b) {
        DateTime aDate = DateFormat('dd/MM/yyyy').parse(a.createdDate!);
        DateTime bDate = DateFormat('dd/MM/yyyy').parse(b.createdDate!);
        return aDate.compareTo(bDate);
      },
    );
  }
}
