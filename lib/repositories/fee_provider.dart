import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/consts/utils.dart';
import 'package:online_college/providers/fee_firestore.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../model/fee_model.dart';

class FeeProvider extends ChangeNotifier {
  List<FeeModel> _feeList = [];

  List<FeeModel> get feeList => _feeList;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Razorpay razorpay = Razorpay();

  Future<void> addFee({required FeeModel feeModel}) async {
    await FeeFireStore().addFeeToFireStore(feeModel: feeModel);
    await getFeeList();
  }

  Future<void> addStudentInFeeList(
      {required String refNo, required String sid, required FeeModel feeModel}) async {
    await FeeFireStore().addStudentToFireStoreFeeList(sid: sid, feeModel: feeModel, refNo: refNo);
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

  bool checkPaid({required String sid, required FeeModel fee}) {
    int t = 0;

    fee.paidStudents?.forEach((element) {
      if (element.sid == sid) {
        t++;
      }
    });

    return t != 0;
  }

  PaidStudent? getStudentData({required FeeModel feeModel}) {
    if (feeModel.paidStudents != null) {
      for (var element in feeModel.paidStudents!) {
        if (element.sid == UserSharedPreferences.id) {
          return element;
        }
      }
    }

    return null;
  }

  Future<void> createPayment({required FeeModel feeModel}) async {
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse response) async {
      String paymentId = response.paymentId ?? response.data?['payment_id'];

      await addStudentInFeeList(
          refNo: paymentId, sid: UserSharedPreferences.id, feeModel: feeModel);
      await getFeeList();
      razorpay.clear();
    });

    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse response) {
      Utils().showToast(response.message!);
      razorpay.clear();
    });

    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (ExternalWalletResponse response) {
      // Utils().showToast(response.toString());
      razorpay.clear();
    });

    // LxZcW6pOazJkcC1gcLGxEXrv

    Map<String, dynamic> options = {
      'key': 'rzp_test_IWJTu0Y4Q5oJxd',
      'amount': int.parse(feeModel.totalAmount!) * 100,
      'name': 'College Fee',
      'description': 'Fee of ${feeModel.title} from ${UserSharedPreferences.name}',
      'timeout': 300,
      'prefill': {
        'contact': UserSharedPreferences.phoneNumber,
        'email': UserSharedPreferences.email,
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      Utils().showToast(e.toString());
    }
  }
}
