import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_college/model/teacher_user_model.dart';
import 'package:provider/provider.dart';

import '../../providers/all_user_provider.dart';
import '../../widgets/bottom_sheet_for_teacher.dart';

class ProfessorListScreen extends StatefulWidget {
  const ProfessorListScreen({Key? key}) : super(key: key);

  @override
  State<ProfessorListScreen> createState() => _ProfessorListScreenState();
}

class _ProfessorListScreenState extends State<ProfessorListScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AllUserProvider>(context, listen: false).getAllUser(context: context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/images/background 1.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          Consumer<AllUserProvider>(
            builder: (context, users, child) {
              List<TeacherUserModel> u = users.teachersList;

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    foregroundColor: Colors.white,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [Color(0xFF2855AE), Color(0xFF7292CF)],
                          ),
                        ),
                        child: Image.asset('assets/images/background.png'),
                      ),
                    ),
                    bottom: PreferredSize(
                      preferredSize: Size(MediaQuery.of(context).size.width, 40),
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40), topLeft: Radius.circular(40)),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    title: Text(
                      'Professors',
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        users.isLoading
                            ? SizedBox(
                                height: MediaQuery.of(context).size.height - 200,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF2855AE),
                                  ),
                                ),
                              )
                            : u.isNotEmpty
                                ? Container(
                                    height: MediaQuery.of(context).size.height - 197,
                                    margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: u.length,
                                      itemBuilder: (context, index) {
                                        TeacherUserModel tu = u[index];

                                        return Container(
                                          height: 80,
                                          padding: const EdgeInsets.all(10),
                                          margin: const EdgeInsets.only(bottom: 20),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                              color: Colors.black38,
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Hero(
                                                tag: tu.id!,
                                                child: Container(
                                                  height: 60,
                                                  width: 60,
                                                  decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    gradient: LinearGradient(
                                                      begin: Alignment.centerRight,
                                                      end: Alignment.centerLeft,
                                                      colors: [
                                                        Color(0xFF2855AE),
                                                        Color(0xFF7292CF)
                                                      ],
                                                    ),
                                                  ),
                                                  clipBehavior: Clip.antiAlias,
                                                  child: Image.network(
                                                    tu.photoUrl ?? '',
                                                    fit: BoxFit.fitHeight,
                                                    errorBuilder: (BuildContext context,
                                                        Object error, StackTrace? stackTrace) {
                                                      return Image.asset(
                                                        'assets/images/student.png',
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      tu.name!,
                                                      style: GoogleFonts.rubik(
                                                        color: Colors.black87,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      '+91 ${tu.phoneNumber!}',
                                                      style: GoogleFonts.rubik(
                                                        color: Colors.black54,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : SizedBox(
                                    height: MediaQuery.of(context).size.height - 200,
                                    child: Center(
                                      child: Text(
                                        'There is not teacher.',
                                        style: GoogleFonts.rubik(
                                          color: Colors.black54,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: GestureDetector(
        onTap: () async {
          await bottomSheetForTeacher(context: context);
        },
        child: Container(
          height: 60,
          width: 60,
          margin: const EdgeInsets.only(bottom: 15),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [Color(0xFF2855AE), Color(0xFF7292CF)],
            ),
          ),
          child: const Icon(
            Icons.add,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
