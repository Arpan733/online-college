import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_college/consts/utils.dart';
import 'package:online_college/providers/all_user_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/v4.dart';

import '../model/teacher_user_model.dart';

bool checkPhoneNumber({required BuildContext context, required String phoneNumber}) {
  int t = 0;

  Provider.of<AllUserProvider>(context, listen: false).teachersList.forEach((element) {
    if (element.phoneNumber == phoneNumber) {
      t++;
    }
  });

  return t != 0;
}

bottomSheetForTeacher({
  bool isEdit = false,
  String name = '',
  String phoneNumber = '',
  String role = '',
  String id = '',
  required BuildContext context,
}) {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  if (name != '' && phoneNumber != '' && role != '' && id != '') {
    nameController.text = name;
    phoneNumberController.text = phoneNumber;
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
            height: 270,
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
                    controller: nameController,
                    cursorColor: const Color(0xFF6688CA),
                    cursorWidth: 3,
                    style: GoogleFonts.rubik(
                      color: const Color(0xFF6688CA),
                    ),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.person_outlined,
                        color: Color(0xFF6688CA),
                      ),
                      label: Text(
                        'Name',
                        style: GoogleFonts.rubik(
                          color: const Color(0xFF6688CA),
                        ),
                      ),
                      hintText: 'Name',
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
                    controller: phoneNumberController,
                    cursorColor: const Color(0xFF6688CA),
                    cursorWidth: 3,
                    style: GoogleFonts.rubik(
                      color: const Color(0xFF6688CA),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.phone_outlined,
                        color: Color(0xFF6688CA),
                      ),
                      label: Text(
                        'Phone No',
                        style: GoogleFonts.rubik(
                          color: const Color(0xFF6688CA),
                        ),
                      ),
                      hintText: 'Phone No',
                      hintStyle: GoogleFonts.rubik(
                        color: const Color(0xFF6688CA),
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
                        margin: const EdgeInsets.only(top: 30),
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
                        if (nameController.text.isEmpty) {
                          Utils().showToast('Please fill the name for the teacher');
                        } else if (phoneNumberController.text.isEmpty) {
                          Utils().showToast('Please fill the phone number for the teacher');
                        } else if (checkPhoneNumber(
                            context: context, phoneNumber: phoneNumberController.text)) {
                          Utils().showToast('Please fill unique phone number for the teacher');
                        } else {
                          TeacherUserModel teacherUserModel = TeacherUserModel(
                            name: nameController.text,
                            phoneNumber: phoneNumberController.text,
                            id: const UuidV4().generate().toString(),
                            role: 'teacher',
                          );

                          await Provider.of<AllUserProvider>(context, listen: false)
                              .addTeacherUser(teacherUserModel: teacherUserModel);

                          if (!context.mounted) return;
                          Navigator.of(context).pop();
                        }
                      },
                      child: Container(
                        height: 40,
                        width: 150,
                        margin: const EdgeInsets.only(top: 30),
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
