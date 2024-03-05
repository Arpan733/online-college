import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_college/consts/utils.dart';
import 'package:online_college/model/material_model.dart';
import 'package:online_college/providers/material_provider.dart';
import 'package:online_college/repositories/material_firestore.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:uuid/v4.dart';

bottomSheetForMaterial({
  bool isEdit = false,
  MaterialModel? materialModel,
  required BuildContext context,
}) {
  bool isLoading = false;
  TextEditingController titleController = TextEditingController();
  List<PlatformFile> files = [];
  List<String> selectedYears = [];

  if (isEdit) {
    titleController.text = materialModel!.title;
    selectedYears = materialModel.year;
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

  showModalBottomSheet(
    enableDrag: true,
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, set) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: files.isNotEmpty ? 430 : 390,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [Color(0xFF2855AE), Color(0xFF7292CF)],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              image: DecorationImage(
                image: AssetImage('assets/images/background 2.png'),
              ),
            ),
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF2855AE),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          controller: titleController,
                          cursorColor: const Color(0xFF6688CA),
                          cursorWidth: 3,
                          maxLines: 1,
                          style: GoogleFonts.rubik(
                            color: const Color(0xFF6688CA),
                          ),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.description_outlined,
                              color: Color(0xFF6688CA),
                            ),
                            label: Text(
                              'Title',
                              style: GoogleFonts.rubik(
                                color: const Color(0xFF6688CA),
                              ),
                            ),
                            hintText: 'Title',
                            hintStyle: GoogleFonts.rubik(
                              color: const Color(0xFF6688CA),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 60) * 0.5,
                            child: CheckboxListTile(
                              title: Text(
                                '1st Year',
                                style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              value: selectedYears.contains('1st Year'),
                              activeColor: Colors.white,
                              checkColor: const Color(0xFF6688CA),
                              onChanged: (value) {
                                if (value != null) {
                                  set(() {
                                    if (value) {
                                      selectedYears.add('1st Year');
                                    } else {
                                      selectedYears.remove('1st Year');
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 60) * 0.5,
                            child: CheckboxListTile(
                              title: Text(
                                '2nd Year',
                                style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              value: selectedYears.contains('2nd Year'),
                              activeColor: Colors.white,
                              checkColor: const Color(0xFF6688CA),
                              onChanged: (value) {
                                if (value != null) {
                                  set(() {
                                    if (value) {
                                      selectedYears.add('2nd Year');
                                    } else {
                                      selectedYears.remove('2nd Year');
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 60) * 0.5,
                            child: CheckboxListTile(
                              title: Text(
                                '3rd Year',
                                style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              value: selectedYears.contains('3rd Year'),
                              activeColor: Colors.white,
                              checkColor: const Color(0xFF6688CA),
                              onChanged: (value) {
                                if (value != null) {
                                  set(() {
                                    if (value) {
                                      selectedYears.add('3rd Year');
                                    } else {
                                      selectedYears.remove('3rd Year');
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 60) * 0.5,
                            child: CheckboxListTile(
                              title: Text(
                                '4th Year',
                                style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              value: selectedYears.contains('4th Year'),
                              activeColor: Colors.white,
                              checkColor: const Color(0xFF6688CA),
                              onChanged: (value) {
                                if (value != null) {
                                  set(() {
                                    if (value) {
                                      selectedYears.add('4th Year');
                                    } else {
                                      selectedYears.remove('4th Year');
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: files.isEmpty ? 50 : MediaQuery.of(context).size.width - 40,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () async {
                                final value = await FilePicker.platform.pickFiles(
                                  allowMultiple: true,
                                );

                                if (value != null) {
                                  List<PlatformFile> pickedFiles = value.files;

                                  files = pickedFiles;
                                }

                                set(() {});
                              },
                              icon: const Icon(
                                Icons.attach_file_outlined,
                                color: Color(0xFF6688CA),
                              ),
                            ),
                            files.isNotEmpty
                                ? SizedBox(
                                    height: 80,
                                    width: (files.length + 1) < 7
                                        ? (files.length + 1) * 50
                                        : MediaQuery.of(context).size.width - 90,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: files.length + 1,
                                      itemBuilder: (context, index) {
                                        if (files.length == index) {
                                          return Container(
                                            width: 40,
                                            alignment: Alignment.center,
                                            child: IconButton(
                                              onPressed: () async {
                                                final value = await FilePicker.platform.pickFiles(
                                                  allowMultiple: true,
                                                );

                                                if (value != null) {
                                                  List<PlatformFile> pickedFiles = value.files;

                                                  for (var element in pickedFiles) {
                                                    files.add(element);
                                                  }
                                                }

                                                set(() {});
                                              },
                                              icon: const Icon(
                                                Icons.add_circle,
                                                color: Color(0xFF6688CA),
                                                size: 20,
                                              ),
                                            ),
                                          );
                                        }

                                        return GestureDetector(
                                          onTap: () async {
                                            await OpenFile.open(files[index].path);
                                          },
                                          child: Container(
                                            width: 40,
                                            margin: const EdgeInsets.all(5),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  top: 4,
                                                  left: 5,
                                                  child: Container(
                                                    height: 50,
                                                    width: 30,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: getColor(e: files[index].extension!),
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    child: Text(
                                                      '.${files[index].extension!}',
                                                      style: GoogleFonts.rubik(
                                                        fontSize: 10,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 4,
                                                  child: Text(
                                                    files[index].name,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.rubik(
                                                      color: const Color(0xFF6688CA),
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      files.removeAt(index);
                                                      set(() {});
                                                    },
                                                    child: Container(
                                                      height: 15,
                                                      width: 15,
                                                      decoration: const BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      alignment: Alignment.center,
                                                      child: const Icon(
                                                        Icons.delete_outline,
                                                        color: Colors.red,
                                                        size: 10,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              height: 40,
                              width: 150,
                              margin: const EdgeInsets.only(top: 20),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              isLoading = true;
                              set(() {});

                              if (titleController.text.isEmpty) {
                                Utils().showToast(
                                    context: context, message: 'Enter the title in materials');
                              } else if (files.isEmpty) {
                                Utils().showToast(
                                    context: context, message: 'You have to add at least one file');
                              } else {
                                if (isEdit) {
                                  await MaterialFireStore()
                                      .deleteFiles(context: context, mid: materialModel!.mid);

                                  List<Materialss> attach = [];

                                  if (!context.mounted) return;
                                  if (files.isNotEmpty) {
                                    for (var element in files) {
                                      String? url = await MaterialFireStore().uploadFile(
                                        context: context,
                                        pickedFile: element,
                                        mid: materialModel.mid,
                                      );

                                      if (url != null) {
                                        attach.add(
                                          Materialss(
                                            name: element.name,
                                            extension: element.extension.toString(),
                                            url: url,
                                          ),
                                        );
                                      }
                                    }
                                  }

                                  MaterialModel material = MaterialModel(
                                      createdTime: DateTime.now().toString(),
                                      mid: materialModel.mid,
                                      title: titleController.text,
                                      year: selectedYears,
                                      materials: attach);

                                  if (!context.mounted) return;
                                  Provider.of<MaterialProvider>(context, listen: false)
                                      .addMaterial(context: context, materialModel: material);
                                } else {
                                  String mid = const UuidV4().generate().toString();
                                  List<Materialss> attach = [];

                                  if (files.isNotEmpty) {
                                    for (var element in files) {
                                      String? url = await MaterialFireStore().uploadFile(
                                        context: context,
                                        pickedFile: element,
                                        mid: mid,
                                      );

                                      if (url != null) {
                                        attach.add(
                                          Materialss(
                                            name: element.name,
                                            extension: element.extension.toString(),
                                            url: url,
                                          ),
                                        );
                                      }
                                    }
                                  }

                                  MaterialModel material = MaterialModel(
                                      createdTime: DateTime.now().toString(),
                                      mid: mid,
                                      title: titleController.text,
                                      year: selectedYears,
                                      materials: attach);

                                  if (!context.mounted) return;
                                  Provider.of<MaterialProvider>(context, listen: false)
                                      .addMaterial(context: context, materialModel: material);
                                }

                                isLoading = false;
                                set(() {});

                                if (!context.mounted) return;
                                Navigator.of(context).pop();
                              }
                            },
                            child: Container(
                              height: 40,
                              width: 150,
                              margin: const EdgeInsets.only(top: 20),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Create',
                                style: GoogleFonts.rubik(
                                  color: const Color(0xFF6688CA),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        );
      });
    },
  );
}
