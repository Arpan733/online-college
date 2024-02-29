import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:online_college/providers/all_user_provider.dart';
import 'package:online_college/repositories/notifications.dart';
import 'package:provider/provider.dart';

import '../model/material_model.dart';
import '../repositories/material_firestore.dart';

class MaterialProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<MaterialModel> _materials = [];

  List<MaterialModel> get materials => _materials;

  MaterialModel _material = MaterialModel(year: [], title: '', mid: '', materials: []);

  MaterialModel get material => _material;

  Future<void> addMaterial(
      {required BuildContext context, required MaterialModel materialModel}) async {
    await MaterialFireStore()
        .addMaterialToFireStore(context: context, materialModel: materialModel);

    List<String> tokens = [];

    if (!context.mounted) return;
    Provider.of<AllUserProvider>(context, listen: false).studentsList.forEach((element) {
      if (materialModel.year.contains(element.year) && element.notificationToken != '') {
        tokens.add(element.notificationToken);
      }
    });

    NotificationServices().sendNotification(
      title: materialModel.title,
      message: '${materialModel}',
      tokens: tokens,
      pd: {
        'page': 'materialDetail',
        'id': materialModel.mid,
      },
    );

    if (!context.mounted) return;
    await getMaterialList(context: context);
  }

  void getMaterialModels(String id) {
    FirebaseFirestore.instance.collection('materials').doc(id).snapshots().listen((event) {
      _material = MaterialModel.fromJson(event.data()!);
      notifyListeners();
    });
  }

  Future<void> updateMaterial(
      {required BuildContext context, required MaterialModel materialModel}) async {
    await MaterialFireStore()
        .updateMaterialAtFireStore(context: context, materialModel: materialModel);

    if (!context.mounted) return;
    await getMaterialList(context: context);
  }

  Future<void> solveMaterial(
      {required BuildContext context, required MaterialModel materialModel}) async {
    await MaterialFireStore()
        .updateMaterialAtFireStore(context: context, materialModel: materialModel);

    if (!context.mounted) return;
    await getMaterialList(context: context);
  }

  Future<void> deleteMaterial({required BuildContext context, required String sid}) async {
    await MaterialFireStore().deleteMaterialFromFireStore(context: context, sid: sid);

    if (!context.mounted) return;
    await getMaterialList(context: context);
  }

  Future<void> getMaterialAsFuture({required BuildContext context, required String mid}) async {
    _material = MaterialModel(year: [], title: '', mid: '', materials: []);
    _isLoading = true;
    notifyListeners();

    MaterialModel? response =
        await MaterialFireStore().getMaterialFromFireStore(context: context, mid: mid);

    if (response != null) {
      _material = response;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getMaterialList({required BuildContext context}) async {
    _materials = [];
    _isLoading = true;
    notifyListeners();

    List<MaterialModel> response =
        await MaterialFireStore().getMaterialListFromFireStore(context: context);

    if (response.isNotEmpty) {
      _materials = response;
    }

    _isLoading = false;
    notifyListeners();
  }
}
