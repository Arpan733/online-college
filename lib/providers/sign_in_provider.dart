import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:online_college/providers/teacher_data_firestore_provider.dart';
import 'package:online_college/repositories/sign_in_firebase.dart';
import 'package:online_college/repositories/user_repository.dart';

import '../consts/route_name.dart';
import '../consts/utils.dart';

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
        TeacherDataFireStoreProvider a = TeacherDataFireStoreProvider();

        await a.makeTeacher();
        await a.getTeacherData();

        if (a.teacherData != null) {
          UserRepository.saveUserPref(
            phoneNumber: a.teacherData?.phoneNumber,
            uid: a.teacherData?.uid,
            address: a.teacherData?.address,
            adhar: a.teacherData?.adhar,
            dateOfBirth: a.teacherData?.dateOfBirth,
            email: a.teacherData?.email,
            name: a.teacherData?.name,
            qualification: a.teacherData?.qualification,
            photoUrl: a.teacherData?.photoUrl,
          );
        }
      }
    }

    _isLoginLoading = false;
    notifyListeners();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.dashboard,
      (route) => false,
    );
  }
}
