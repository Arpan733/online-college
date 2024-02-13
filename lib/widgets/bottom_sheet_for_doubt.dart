import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_college/consts/subjects.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/consts/utils.dart';
import 'package:provider/provider.dart';
import 'package:uuid/v4.dart';

import '../model/doubt_model.dart';
import '../providers/doubt_provider.dart';

bottomSheetForDoubt({
  required BuildContext context,
}) {
  TextEditingController titleController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  List<DropdownMenuItem<String>> dropDownList = [];
  List<String> subs = [];

  if (UserSharedPreferences.year == '1st Year') {
    subs = year1;
  } else if (UserSharedPreferences.year == '2nd Year') {
    subs = year2;
  } else if (UserSharedPreferences.year == '3rd Year') {
    subs = year3;
  } else if (UserSharedPreferences.year == '4th Year') {
    subs = year4;
  }

  for (var element in subs) {
    dropDownList.add(DropdownMenuItem<String>(
      value: element,
      child: Text(
        element,
        style: GoogleFonts.rubik(
          color: const Color(0xFF6688CA),
        ),
      ),
    ));
  }

  subjectController.text = subs[0];

  showModalBottomSheet(
    enableDrag: true,
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, set) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: 250,
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
            child: Column(
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
                  child: DropdownButtonFormField<String>(
                    value: subjectController.text,
                    items: dropDownList,
                    onChanged: (value) {},
                    dropdownColor: Colors.white,
                    iconEnabledColor: Colors.white,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.subject,
                        color: Color(0xFF6688CA),
                      ),
                      label: Text(
                        'Subject',
                        style: GoogleFonts.rubik(
                          color: const Color(0xFF6688CA),
                        ),
                      ),
                      suffixIcon: const Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFF2855AE),
                        size: 30,
                      ),
                      border: InputBorder.none,
                    ),
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
                        if (titleController.text.isEmpty) {
                          Utils().showToast(
                              context: context, message: 'Enter the title for create a doubt');
                        } else {
                          String did = const UuidV4().generate().toString();
                          DoubtModel doubtModel = DoubtModel(
                            year: UserSharedPreferences.year,
                            subject: subjectController.text,
                            did: did,
                            createdTime: DateTime.now().toString(),
                            title: titleController.text,
                            chat: [
                              Chat(
                                message: titleController.text,
                                time: DateTime.now().toString(),
                                id: UserSharedPreferences.id,
                                role: UserSharedPreferences.role,
                                attach: [],
                              ),
                            ],
                          );

                          Provider.of<DoubtProvider>(context, listen: false)
                              .addDoubt(context: context, doubtModel: doubtModel);
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
