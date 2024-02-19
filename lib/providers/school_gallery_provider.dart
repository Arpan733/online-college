import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:online_college/model/school_gallery_model.dart';
import 'package:online_college/repositories/school_gallery_firestore.dart';
import 'package:uuid/v4.dart';

class SchoolGalleryProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<SchoolGalleryModel> _schoolGalleryList = [];

  List<SchoolGalleryModel> get schoolGalleryList => _schoolGalleryList;

  Future<void> addSchoolGallery({required BuildContext context, required PlatformFile file}) async {
    String sgid = const UuidV4().generate().toString();

    String? url = await SchoolGalleryFireStore().uploadFile(
      context: context,
      pickedFile: file,
      sgid: sgid,
    );

    if (url != null) {
      if (!context.mounted) return;
      SchoolGalleryFireStore().addSchoolGalleryToFireStore(
        context: context,
        schoolGalleryModel: SchoolGalleryModel(
          url: url,
          noOfLikes: '0',
          likedList: [],
          sgid: sgid,
        ),
      );
    }

    if (!context.mounted) return;
    await getSchoolGalleryList(context: context);
  }

  Future<void> updateSchoolGallery(
      {required BuildContext context, required SchoolGalleryModel schoolGalleryModel}) async {
    await SchoolGalleryFireStore()
        .updateSchoolGalleryAtFireStore(context: context, schoolGalleryModel: schoolGalleryModel);

    if (!context.mounted) return;
    await getSchoolGalleryList(context: context);
  }

  Future<void> deleteSchoolGallery({required BuildContext context, required String sgid}) async {
    await SchoolGalleryFireStore().deleteSchoolGalleryFromFireStore(context: context, sgid: sgid);

    if (!context.mounted) return;
    await getSchoolGalleryList(context: context);
  }

  Future<void> getSchoolGalleryList({required BuildContext context}) async {
    _schoolGalleryList = [];
    _isLoading = true;
    notifyListeners();

    List<SchoolGalleryModel> response =
        await SchoolGalleryFireStore().getSchoolGalleryListFromFireStore(context: context);

    if (response.isNotEmpty) {
      _schoolGalleryList = response;
    }

    _isLoading = false;
    notifyListeners();
  }
}
