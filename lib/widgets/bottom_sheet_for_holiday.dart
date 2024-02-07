import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:online_college/consts/utils.dart';

import '../providers/holiday_provider.dart';

bottomSheetForHoliday({
  bool isEdit = false,
  String title = '',
  String description = '',
  String hid = '',
  String date = '',
  required BuildContext context,
}) {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime dateTime = DateTime.now();

  if (title != '' && description != '' && hid != '' && date != '') {
    titleController.text = title;
    descriptionController.text = description;
    dateTime = DateTime.parse(date);
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
            height: 400,
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      alignment: Alignment.center,
                      child: Text(
                        'Date: ',
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
                          initialDate: dateTime,
                          firstDate: DateTime(2023),
                          lastDate: DateTime(2030),
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
                            dateTime = dateTime.copyWith(
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
                          DateFormat('dd/MM/yyyy').format(dateTime),
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
                        if (titleController.text.isEmpty) {
                          Utils().showToast('Please fill the title to add Holiday');
                        } else if (descriptionController.text.isEmpty) {
                          Utils().showToast('Please fill the description to add Holiday');
                        } else if (!dateTime.isAfter(DateTime.now())) {
                          Utils().showToast('Please choose right date to add Holiday');
                        } else {
                          if (isEdit) {
                            await getHolidayProvider(context).editHoliday(
                              title: titleController.text,
                              description: descriptionController.text,
                              date: dateTime.toString(),
                              hid: hid,
                            );

                            if (!context.mounted) return;
                            await getHolidayProvider(context).getHolidayList();
                          } else {
                            await getHolidayProvider(context).addHoliday(
                              title: titleController.text,
                              description: descriptionController.text,
                              date: dateTime.toString(),
                            );

                            if (!context.mounted) return;
                            await getHolidayProvider(context).getHolidayList();
                          }

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
