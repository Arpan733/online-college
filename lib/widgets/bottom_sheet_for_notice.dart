import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_college/consts/utils.dart';
import 'package:online_college/model/notice_model.dart';
import 'package:online_college/providers/notice_provider.dart';
import 'package:online_college/repositories/notice_firestore.dart';
import 'package:provider/provider.dart';
import 'package:uuid/v4.dart';

bottomSheetForNotice({
  bool isEdit = false,
  NoticeModel? noticeModel,
  required BuildContext context,
}) {
  bool isLoading = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<String> selectedYears = [];

  String url = '';
  PlatformFile platformFile;
  String nid = '';

  if (noticeModel != null) {
    url = noticeModel.photoUrl;
    titleController.text = noticeModel.title;
    descriptionController.text = noticeModel.description;
    selectedYears = noticeModel.year;
  } else {
    nid = const UuidV4().generate().toString();
    selectedYears = ["1st Year", "2nd Year", "3rd Year", "4th Year"];
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
            height: url == '' ? 550 : 590,
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
                          style: GoogleFonts.rubik(
                            color: const Color(0xFF6688CA),
                          ),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.title_outlined,
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
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          controller: descriptionController,
                          cursorColor: const Color(0xFF6688CA),
                          cursorWidth: 3,
                          maxLines: 4,
                          style: GoogleFonts.rubik(
                            color: const Color(0xFF6688CA),
                          ),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.description_outlined,
                              color: Color(0xFF6688CA),
                            ),
                            label: Text(
                              'Description',
                              style: GoogleFonts.rubik(
                                color: const Color(0xFF6688CA),
                              ),
                            ),
                            hintText: 'Description',
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
                      GestureDetector(
                        onTap: () async {
                          final value = await FilePicker.platform.pickFiles(type: FileType.image);

                          if (value != null) {
                            platformFile = value.files[0];

                            if (!context.mounted) return;
                            url = await NoticeFireStore().uploadFile(
                                    context: context,
                                    pickedFile: platformFile,
                                    nid: isEdit ? noticeModel!.nid : nid) ??
                                "";
                          }

                          set(() {});
                        },
                        child: Container(
                          height: url == '' ? 60 : 100,
                          width: url == '' ? 60 : 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: url == ''
                              ? const Icon(
                                  Icons.attach_file_outlined,
                                  color: Color(0xFF6688CA),
                                  size: 20,
                                )
                              : Image.network(
                                  url,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container();
                                  },
                                ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          isEdit
                              ? SizedBox(
                                  width: 150,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 50,
                                          margin: const EdgeInsets.only(top: 20),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.close_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          await Provider.of<NoticeProvider>(context, listen: false)
                                              .deleteNotice(
                                                  context: context, nid: noticeModel!.nid);

                                          if (!context.mounted) return;
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 50,
                                          margin: const EdgeInsets.only(top: 20),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                              color: Colors.red,
                                              width: 2,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.delete_outline,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : GestureDetector(
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
                                    context: context,
                                    message: 'Please fill the title to add Notice');
                              } else if (descriptionController.text.isEmpty) {
                                Utils().showToast(
                                    context: context,
                                    message: 'Please fill the description to add Notice');
                              } else {
                                if (isEdit) {
                                  NoticeModel notice = NoticeModel(
                                    nid: noticeModel!.nid,
                                    title: titleController.text,
                                    description: descriptionController.text,
                                    photoUrl: url,
                                    year: selectedYears,
                                    createdTime: noticeModel.createdTime,
                                  );

                                  await Provider.of<NoticeProvider>(context, listen: false)
                                      .updateNotice(context: context, noticeModel: notice);

                                  if (!context.mounted) return;
                                  Navigator.of(context).pop();
                                } else {
                                  NoticeModel notice = NoticeModel(
                                    nid: nid,
                                    title: titleController.text,
                                    description: descriptionController.text,
                                    photoUrl: url,
                                    createdTime: DateTime.now().toString(),
                                    year: selectedYears,
                                  );

                                  await Provider.of<NoticeProvider>(context, listen: false)
                                      .addNotice(context: context, noticeModel: notice);

                                  if (!context.mounted) return;
                                  Navigator.of(context).pop();
                                }
                              }

                              isLoading = false;
                              set(() {});
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
                                isEdit ? 'Edit' : 'Add',
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
