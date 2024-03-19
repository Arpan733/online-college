import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/consts/utils.dart';
import 'package:online_college/model/material_model.dart';
import 'package:online_college/providers/material_provider.dart';
import 'package:online_college/widgets/bottom_sheet_for_material.dart';
import 'package:online_college/widgets/dialog_for_delete.dart';
import 'package:open_file/open_file.dart';
import 'package:pie_menu/pie_menu.dart';
import 'package:provider/provider.dart';

class MaterialScreen extends StatefulWidget {
  const MaterialScreen({super.key});

  @override
  State<MaterialScreen> createState() => _MaterialScreenState();
}

class _MaterialScreenState extends State<MaterialScreen> {
  List<List<String>> paths = [];
  String sort = 'All';

  List<String> dropDownList = UserSharedPreferences.role == 'teacher'
      ? ["All", "Uploaded Time", "1st Year", "2nd Year", "3rd Year", "4th Year"]
      : ["All", "Uploaded Time"];

  List<DropdownMenuItem<String>> dropDowns = [];

  List<MaterialModel> showMaterialList = [];

  @override
  void initState() {
    for (var element in dropDownList) {
      dropDowns.add(
        DropdownMenuItem(
          value: element,
          child: Text(
            element,
            style: GoogleFonts.rubik(
              color: const Color(0xFF2855AE),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<MaterialProvider>(context, listen: false).getMaterialList(context: context);
    });

    super.initState();
  }

  Color getColor({required String e}) {
    return e.toLowerCase() == 'png'
        ? Colors.amber
        : e.toLowerCase() == 'pdf'
            ? Colors.redAccent
            : e.toLowerCase() == 'mp3' || e.toLowerCase() == 'mp4'
                ? Colors.blueAccent
                : Colors.greenAccent;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Provider.of<MaterialProvider>(context, listen: false)
            .getMaterialList(context: context);
        setState(() {});

        if (!context.mounted) return;
        showMaterialList = UserSharedPreferences.role == 'teacher'
            ? Provider.of<MaterialProvider>(context, listen: false)
                .teacherSorting(context: context, sort: sort)
            : Provider.of<MaterialProvider>(context, listen: false)
                .studentSorting(context: context, sort: sort);
      },
      backgroundColor: const Color(0xFF2855AE),
      color: Colors.white,
      child: PieCanvas(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Positioned(
                bottom: 0,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'assets/images/background 1.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
              Consumer<MaterialProvider>(
                builder: (context, material, _) {
                  showMaterialList = UserSharedPreferences.role == 'teacher'
                      ? material.teacherSorting(context: context, sort: sort)
                      : material.studentSorting(context: context, sort: sort);

                  return StatefulBuilder(
                    builder: (context, set) => CustomScrollView(
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
                            'Materials',
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                DropdownButtonFormField<String>(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  value: sort,
                                  items: dropDowns,
                                  onChanged: (value) {
                                    if (value != null) {
                                      sort = value;
                                      showMaterialList = UserSharedPreferences.role == 'teacher'
                                          ? material.teacherSorting(context: context, sort: sort)
                                          : material.studentSorting(context: context, sort: sort);

                                      set(() {});
                                    }
                                  },
                                  dropdownColor: Colors.white,
                                  iconEnabledColor: Colors.white,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.filter_alt_outlined,
                                      color: Color(0xFF2855AE),
                                      size: 20,
                                    ),
                                    suffixIcon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Color(0xFF2855AE),
                                      size: 30,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          sliver: SliverList.builder(
                            itemCount: showMaterialList.isEmpty ? 1 : showMaterialList.length,
                            itemBuilder: (context, index) {
                              if (material.isLoading) {
                                return SizedBox(
                                  height: MediaQuery.of(context).size.height - 200,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF2855AE),
                                    ),
                                  ),
                                );
                              }

                              if (showMaterialList.isEmpty) {
                                return SizedBox(
                                  height: MediaQuery.of(context).size.height - 200,
                                  child: Center(
                                    child: Text(
                                      'There is no material',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.rubik(
                                        color: Colors.black54,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              MaterialModel m = showMaterialList[index];

                              if (paths.length != showMaterialList.length) {
                                paths.add([]);
                              }

                              return PieMenu(
                                actions: [
                                  PieAction(
                                    tooltip: const Text(''),
                                    onSelect: () => showDialogForDelete(
                                      context: context,
                                      text: 'Are you sure you want to delete ${m.title} materials?',
                                      onDelete: () async {
                                        await material.deleteMaterial(context: context, mid: m.mid);

                                        if (!context.mounted) return;
                                        Navigator.pop(context);
                                      },
                                      onOk: () => Navigator.pop(context),
                                    ),
                                    buttonTheme: const PieButtonTheme(
                                      backgroundColor: Colors.black26,
                                      iconColor: Colors.black87,
                                    ),
                                    child: const Icon(
                                      Icons.delete,
                                    ),
                                  ),
                                  PieAction(
                                    tooltip: const Text(''),
                                    onSelect: () {
                                      if (UserSharedPreferences.role == 'teacher') {
                                        bottomSheetForMaterial(
                                            context: context, isEdit: true, materialModel: m);
                                      }
                                    },
                                    buttonTheme: const PieButtonTheme(
                                      backgroundColor: Colors.black26,
                                      iconColor: Colors.black87,
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                    ),
                                  )
                                ],
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.black38,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: m.year
                                            .map(
                                              (e) => Container(
                                                margin: const EdgeInsets.only(right: 10),
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 10, vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFE6EFFF),
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: Text(
                                                  e,
                                                  style: GoogleFonts.rubik(
                                                    color: const Color(0xFF6789CA),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        m.title,
                                        style: GoogleFonts.rubik(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Divider(),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      StatefulBuilder(
                                        builder: (context, set) => SizedBox(
                                          height: 100,
                                          width: MediaQuery.of(context).size.width - 60,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            padding: EdgeInsets.zero,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: m.materials.length,
                                            itemBuilder: (context, i) {
                                              if (paths[index].length != m.materials.length) {
                                                paths[index].add('');
                                              }

                                              return GestureDetector(
                                                onTap: () async {
                                                  int co = 0;

                                                  if (paths[index][i] == '') {
                                                    FileDownloader.downloadFile(
                                                      url: m.materials[i].url,
                                                      name: m.materials[i].name,
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
                                                        paths[index][i] = path;
                                                        set(() {});

                                                        Utils().showToast(
                                                            context: context,
                                                            message:
                                                                '${m.materials[i].name} downloaded');
                                                      },
                                                      onDownloadError: (String error) {
                                                        Utils().showToast(
                                                            context: context, message: error);
                                                      },
                                                    );
                                                  } else {
                                                    await OpenFile.open(
                                                        Uri.decodeFull(paths[index][i]));
                                                  }
                                                },
                                                child: Container(
                                                  width: 60,
                                                  margin: const EdgeInsets.all(5),
                                                  child: Stack(
                                                    children: [
                                                      Positioned(
                                                        left: 10,
                                                        child: Container(
                                                          height: 60,
                                                          width: 40,
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(
                                                            color: getColor(
                                                                e: m.materials[i].extension),
                                                            borderRadius: BorderRadius.circular(7),
                                                          ),
                                                          child: Image.network(
                                                            m.materials[i].url,
                                                            fit: BoxFit.fill,
                                                            errorBuilder:
                                                                (context, error, stackTrace) {
                                                              return Text(
                                                                '.${m.materials[i].extension}',
                                                                style: GoogleFonts.rubik(
                                                                  fontSize: 10,
                                                                  color: Colors.white,
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        bottom: 0,
                                                        child: Text(
                                                          m.materials[i].name,
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: GoogleFonts.rubik(
                                                            color: Colors.black87,
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 0,
                                                        right: 0,
                                                        child: Container(
                                                          height: 20,
                                                          width: 20,
                                                          alignment: Alignment.center,
                                                          decoration: const BoxDecoration(
                                                            color: Colors.white,
                                                            shape: BoxShape.circle,
                                                          ),
                                                          child: Icon(
                                                            paths[index][i] == ''
                                                                ? Icons.download_outlined
                                                                : Icons.file_open_outlined,
                                                            color: const Color(0xFF6688CA),
                                                            size: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: UserSharedPreferences.role == 'teacher'
              ? GestureDetector(
                  onTap: () => bottomSheetForMaterial(context: context),
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
