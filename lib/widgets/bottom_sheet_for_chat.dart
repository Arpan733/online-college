import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/consts/utils.dart';
import 'package:online_college/providers/doubt_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

import '../model/doubt_model.dart';
import '../repositories/doubt_firestore.dart';

bottomSheetForChat({
  required DoubtModel doubtModel,
  required BuildContext context,
}) {
  bool isLoading = false;
  TextEditingController titleController = TextEditingController();
  List<PlatformFile> files = [];

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
            height: files.isNotEmpty ? 310 : 270,
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
                          maxLines: 3,
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
                                    context: context,
                                    message: 'Enter the description for comment in doubt');
                              } else {
                                String dateTime = DateTime.now().toString();
                                List<Attach> attach = [];
                                DoubtModel doubt = doubtModel;

                                if (files.isNotEmpty) {
                                  for (var element in files) {
                                    String? url = await DoubtFireStore().uploadFile(
                                        context: context,
                                        pickedFile: element,
                                        did: doubt.did,
                                        time: dateTime);

                                    if (url != null) {
                                      attach.add(
                                        Attach(
                                          name: element.name,
                                          extension: element.extension ?? '',
                                          url: url,
                                        ),
                                      );
                                    }
                                  }
                                }

                                Chat c = Chat(
                                  message: titleController.text,
                                  time: dateTime,
                                  id: UserSharedPreferences.id,
                                  role: UserSharedPreferences.role,
                                  attach: attach,
                                );

                                doubt.chat.add(c);

                                if (!context.mounted) return;
                                Provider.of<DoubtProvider>(context, listen: false)
                                    .updateDoubt(context: context, doubtModel: doubt);

                                titleController.clear();
                                doubt = DoubtModel(
                                  year: '',
                                  subject: '',
                                  did: '',
                                  createdTime: '',
                                  title: '',
                                  chat: [],
                                );

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
