import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/consts/utils.dart';
import 'package:online_college/model/school_gallery_model.dart';
import 'package:online_college/providers/school_gallery_provider.dart';
import 'package:online_college/widgets/bottom_sheet_for_school_photos.dart';
import 'package:online_college/widgets/dialog_for_delete.dart';
import 'package:pie_menu/pie_menu.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class SchoolGalleryScreen extends StatefulWidget {
  const SchoolGalleryScreen({Key? key}) : super(key: key);

  @override
  State<SchoolGalleryScreen> createState() => _SchoolGalleryScreenState();
}

class _SchoolGalleryScreenState extends State<SchoolGalleryScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<SchoolGalleryProvider>(context, listen: false)
          .getSchoolGalleryList(context: context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        Provider.of<SchoolGalleryProvider>(context, listen: false)
            .getSchoolGalleryList(context: context);
      },
      backgroundColor: const Color(0xFF2855AE),
      color: Colors.white,
      child: PieCanvas(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Consumer<SchoolGalleryProvider>(
            builder: (context, gallery, child) {
              return Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      'assets/images/background 1.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        foregroundColor: Colors.white,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                colors: [Color(0xFF2855AE), Color(0xFF7292CF)],
                              ),
                            ),
                            child: Image.asset('assets/images/background.png'),
                          ),
                        ),
                        bottom: PreferredSize(
                          preferredSize: Size(MediaQuery.of(context).size.width, 40),
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(40), topLeft: Radius.circular(40)),
                              color: Colors.white,
                            ),
                          ),
                        ),
                        title: Text(
                          'School Gallery',
                          style: GoogleFonts.rubik(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            gallery.isLoading
                                ? SizedBox(
                                    height: MediaQuery.of(context).size.height - 250,
                                    width: MediaQuery.of(context).size.width,
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF2855AE),
                                      ),
                                    ),
                                  )
                                : gallery.schoolGalleryList.isEmpty
                                    ? SizedBox(
                                        height: MediaQuery.of(context).size.height - 200,
                                        width: MediaQuery.of(context).size.width,
                                        child: Center(
                                          child: Text(
                                            'There are not any photos in school gallery',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.rubik(
                                              color: Colors.black54,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,
                                        child: MasonryGridView.count(
                                          shrinkWrap: true,
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 20,
                                          mainAxisSpacing: 20,
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          itemCount: gallery.schoolGalleryList.isEmpty
                                              ? 1
                                              : gallery.schoolGalleryList.length,
                                          itemBuilder: (context, index) {
                                            SchoolGalleryModel g = gallery.schoolGalleryList[index];

                                            bool isLiked =
                                                g.likedList.contains(UserSharedPreferences.id);

                                            return PieMenu(
                                              actions: [
                                                PieAction(
                                                  tooltip: const Text(''),
                                                  onSelect: () {
                                                    SchoolGalleryModel schoolGalleryModel = g;

                                                    if (isLiked) {
                                                      schoolGalleryModel.likedList
                                                          .remove(UserSharedPreferences.id);
                                                      schoolGalleryModel.noOfLikes =
                                                          (int.parse(schoolGalleryModel.noOfLikes) -
                                                                  1)
                                                              .toString();
                                                    } else {
                                                      schoolGalleryModel.likedList
                                                          .add(UserSharedPreferences.id);
                                                      schoolGalleryModel.noOfLikes =
                                                          (int.parse(schoolGalleryModel.noOfLikes) +
                                                                  1)
                                                              .toString();
                                                    }

                                                    gallery.updateSchoolGallery(
                                                        context: context,
                                                        schoolGalleryModel: schoolGalleryModel);
                                                  },
                                                  buttonTheme: const PieButtonTheme(
                                                    backgroundColor: Colors.black26,
                                                    iconColor: Colors.pink,
                                                  ),
                                                  child: Icon(
                                                    isLiked
                                                        ? Icons.favorite
                                                        : Icons.favorite_outline,
                                                  ),
                                                ),
                                                PieAction(
                                                  tooltip: const Text(''),
                                                  onSelect: () async {
                                                    await Share.shareUri(Uri.parse(g.url));
                                                  },
                                                  buttonTheme: const PieButtonTheme(
                                                    backgroundColor: Colors.black26,
                                                    iconColor: Colors.black87,
                                                  ),
                                                  child: const Icon(
                                                    Icons.share_outlined,
                                                  ),
                                                ),
                                                PieAction(
                                                  tooltip: const Text(''),
                                                  onSelect: () {
                                                    int co = 0;

                                                    FileDownloader.downloadFile(
                                                      url: g.url,
                                                      notificationType: NotificationType.all,
                                                      onProgress: (fileName, progress) {
                                                        if (co == 0) {
                                                          Utils().showToast(
                                                              context: context,
                                                              message: 'Download Starting');
                                                          co++;
                                                        }
                                                      },
                                                      onDownloadCompleted: (String path) async {
                                                        Utils().showToast(
                                                            context: context,
                                                            message: 'Photo Downloaded!');
                                                      },
                                                      onDownloadError: (String error) {
                                                        Utils().showToast(
                                                            context: context, message: error);
                                                      },
                                                    );
                                                  },
                                                  buttonTheme: const PieButtonTheme(
                                                    backgroundColor: Colors.black26,
                                                    iconColor: Colors.black87,
                                                  ),
                                                  child: const Icon(
                                                    Icons.download_outlined,
                                                  ),
                                                ),
                                                if (UserSharedPreferences.role == 'teacher')
                                                  PieAction(
                                                    tooltip: const Text(''),
                                                    onSelect: () => showDialogForDelete(
                                                      context: context,
                                                      text:
                                                          'Are you sure you want to delete this photo?',
                                                      onDelete: () async {
                                                        await gallery.deleteSchoolGallery(
                                                            context: context, sgid: g.sgid);
                                                      },
                                                      onOk: () => Navigator.pop(context),
                                                    ),
                                                    buttonTheme: const PieButtonTheme(
                                                      backgroundColor: Colors.black26,
                                                      iconColor: Colors.red,
                                                    ),
                                                    child: const Icon(
                                                      Icons.delete_outline,
                                                    ),
                                                  ),
                                              ],
                                              child: Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(15),
                                                    child: Image.network(g.url),
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    right: 0,
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.favorite,
                                                          color: Colors.pink,
                                                          size: 15,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          g.noOfLikes,
                                                          style: GoogleFonts.rubik(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: UserSharedPreferences.role == 'teacher'
              ? GestureDetector(
                  onTap: () => bottomSheetForSchoolPhoto(context: context),
                  child: Container(
                    height: 60,
                    width: 60,
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [Color(0xFF2855AE), Color(0xFF7292CF)],
                      ),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
