import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/consts/utils.dart';
import 'package:online_college/providers/all_user_provider.dart';
import 'package:online_college/repositories/fee_firestore.dart';
import 'package:online_college/repositories/notifications.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../model/fee_model.dart';

class FeeProvider extends ChangeNotifier {
  List<FeeModel> _feeList = [];

  List<FeeModel> get feeList => _feeList;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Razorpay razorpay = Razorpay();

  Future<void> addFee({required BuildContext context, required FeeModel feeModel}) async {
    await FeeFireStore().addFeeToFireStore(context: context, feeModel: feeModel);

    List<String> tokens = [];

    if (!context.mounted) return;
    Provider.of<AllUserProvider>(context, listen: false).studentsList.forEach((element) {
      if (feeModel.year == element.year && element.notificationToken != "") {
        tokens.add(element.notificationToken);
      }
    });

    NotificationServices().sendNotification(
      title: 'About Fee',
      message:
          'Please note that the fee for ${feeModel.title} is due on ${feeModel.lastDate} and amounts to ${feeModel.totalAmount}.',
      tokens: tokens,
      page: 'fees',
    );

    if (!context.mounted) return;
    await getFeeList(context: context);
  }

  Future<void> addStudentInFeeList(
      {required BuildContext context,
      required String refNo,
      required String sid,
      required FeeModel feeModel}) async {
    await FeeFireStore()
        .addStudentToFireStoreFeeList(context: context, sid: sid, feeModel: feeModel, refNo: refNo);

    if (!context.mounted) return;
    await getFeeList(context: context);
  }

  Future<void> updateFee({required BuildContext context, required FeeModel feeModel}) async {
    await FeeFireStore().updateFeeAtFireStore(context: context, feeModel: feeModel);

    if (!context.mounted) return;
    await getFeeList(context: context);
  }

  Future<void> deleteFee({required BuildContext context, required String fid}) async {
    await FeeFireStore().deleteFeeFromFireStore(context: context, fid: fid);

    if (!context.mounted) return;
    await getFeeList(context: context);
  }

  Future<void> getFeeList({required BuildContext context}) async {
    _feeList = [];
    _isLoading = true;
    notifyListeners();

    List<FeeModel> response = await FeeFireStore().getFeeListFromFireStore(context: context);

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

  Future<void> createPayment({required BuildContext context, required FeeModel feeModel}) async {
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse response) async {
      String paymentId = response.paymentId ?? response.data?['payment_id'];

      await addStudentInFeeList(
          refNo: paymentId, sid: UserSharedPreferences.id, feeModel: feeModel, context: context);

      if (!context.mounted) return;
      await getFeeList(context: context);
      razorpay.clear();
    });

    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse response) {
      Utils().showToast(context: context, message: response.message!);
      razorpay.clear();
    });

    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (ExternalWalletResponse response) {
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
      Utils().showToast(context: context, message: e.toString());
    }
  }
}
