import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:online_college/providers/all_user_provider.dart';
import 'package:online_college/providers/student_data_firestore_provider.dart';
import 'package:online_college/providers/teacher_data_firestore_provider.dart';
import 'package:online_college/repositories/sign_in_firebase.dart';
import 'package:provider/provider.dart';

import '../consts/route_name.dart';
import '../consts/utils.dart';
import '../repositories/user_repository.dart';

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

  Future<void> checkOTP({required BuildContext context, required String smsCode}) async {
    _isLoginLoading = true;
    notifyListeners();

    if (_verificationId != null && _verificationId!.isNotEmpty) {
      _user = await SignInFirebase().checkOTP(verificationId: _verificationId!, smsCode: smsCode);
    }

    if (_user != null) {
      if (!context.mounted) return;
      await Provider.of<AllUserProvider>(context, listen: false).getAllUser();

      String id = '';
      String role = '';

      if (!context.mounted) return;
      Provider.of<AllUserProvider>(context, listen: false).teachersList.forEach((element) {
        if (element.phoneNumber == firebaseAuth.currentUser!.phoneNumber.toString().substring(3)) {
          id = element.id!;
          role = element.role!;
        }
      });

      if (id.isNotEmpty && role.isNotEmpty) {
        if (!context.mounted) return;
        Provider.of<AllUserProvider>(context, listen: false).teachersList.forEach((element) {
          if (element.phoneNumber ==
              firebaseAuth.currentUser!.phoneNumber.toString().substring(3)) {
            id = element.id!;
            role = element.role!;
          }
        });
      }

      if (role == 'student') {
        StudentDataFireStoreProvider studentFireStore = StudentDataFireStoreProvider();

        await studentFireStore.getStudentData();

        if (studentFireStore.studentData != null) {
          UserRepository.saveUserPref(
            phoneNumber: studentFireStore.studentData?.phoneNumber,
            uid: studentFireStore.studentData?.uid,
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
          );
        }

        _isLoginLoading = false;
        notifyListeners();

        if (!context.mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesName.dashboard,
          (route) => false,
        );
      } else if (role == 'teacher') {
        TeacherDataFireStoreProvider teacherFireStore = TeacherDataFireStoreProvider();

        await teacherFireStore.getTeacherData();

        if (teacherFireStore.teacherData != null) {
          UserRepository.saveUserPref(
            phoneNumber: teacherFireStore.teacherData?.phoneNumber,
            uid: teacherFireStore.teacherData?.uid,
            address: teacherFireStore.teacherData?.address,
            adhar: teacherFireStore.teacherData?.adhar,
            dateOfBirth: teacherFireStore.teacherData?.dateOfBirth,
            email: teacherFireStore.teacherData?.email,
            name: teacherFireStore.teacherData?.name,
            qualification: teacherFireStore.teacherData?.qualification,
            photoUrl: teacherFireStore.teacherData?.photoUrl,
          );
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

    _isLoginLoading = false;
    notifyListeners();
  }
}
