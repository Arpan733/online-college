import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:online_college/consts/utils.dart';
import 'package:online_college/model/student_user_model.dart';
import 'package:online_college/providers/assignment_provider.dart';
import 'package:online_college/repositories/user_data_firestore.dart';
import 'package:online_college/widgets/bottom_sheet_for_assignment.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

class AssignmentDetailScreen extends StatefulWidget {
  final String aid;

  const AssignmentDetailScreen({super.key, required this.aid});

  @override
  State<AssignmentDetailScreen> createState() => _AssignmentDetailScreenState();
}

class _AssignmentDetailScreenState extends State<AssignmentDetailScreen> {
  List<String> downloaded = [];
  late AssignmentProvider provider;

  bool isLoading = false;
  List<StudentUserModel> paidStudentsData = [];

  @override
  void initState() {
    provider = Provider.of<AssignmentProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await provider.getAssignment(context: context, aid: widget.aid);
      getStudents();
    });

    super.initState();
  }

  getStudents() async {
    paidStudentsData = [];
    setState(() {
      isLoading = true;
    });

    if (provider.assignment.submitted.isNotEmpty) {
      for (var element in provider.assignment.submitted) {
        StudentUserModel? s =
            await UserDataFireStore().getStudentData(context: context, id: element.sid);

        if (s != null) {
          setState(() {
            paidStudentsData.add(s);
          });
        }
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await provider.getAssignment(context: context, aid: widget.aid);
        getStudents();

        setState(() {});
      },
      backgroundColor: const Color(0xFF2855AE),
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<AssignmentProvider>(
          builder: (context, assignment, child) => Stack(
            children: [
              Positioned(
                bottom: 0,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'assets/images/background 1.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
              assignment.isLoading
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF2855AE),
                        ),
                      ),
                    )
                  : StatefulBuilder(
                      builder: (context, set) => CustomScrollView(
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
                            title: TextScroll(
                              assignment.assignment.title,
                              mode: TextScrollMode.endless,
                              velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
                              delayBefore: const Duration(milliseconds: 1000),
                              pauseBetween: const Duration(milliseconds: 500),
                              style: GoogleFonts.rubik(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            actions: [
                              if (assignment.isLoading &&
                                  DateTime.now()
                                      .isAfter(DateTime.parse(assignment.assignment.lastDateTime)))
                                GestureDetector(
                                  onTap: () async {
                                    await Provider.of<AssignmentProvider>(context, listen: false)
                                        .deleteAssignment(
                                            context: context, aid: assignment.assignment.aid);

                                    if (!context.mounted) return;
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 40,
                                    margin: const EdgeInsets.only(right: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              GestureDetector(
                                onTap: () async {
                                  bottomSheetForAssignment(
                                      context: context,
                                      isEdit: true,
                                      assignmentModel: assignment.assignment);

                                  await provider.getAssignment(context: context, aid: widget.aid);
                                  getStudents();
                                },
                                child: Container(
                                  height: 30,
                                  width: 90,
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Icon(
                                        Icons.edit_outlined,
                                        color: Color(0xFF6688CA),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Edit',
                                        style: GoogleFonts.rubik(
                                          color: const Color(0xFF6688CA),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                Container(
                                  padding: const EdgeInsets.only(left: 20, right: 20),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Batch',
                                              style: GoogleFonts.rubik(
                                                color: Colors.black54,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              assignment.assignment.year,
                                              style: GoogleFonts.rubik(
                                                color: Colors.black87,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Created Date',
                                              style: GoogleFonts.rubik(
                                                color: Colors.black54,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              DateFormat('dd MMM yy')
                                                  .format(DateTime.parse(
                                                      assignment.assignment.createdDateTime))
                                                  .toString(),
                                              style: GoogleFonts.rubik(
                                                color: Colors.black87,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Last Date',
                                              style: GoogleFonts.rubik(
                                                color: Colors.black54,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              DateFormat('dd MMM yy')
                                                  .format(DateTime.parse(
                                                      assignment.assignment.lastDateTime))
                                                  .toString(),
                                              style: GoogleFonts.rubik(
                                                color: Colors.black87,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(),
                                      Text(
                                        'Assignment Submitted Students:',
                                        style: GoogleFonts.rubik(
                                          color: Colors.black87,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        height: 575,
                                        child: isLoading
                                            ? const Center(
                                                child: CircularProgressIndicator(
                                                  color: Color(0xFF2855AE),
                                                ),
                                              )
                                            : paidStudentsData.isEmpty
                                                ? Center(
                                                    child: Text(
                                                      'No one has paid fees.',
                                                      textAlign: TextAlign.center,
                                                      style: GoogleFonts.rubik(
                                                        color: Colors.black54,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  )
                                                : ListView.builder(
                                                    shrinkWrap: true,
                                                    padding: EdgeInsets.zero,
                                                    itemCount: paidStudentsData.length,
                                                    itemBuilder: (context, index) {
                                                      StudentUserModel su = paidStudentsData[index];

                                                      if (paidStudentsData.length !=
                                                          downloaded.length) {
                                                        downloaded.add('');
                                                      }

                                                      return GestureDetector(
                                                        onTap: () async {
                                                          if (downloaded[index] != '') {
                                                            await OpenFile.open(
                                                                Uri.decodeFull(downloaded[index]));
                                                          } else {
                                                            int co = 0;

                                                            FileDownloader.downloadFile(
                                                              url: assignment
                                                                  .assignment.submitted[index].url,
                                                              name:
                                                                  '${paidStudentsData[index].year}_${paidStudentsData[index].rollNo}',
                                                              notificationType:
                                                                  NotificationType.all,
                                                              onProgress: (fileName, progress) {
                                                                if (co == 0) {
                                                                  Utils().showToast(
                                                                      context: context,
                                                                      message: 'Download Starting');
                                                                  co++;
                                                                }
                                                              },
                                                              onDownloadCompleted:
                                                                  (String path) async {
                                                                downloaded[index] = path;
                                                                set(() {});

                                                                Utils().showToast(
                                                                    context: context,
                                                                    message: 'File downloaded');
                                                              },
                                                              onDownloadError: (String error) {
                                                                Utils().showToast(
                                                                    context: context,
                                                                    message: error);
                                                              },
                                                            );
                                                          }
                                                        },
                                                        child: Container(
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
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment.center,
                                                            children: [
                                                              Container(
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
                                                                  su.photoUrl,
                                                                  fit: BoxFit.fitHeight,
                                                                  errorBuilder:
                                                                      (BuildContext context,
                                                                          Object error,
                                                                          StackTrace? stackTrace) {
                                                                    return Image.asset(
                                                                      'assets/images/student.png',
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Expanded(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment.center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      su.name,
                                                                      style: GoogleFonts.rubik(
                                                                        color: Colors.black87,
                                                                        fontSize: 18,
                                                                        fontWeight: FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      '+91 ${su.phoneNumber}',
                                                                      style: GoogleFonts.rubik(
                                                                        color: Colors.black54,
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight.w400,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                su.rollNo,
                                                                style: GoogleFonts.rubik(
                                                                  color: Colors.black87,
                                                                  fontSize: 20,
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 15,
                                                              ),
                                                              Icon(
                                                                downloaded[index] != ''
                                                                    ? Icons.download_done_outlined
                                                                    : Icons.download_outlined,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
