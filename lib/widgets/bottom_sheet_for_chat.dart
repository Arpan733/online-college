import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/consts/utils.dart';
import 'package:online_college/providers/doubt_provider.dart';
import 'package:provider/provider.dart';

import '../model/doubt_model.dart';

bottomSheetForChat({
  required DoubtModel doubtModel,
  required BuildContext context,
}) {
  TextEditingController titleController = TextEditingController();

  showModalBottomSheet(
    enableDrag: true,
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, set) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: 160,
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
                          Utils().showToast('Enter the title for create a doubt');
                        } else {
                          DoubtModel doubt = doubtModel;

                          Chat c = Chat(
                            message: titleController.text,
                            time: DateTime.now().toString(),
                            id: UserSharedPreferences.id,
                            role: UserSharedPreferences.role,
                          );

                          print(c);

                          doubt.chat.add(c);

                          Provider.of<DoubtProvider>(context, listen: false)
                              .updateDoubt(doubtModel: doubt);

                          titleController.clear();
                          doubt = DoubtModel(
                              year: '', subject: '', did: '', createdTime: '', title: '', chat: []);
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
