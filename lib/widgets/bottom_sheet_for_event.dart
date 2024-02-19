import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:online_college/consts/utils.dart';
import 'package:online_college/model/event_model.dart';
import 'package:online_college/providers/event_provider.dart';
import 'package:online_college/repositories/event_firestore.dart';
import 'package:provider/provider.dart';
import 'package:uuid/v4.dart';

bottomSheetForEvent({
  bool isEdit = false,
  EventModel? eventModel,
  required BuildContext context,
}) {
  bool isLoading = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime dateTime = DateTime.now();
  String url = '';
  PlatformFile platformFile;
  String eid = '';

  if (eventModel != null) {
    url = eventModel.url;
    titleController.text = eventModel.title;
    descriptionController.text = eventModel.description;
    dateTime = DateTime.parse(eventModel.dateTime);
  } else {
    eid = const UuidV4().generate().toString();
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
            height: url == '' ? 520 : 560,
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
                                firstDate: DateTime.now(),
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
                              'Time: ',
                              style: GoogleFonts.robotoMono(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              TimeOfDay? time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(dateTime),
                                helpText: 'Select the time: ',
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
                                      textTheme: GoogleFonts.robotoMonoTextTheme().copyWith(
                                        bodyMedium: GoogleFonts.rubik(
                                          fontSize: 16,
                                          color: const Color(0xFF6688CA),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );

                              if (time != null) {
                                set(() {
                                  dateTime = dateTime.copyWith(
                                    hour: time.hour,
                                    minute: time.minute,
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
                                DateFormat('HH:mm a').format(dateTime),
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
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          final value = await FilePicker.platform.pickFiles(type: FileType.image);

                          if (value != null) {
                            platformFile = value.files[0];

                            if (!context.mounted) return;
                            url = await EventFireStore().uploadFile(
                                    context: context,
                                    pickedFile: platformFile,
                                    eid: isEdit ? eventModel!.eid : eid) ??
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
                                    message: 'Please fill the title to add Event');
                              } else if (descriptionController.text.isEmpty) {
                                Utils().showToast(
                                    context: context,
                                    message: 'Please fill the description to add Event');
                              } else if (!dateTime.isAfter(DateTime.now())) {
                                Utils().showToast(
                                    context: context,
                                    message: 'Please choose right date and time to add Event');
                              } else if (url == '') {
                                Utils().showToast(
                                    context: context,
                                    message: 'Please choose right date and time to add Event');
                              } else {
                                if (isEdit) {
                                  EventModel event = EventModel(
                                      eid: eventModel!.eid,
                                      title: titleController.text,
                                      description: descriptionController.text,
                                      url: url,
                                      dateTime: dateTime.toString());

                                  await Provider.of<EventProvider>(context, listen: false)
                                      .updateEvent(context: context, eventModel: event);

                                  if (!context.mounted) return;
                                  Navigator.of(context).pop();
                                } else {
                                  EventModel event = EventModel(
                                      eid: eid,
                                      title: titleController.text,
                                      description: descriptionController.text,
                                      url: url,
                                      dateTime: dateTime.toString());

                                  await Provider.of<EventProvider>(context, listen: false)
                                      .addEvent(context: context, eventModel: event);

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
