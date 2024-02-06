import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_college/consts/utils.dart';
import 'package:online_college/model/student_user_model.dart';
import 'package:online_college/providers/all_user_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/v4.dart';

bool checkRollNo({required BuildContext context, required String rollNo}) {
  int t = 0;

  Provider.of<AllUserProvider>(context, listen: false).studentsList.forEach((element) {
    if (element.rollNo == rollNo) {
      t++;
    }
  });

  return t != 0;
}

bool checkPhoneNumber({required BuildContext context, required String phoneNumber}) {
  int t = 0;

  Provider.of<AllUserProvider>(context, listen: false).studentsList.forEach((element) {
    if (element.phoneNumber == phoneNumber) {
      t++;
    }
  });

  return t != 0;
}

bottomSheetForStudent({
  bool isEdit = false,
  String name = '',
  String phoneNumber = '',
  String year = '',
  String rollNo = '',
  String role = '',
  String id = '',
  required BuildContext context,
}) {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController rollNoController = TextEditingController();

  yearController.text = '1st Year';

  if (name != '' && phoneNumber != '' && year != '' && rollNo != '' && role != '' && id != '') {
    nameController.text = name;
    phoneNumberController.text = phoneNumber;
    yearController.text = year;
    rollNoController.text = rollNo;
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
            height: 440,
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
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width - 40,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: const Icon(
                          Icons.phone_outlined,
                          color: Color(0xFF6688CA),
                        ),
                      ),
                      Flexible(
                        child: DropdownButtonFormField<String>(
                          padding: const EdgeInsets.only(left: 10),
                          value: yearController.text,
                          items: [
                            DropdownMenuItem(
                              value: '1st Year',
                              child: Text(
                                '1st Year',
                                style: GoogleFonts.rubik(
                                  color: const Color(0xFF6688CA),
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '2nd Year',
                              child: Text(
                                '2nd Year',
                                style: GoogleFonts.rubik(
                                  color: const Color(0xFF6688CA),
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '3rd Year',
                              child: Text(
                                '3rd Year',
                                style: GoogleFonts.rubik(
                                  color: const Color(0xFF6688CA),
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '4th Year',
                              child: Text(
                                '4th Year',
                                style: GoogleFonts.rubik(
                                  color: const Color(0xFF6688CA),
                                ),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              yearController.text = value;
                              set(() {});
                            }
                          },
                          dropdownColor: Colors.white,
                          iconEnabledColor: Colors.white,
                          decoration: const InputDecoration(
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xFF2855AE),
                              size: 30,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
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
                    controller: rollNoController,
                    cursorColor: const Color(0xFF6688CA),
                    cursorWidth: 3,
                    style: GoogleFonts.rubik(
                      color: const Color(0xFF6688CA),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.confirmation_num_outlined,
                        color: Color(0xFF6688CA),
                      ),
                      label: Text(
                        'Roll No',
                        style: GoogleFonts.rubik(
                          color: const Color(0xFF6688CA),
                        ),
                      ),
                      hintText: 'Roll No',
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
                          Utils().showToast('Please fill the name for the student');
                        } else if (phoneNumberController.text.isEmpty) {
                          Utils().showToast('Please fill the phone number for the student');
                        } else if (checkPhoneNumber(
                            context: context, phoneNumber: phoneNumberController.text)) {
                          Utils().showToast('Please fill unique phone number for the student');
                        } else if (checkRollNo(context: context, rollNo: rollNoController.text)) {
                          Utils().showToast('Please fill unique roll no for the student');
                        } else {
                          StudentUserModel studentUserModel = StudentUserModel(
                            name: nameController.text,
                            phoneNumber: phoneNumberController.text,
                            year: yearController.text,
                            rollNo: rollNoController.text,
                            id: const UuidV4().generate().toString(),
                            role: 'student',
                          );

                          await Provider.of<AllUserProvider>(context, listen: false)
                              .addStudentUser(studentUserModel: studentUserModel);

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
