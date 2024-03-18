import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
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

  MaterialModel _material =
      MaterialModel(year: [], title: '', mid: '', materials: [], createdTime: "");

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
      message: '${materialModel.materials.length} files added.',
      tokens: tokens,
      pd: {
        'page': 'materialDetail',
      },
    );

    if (!context.mounted) return;
    await getMaterialList(context: context);
  }

  void getMaterialModels(String id) {
    FirebaseFirestore.instance.collection('materials').doc(id).snapshots().listen((material) {
      _material = MaterialModel.fromJson(material.data()!);
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

  Future<void> deleteMaterial({required BuildContext context, required String mid}) async {
    await MaterialFireStore().deleteMaterialFromFireStore(context: context, mid: mid);

    if (!context.mounted) return;
    await getMaterialList(context: context);
  }

  Future<void> getMaterialAsFuture({required BuildContext context, required String mid}) async {
    _material = MaterialModel(year: [], title: '', mid: '', materials: [], createdTime: "");
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

  List<MaterialModel> teacherSorting({
    required BuildContext context,
    required String sort,
  }) {
    List<MaterialModel> showMaterialList = [];

    if (sort == 'Uploaded Time') {
      showMaterialList =
          materials.map((element) => MaterialModel.fromJson(element.toJson())).toList();
      showMaterialList.sort(
        (a, b) {
          DateTime aDate = DateTime.parse(a.createdTime);
          DateTime bDate = DateTime.parse(b.createdTime);
          return aDate.compareTo(bDate);
        },
      );
    } else if (sort == 'All') {
      showMaterialList = materials;
    } else {
      for (var element in materials) {
        if (element.year.contains(sort)) {
          showMaterialList.add(MaterialModel.fromJson(element.toJson()));
        }
      }
    }

    return showMaterialList;
  }

  List<MaterialModel> studentSorting({
    required BuildContext context,
    required String sort,
  }) {
    List<MaterialModel> showMaterialList = [];
    List<MaterialModel> materialList = [];

    for (var element in materials) {
      if (element.year.contains(UserSharedPreferences.year)) {
        materialList.add(element);
      }
    }

    if (sort == 'Uploaded Time') {
      showMaterialList =
          materialList.map((element) => MaterialModel.fromJson(element.toJson())).toList();
      showMaterialList.sort(
        (a, b) {
          DateTime aDate = DateTime.parse(a.createdTime);
          DateTime bDate = DateTime.parse(b.createdTime);
          return aDate.compareTo(bDate);
        },
      );
    } else if (sort == 'All') {
      showMaterialList = materialList;
    }

    return showMaterialList;
  }
}
