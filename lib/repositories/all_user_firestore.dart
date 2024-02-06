import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_college/consts/utils.dart';
import 'package:online_college/model/student_user_model.dart';

class AllUserFireStore {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getAllUser() async {
    try {
      return (await firestore.collection('users').get()).docs.map((e) => e.data()).toList();
    } catch (e) {
      Utils().showToast(e.toString());
    }

    return [];
  }

  Future<void> addStudentUser({required StudentUserModel studentUserModel}) async {
    try {
      await firestore.collection('users').doc(studentUserModel.id).set(studentUserModel.toJson());
      Utils().showToast('Student Added');
    } catch (e) {
      Utils().showToast(e.toString());
    }
  }
}
