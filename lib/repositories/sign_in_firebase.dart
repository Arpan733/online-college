import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_college/consts/utils.dart';

class SignInFirebase {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<String?> getOTP({required String phoneNumber}) async {
    try {
      String verificationId = '';

      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+91${phoneNumber.trim()}',
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {
          Utils().showToast(e.code.toString());
        },
        codeSent: (String verificationid, int? resendToken) async {
          verificationId = verificationid;
        },
        timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout: (String verificationId) {},
      );

      return verificationId;
    } on FirebaseAuthException catch (e) {
      Utils().showToast(e.code.toString());
    }

    return null;
  }

  Future<UserCredential?> checkOTP(
      {required String verificationId, required String smsCode}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      UserCredential user = await firebaseAuth.signInWithCredential(credential);

      return user;
    } on FirebaseAuthException catch (e) {
      Utils().showToast(e.code.toString());
    }

    return null;
  }
}
