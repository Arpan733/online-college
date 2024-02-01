import 'package:cloud_firestore/cloud_firestore.dart';

import '../consts/utils.dart';

class TeacherDataFireStore {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createTeacher(
      {required String phoneNumber, required String uid}) async {
    try {
      Map<String, String> userdata = {
        'phoneNumber': phoneNumber,
        'uid': uid,
      };

      await firestore.collection('users').doc(uid).set(userdata);
    } catch (e) {
      print('Error $e');
      Utils().showToast(e.toString());
    }
  }

  Future<Map<String, dynamic>?> getTeacherData({required String uid}) async {
    try {
      DocumentSnapshot snapshot =
          await firestore.collection("user").doc(uid).get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        return data;
      }
    } catch (e) {
      print('Error $e');
      Utils().showToast(e.toString());
    }
    return null;
  }
}
