import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:online_college/consts/subjects.dart';
import 'package:online_college/consts/utils.dart';
import 'package:online_college/model/assignment_model.dart';
import 'package:online_college/providers/assignment_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/v4.dart';

List<String> getSub({required String year}) {
  return year == '1st Year'
      ? year1
      : year == '2nd Year'
          ? year2
          : year == '3rd Year'
              ? year3
              : year4;
}

List<DropdownMenuItem<String>> getDropDownMenu({required List<String> subs}) {
  List<DropdownMenuItem<String>> dropDownList = [];

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

  return dropDownList;
}

bottomSheetForAssignment({
  bool isEdit = false,
  AssignmentModel? assignmentModel,
  required BuildContext context,
}) {
  bool isLoading = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  DateTime lastDateTime = DateTime.now().add(const Duration(days: 7));

  List<DropdownMenuItem<String>> dropDownList = [];
  List<String> subs = [];

  yearController.text = '1st Year';
  subs = getSub(year: yearController.text);
  dropDownList = getDropDownMenu(subs: subs);

  if (assignmentModel != null) {
    titleController.text = assignmentModel.title;
    yearController.text = assignmentModel.year;
    subjectController.text = assignmentModel.subject;
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
            height: 390,
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
                              subs = getSub(year: value);
                              dropDownList = getDropDownMenu(subs: subs);

                              subjectController.text = dropDownList[0].value!;
                            }
                            set(() {});
                          },
                          dropdownColor: Colors.white,
                          iconEnabledColor: Colors.white,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.person_add_outlined,
                              color: Color(0xFF6688CA),
                            ),
                            label: Text(
                              'Year',
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
                          onChanged: (value) {
                            if (value != null) {
                              subjectController.text = value;
                            }
                          },
                          dropdownColor: Colors.white,
                          iconEnabledColor: Colors.white,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.subject_outlined,
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
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            alignment: Alignment.center,
                            child: Text(
                              'Due Date: ',
                              style: GoogleFonts.rubik(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: lastDateTime,
                                firstDate: DateTime.now().add(const Duration(days: 7)),
                                lastDate: DateTime.now().add(const Duration(days: 180)),
                                helpText: 'Select the date: ',
                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                        colorScheme: const ColorScheme(
                                          brightness: Brightness.light,
                                          primary: Color(0xFF6688CA),
                                          onPrimary: Colors.white,
                                          secondary: Color(0xFF6688CA),
                                          onSecondary: Colors.white,
                                          error: Color(0xFF6688CA),
                                          onError: Colors.white,
                                          background: Colors.white,
                                          onBackground: Color(0xFF6688CA),
                                          surface: Colors.white,
                                          onSurface: Color(0xFF6688CA),
                                        ),
                                        textTheme: GoogleFonts.rubikTextTheme().copyWith(
                                          bodyMedium: GoogleFonts.rubik(
                                            fontSize: 16,
                                            color: const Color(0xFF6688CA),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )),
                                    child: child!,
                                  );
                                },
                              );

                              if (pickedDate != null) {
                                set(() {
                                  lastDateTime = lastDateTime.copyWith(
                                    day: pickedDate.day,
                                    month: pickedDate.month,
                                    year: pickedDate.year,
                                  );
                                });
                              }
                            },
                            child: Container(
                              height: 40,
                              width: 150,
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                DateFormat('dd/MM/yyyy').format(lastDateTime),
                                style: GoogleFonts.rubik(
                                  color: const Color(0xFF6688CA),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
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
                                    message: 'Please fill the title to add Assignment');
                              } else {
                                if (isEdit) {
                                  AssignmentModel assignment = AssignmentModel(
                                    aid: assignmentModel!.aid,
                                    year: yearController.text,
                                    subject: subjectController.text,
                                    title: titleController.text,
                                    createdDateTime: assignmentModel.createdDateTime,
                                    lastDateTime: lastDateTime.toString(),
                                    submitted: assignmentModel.submitted,
                                  );

                                  await Provider.of<AssignmentProvider>(context, listen: false)
                                      .updateAssignment(
                                          context: context, assignmentModel: assignment);
                                } else {
                                  String aid = const UuidV4().generate().toString();

                                  AssignmentModel assignment = AssignmentModel(
                                    aid: aid,
                                    year: yearController.text,
                                    subject: subjectController.text,
                                    title: titleController.text,
                                    createdDateTime: DateTime.now().toString(),
                                    lastDateTime: lastDateTime.toString(),
                                    submitted: [],
                                  );

                                  await Provider.of<AssignmentProvider>(context, listen: false)
                                      .addAssignment(context: context, assignmentModel: assignment);
                                }

                                isLoading = false;
                                set(() {});

                                if (!context.mounted) return;
                                Navigator.pop(context);
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
