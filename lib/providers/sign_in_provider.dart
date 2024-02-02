import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:online_college/providers/teacher_data_firestore_provider.dart';
import 'package:online_college/repositories/sign_in_firebase.dart';

import '../consts/route_name.dart';
import '../consts/utils.dart';
import '../repositories/teacher_shared_preferences.dart';

class SignInProvider extends ChangeNotifier {
  bool _enableOTPField = false;
  bool get enableOTPField => _enableOTPField;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoginLoading = false;
  bool get isLoginLoading => _isLoginLoading;

  String? _verificationId;
  UserCredential? _user;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<void> getOTP({required String phoneNumber}) async {
    _isLoading = true;
    notifyListeners();

    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91${phoneNumber.trim()}',
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {
        Utils().showToast(e.code.toString());
      },
      codeSent: (String verificationid, int? resendToken) async {
        _verificationId = verificationid;

        Utils().showToast('Otp sent');
        if (_verificationId != null && _verificationId!.isNotEmpty) {
          _enableOTPField = true;
        }
        notifyListeners();
      },
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> checkOTP(
      {required BuildContext context, required String smsCode}) async {
    _isLoginLoading = true;
    notifyListeners();

    if (_verificationId != null && _verificationId!.isNotEmpty) {
      _user = await SignInFirebase()
          .checkOTP(verificationId: _verificationId!, smsCode: smsCode);

      if (_user != null) {
        if (!context.mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesName.dashboard,
          (route) => false,
        );
      }

      TeacherDataFireStoreProvider().makeTeacher();
      TeacherSharedPreferences.setString(
          title: 'phoneNumber',
          data: firebaseAuth.currentUser!.phoneNumber.toString());
      TeacherSharedPreferences.setString(
          title: 'uid', data: firebaseAuth.currentUser!.uid.toString());
    }

    _isLoginLoading = false;
    notifyListeners();
  }
}
