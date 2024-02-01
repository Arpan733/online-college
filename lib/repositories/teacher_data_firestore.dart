import 'package:cloud_firestore/cloud_firestore.dart';

import '../consts/utils.dart';

class TeacherDataFireStore {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createTeacher(
      {required String phoneNumber, required String uid}) async {
    try {
      Map<String, String> userdata = {
        'phoneNumber': phoneNumber,
      };

      await firestore.collection('users').doc(uid).set(userdata);
    } catch (e) {
      print('Error $e');
      Utils().showToast(e.toString());
    }
  }
}
