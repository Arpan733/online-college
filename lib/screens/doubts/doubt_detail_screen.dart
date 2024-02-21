import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/consts/utils.dart';
import 'package:online_college/providers/all_user_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/doubt_model.dart';
import '../../widgets/bottom_sheet_for_chat.dart';

class DoubtDetailScreen extends StatefulWidget {
  final DoubtModel doubtModel;

  const DoubtDetailScreen({super.key, required this.doubtModel});

  @override
  State<DoubtDetailScreen> createState() => _DoubtDetailScreenState();
}

class _DoubtDetailScreenState extends State<DoubtDetailScreen> {
  List<List<String>> paths = [];

  Future<void> _onOpen(LinkableElement link) async {
    if (!await launchUrl(Uri.parse(link.url))) {
      throw Exception('Could not launch ${link.url}');
    }
  }

  Color getColor({required String e}) {
    return e.toLowerCase() == 'png'
        ? Colors.amber
        : e.toLowerCase() == 'pdf'
            ? Colors.redAccent
            : e.toLowerCase() == 'mp3' || e.toLowerCase() == 'mp4'
                ? Colors.blueAccent
                : Colors.greenAccent;
  }

  @override
  void initState() {
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
          CustomScrollView(
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
                  widget.doubtModel.title,
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
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('doubts')
                          .doc(widget.doubtModel.did)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height - 200,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF2855AE),
                              ),
                            ),
                          );
                        }

                        List<Chat> chat = [];
                        DoubtModel doubt = DoubtModel(
                            year: '', subject: '', did: '', createdTime: '', title: '', chat: []);

                        if (snapshot.data != null && snapshot.data?.data() != null) {
                          doubt = DoubtModel.fromJson(snapshot.data!.data()!);
                          chat = doubt.chat;
                        }

                        return SizedBox(
                          height: MediaQuery.of(context).size.height - 130,
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: chat.length,
                            itemBuilder: (context, index) {
                              if (paths.length != chat.length) {
                                paths.add([]);
                              }
                              Chat c = chat[index];
                              String name = '';
                              String url = '';
                              bool isStudent = false;
                              bool isOwn = false;
                              bool haveAttach = c.attach.isEmpty ? false : true;

                              if (c.role == 'student') {
                                isStudent = true;
                                Provider.of<AllUserProvider>(context).studentsList.forEach(
                                  (element) {
                                    if (element.id == c.id) {
                                      name = element.name;
                                      url = element.photoUrl;
                                    }
                                  },
                                );
                              } else {
                                isStudent = false;
                                Provider.of<AllUserProvider>(context).teachersList.forEach(
                                  (element) {
                                    if (element.id == c.id) {
                                      name = element.name;
                                      url = element.photoUrl;
                                    }
                                  },
                                );
                              }

                              if (c.id == UserSharedPreferences.id) {
                                isOwn = true;
                              }

                              return Container(
                                margin: EdgeInsets.only(
                                    right: isOwn ? 20 : 10, left: isOwn ? 10 : 20, bottom: 20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    isOwn
                                        ? Container()
                                        : Container(
                                            height: 30,
                                            width: 30,
                                            margin: const EdgeInsets.only(top: 15),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              gradient: const LinearGradient(
                                                begin: Alignment.centerRight,
                                                end: Alignment.centerLeft,
                                                colors: [Color(0xFF2855AE), Color(0xFF7292CF)],
                                              ),
                                            ),
                                            clipBehavior: Clip.antiAlias,
                                            child: Image.network(
                                              url,
                                              fit: BoxFit.fitHeight,
                                              errorBuilder: (BuildContext context, Object error,
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
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width - 80,
                                        decoration: BoxDecoration(
                                          color: isOwn
                                              ? const Color(0xFF2855AE).withOpacity(0.1)
                                              : isStudent
                                                  ? Colors.white
                                                  : Colors.black.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(25),
                                          border: Border.all(
                                            color: Colors.black87,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, left: 10, right: 10),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    name,
                                                    style: GoogleFonts.rubik(
                                                        color: Colors.black87,
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    'on ${DateFormat('dd/MM/yyyy HH:mm aa').format(DateTime.parse(c.time))}',
                                                    style: GoogleFonts.rubik(
                                                        color: Colors.black54,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Divider(),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 10, bottom: haveAttach ? 0 : 10),
                                              child: Linkify(
                                                text: c.message.trim(),
                                                style: GoogleFonts.rubik(
                                                  color: Colors.black87,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                linkStyle: GoogleFonts.rubik(
                                                  color: Colors.blue,
                                                  decoration: TextDecoration.none,
                                                ),
                                                linkifiers: const [
                                                  EmailLinkifier(),
                                                  UrlLinkifier(),
                                                ],
                                                onOpen: _onOpen,
                                              ),
                                            ),
                                            haveAttach ? const Divider() : Container(),
                                            haveAttach
                                                ? StatefulBuilder(
                                                    builder: (context, set) => Container(
                                                      height: 100,
                                                      width:
                                                          MediaQuery.of(context).size.width - 100,
                                                      padding: const EdgeInsets.only(
                                                          left: 10, right: 10, bottom: 10),
                                                      child: ListView.builder(
                                                        shrinkWrap: true,
                                                        padding: EdgeInsets.zero,
                                                        scrollDirection: Axis.horizontal,
                                                        itemCount: c.attach.length,
                                                        itemBuilder: (context, i) {
                                                          if (paths[index].length !=
                                                              c.attach.length) {
                                                            paths[index].add('');
                                                          }

                                                          return GestureDetector(
                                                            onTap: () async {
                                                              int co = 0;

                                                              if (paths[index][i] == '') {
                                                                FileDownloader.downloadFile(
                                                                  url: c.attach[i].url,
                                                                  name: c.attach[i].name,
                                                                  notificationType:
                                                                      NotificationType.all,
                                                                  onProgress: (fileName, progress) {
                                                                    if (co == 0) {
                                                                      Utils().showToast(
                                                                          context: context,
                                                                          message:
                                                                              'Download Starting');
                                                                      co++;
                                                                    }
                                                                  },
                                                                  onDownloadCompleted:
                                                                      (String path) async {
                                                                    paths[index][i] = path;
                                                                    set(() {});

                                                                    Utils().showToast(
                                                                        context: context,
                                                                        message:
                                                                            '${c.attach[i].name} downloaded');
                                                                  },
                                                                  onDownloadError: (String error) {
                                                                    Utils().showToast(
                                                                        context: context,
                                                                        message: error);
                                                                  },
                                                                );
                                                              } else {
                                                                await OpenFile.open(Uri.decodeFull(
                                                                    paths[index][i]));
                                                              }
                                                            },
                                                            child: Container(
                                                              width: 60,
                                                              margin: const EdgeInsets.all(5),
                                                              child: Stack(
                                                                children: [
                                                                  Positioned(
                                                                    left: 10,
                                                                    child: Container(
                                                                      height: 60,
                                                                      width: 40,
                                                                      alignment: Alignment.center,
                                                                      decoration: BoxDecoration(
                                                                        color: getColor(
                                                                            e: c.attach[i]
                                                                                .extension),
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                7),
                                                                      ),
                                                                      child: Image.network(
                                                                        c.attach[i].url,
                                                                        fit: BoxFit.fill,
                                                                        errorBuilder: (context,
                                                                            error, stackTrace) {
                                                                          return Text(
                                                                            '.${c.attach[i].extension}',
                                                                            style:
                                                                                GoogleFonts.rubik(
                                                                              fontSize: 10,
                                                                              color: Colors.white,
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    bottom: 0,
                                                                    child: Text(
                                                                      c.attach[i].name,
                                                                      maxLines: 1,
                                                                      overflow:
                                                                          TextOverflow.ellipsis,
                                                                      style: GoogleFonts.rubik(
                                                                        color: Colors.black87,
                                                                        fontSize: 10,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    top: 0,
                                                                    right: 0,
                                                                    child: Container(
                                                                      height: 20,
                                                                      width: 20,
                                                                      alignment: Alignment.center,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        color: Colors.white,
                                                                        shape: BoxShape.circle,
                                                                      ),
                                                                      child: Icon(
                                                                        paths[index][i] == ''
                                                                            ? Icons
                                                                                .download_outlined
                                                                            : Icons
                                                                                .file_open_outlined,
                                                                        color:
                                                                            const Color(0xFF6688CA),
                                                                        size: 15,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    isOwn
                                        ? Container(
                                            height: 30,
                                            width: 30,
                                            margin: const EdgeInsets.only(top: 15),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              gradient: const LinearGradient(
                                                begin: Alignment.centerRight,
                                                end: Alignment.centerLeft,
                                                colors: [Color(0xFF2855AE), Color(0xFF7292CF)],
                                              ),
                                            ),
                                            clipBehavior: Clip.antiAlias,
                                            child: Image.network(
                                              url,
                                              fit: BoxFit.fitHeight,
                                              errorBuilder: (BuildContext context, Object error,
                                                  StackTrace? stackTrace) {
                                                return Image.asset(
                                                  'assets/images/student.png',
                                                );
                                              },
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: GestureDetector(
        onTap: () => bottomSheetForChat(context: context, doubtModel: widget.doubtModel),
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
            Icons.comment_outlined,
            size: 25,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
