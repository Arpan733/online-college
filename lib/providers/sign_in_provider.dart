import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_college/consts/routes.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/consts/utils.dart';
import 'package:online_college/model/student_user_model.dart';
import 'package:online_college/model/teacher_user_model.dart';
import 'package:online_college/providers/student_data_firestore_provider.dart';
import 'package:online_college/providers/teacher_data_firestore_provider.dart';
import 'package:online_college/repositories/notifications.dart';
import 'package:online_college/repositories/sign_in_firebase.dart';
import 'package:online_college/repositories/user_data_firestore.dart';
import 'package:online_college/repositories/user_repository.dart';
import 'package:provider/provider.dart';

import 'all_user_provider.dart';

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

  Future<void> getOTP({required BuildContext context, required String phoneNumber}) async {
    _isLoading = true;
    notifyListeners();

    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91${phoneNumber.trim()}',
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {
        Utils().showToast(context: context, message: e.code.toString());
      },
      codeSent: (String verificationid, int? resendToken) async {
        _verificationId = verificationid;

        Utils().showToast(context: context, message: 'Otp sent');
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

  Future<void> checkOTP({required BuildContext context, required String smsCode}) async {
    _isLoginLoading = true;
    notifyListeners();

    if (_verificationId != null && _verificationId!.isNotEmpty) {
      _user = await SignInFirebase()
          .checkOTP(context: context, verificationId: _verificationId!, smsCode: smsCode);
    }

    if (_user != null) {
      if (!context.mounted) return;
      await Provider.of<AllUserProvider>(context, listen: false).getAllUser(context: context);

      String id = '';
      String role = '';

      if (!context.mounted) return;
      Provider.of<AllUserProvider>(context, listen: false).studentsList.forEach((element) {
        if (element.phoneNumber == firebaseAuth.currentUser!.phoneNumber.toString().substring(3)) {
          id = element.id;
          role = element.role;
        }
      });

      if (id.isEmpty && role.isEmpty) {
        if (!context.mounted) return;
        Provider.of<AllUserProvider>(context, listen: false).teachersList.forEach((element) {
          if (element.phoneNumber ==
              firebaseAuth.currentUser!.phoneNumber.toString().substring(3)) {
            id = element.id;
            role = element.role;
          }
        });
      }

      if (role == 'student') {
        StudentDataFireStoreProvider studentFireStore = StudentDataFireStoreProvider();
        String dateTime = DateTime.now().toString();
        String token = await NotificationServices().getToken();

        if (!context.mounted) return;
        studentFireStore.updateStudentUid(
            context: context, uid: firebaseAuth.currentUser!.uid, id: id);
        studentFireStore.updateStudentLoginTime(context: context, loginTime: dateTime, id: id);
        studentFireStore.updateStudentNotificationToken(
            context: context, notificationToken: token, id: id);
        await studentFireStore.getStudentData(context: context, id: id);

        if (studentFireStore.studentData != null) {
          await UserRepository.saveUserPref(
            phoneNumber: firebaseAuth.currentUser?.phoneNumber,
            uid: firebaseAuth.currentUser?.uid,
            address: studentFireStore.studentData?.address,
            adhar: studentFireStore.studentData?.adhar,
            dateOfBirth: studentFireStore.studentData?.dateOfBirth,
            email: studentFireStore.studentData?.email,
            name: studentFireStore.studentData?.name,
            photoUrl: studentFireStore.studentData?.photoUrl,
            id: studentFireStore.studentData?.id,
            year: studentFireStore.studentData?.year,
            fatherName: studentFireStore.studentData?.motherName,
            motherName: studentFireStore.studentData?.fatherName,
            role: studentFireStore.studentData?.role,
            rollNo: studentFireStore.studentData?.rollNo,
            notificationToken: token,
            loginTime: dateTime,
          );
        }

        if (!context.mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.dashboard,
          (route) => false,
        );
      } else if (role == 'teacher') {
        TeacherDataFireStoreProvider teacherFireStore = TeacherDataFireStoreProvider();
        String dateTime = DateTime.now().toString();
        String token = await NotificationServices().getToken();

        if (!context.mounted) return;
        teacherFireStore.updateTeacherUid(
            context: context, uid: firebaseAuth.currentUser!.uid, id: id);
        teacherFireStore.updateTeacherLoginTime(context: context, loginTime: dateTime, id: id);
        teacherFireStore.updateTeacherNotificationToken(
            context: context, notificationToken: token, id: id);
        await teacherFireStore.getTeacherData(context: context, id: id);

        if (teacherFireStore.teacherData != null) {
          await UserRepository.saveUserPref(
            phoneNumber: firebaseAuth.currentUser?.phoneNumber,
            uid: firebaseAuth.currentUser?.uid,
            address: teacherFireStore.teacherData?.address,
            adhar: teacherFireStore.teacherData?.adhar,
            dateOfBirth: teacherFireStore.teacherData?.dateOfBirth,
            email: teacherFireStore.teacherData?.email,
            name: teacherFireStore.teacherData?.name,
            qualification: teacherFireStore.teacherData?.qualification,
            photoUrl: teacherFireStore.teacherData?.photoUrl,
            role: teacherFireStore.teacherData?.role,
            id: teacherFireStore.teacherData?.id,
            notificationToken: token,
            loginTime: dateTime,
          );
        }

        if (!context.mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.dashboard,
          (route) => false,
        );
      }
    }

    _isLoginLoading = false;
    _enableOTPField = false;
    notifyListeners();
  }

  Future<bool> checkUserDevices({required BuildContext context}) async {
    if (UserSharedPreferences.role == 'student') {
      StudentUserModel? studentUserModel =
          await UserDataFireStore().getStudentData(context: context, id: UserSharedPreferences.id);
      return UserSharedPreferences.loginTime == studentUserModel?.loginTime;
    } else {
      TeacherUserModel? teacherUserModel =
          await UserDataFireStore().getTeacherData(context: context, id: UserSharedPreferences.id);
      return UserSharedPreferences.loginTime == teacherUserModel?.loginTime;
    }
  }
}
