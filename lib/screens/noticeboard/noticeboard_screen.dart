import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/model/notice_model.dart';
import 'package:online_college/providers/notice_provider.dart';
import 'package:online_college/widgets/bottom_sheet_for_notice.dart';
import 'package:online_college/widgets/dialog_for_notice.dart';
import 'package:provider/provider.dart';

class NoticeBoardScreen extends StatefulWidget {
  const NoticeBoardScreen({super.key});

  @override
  State<NoticeBoardScreen> createState() => _NoticeBoardScreenState();
}

class _NoticeBoardScreenState extends State<NoticeBoardScreen> {
  String sort = 'All';

  List<String> dropDownList = [
    "All",
    "By Time",
    "Latest",
  ];

  List<DropdownMenuItem<String>> dropDowns = [];

  List<NoticeModel> showNoticeList = [];

  @override
  void initState() {
    for (var element in dropDownList) {
      dropDowns.add(
        DropdownMenuItem(
          value: element,
          child: Text(
            element,
            style: GoogleFonts.rubik(
              color: const Color(0xFF2855AE),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<NoticeProvider>(context, listen: false).getNoticeList(context: context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Provider.of<NoticeProvider>(context, listen: false).getNoticeList(context: context);
        setState(() {});
      },
      backgroundColor: const Color(0xFF2855AE),
      color: Colors.white,
      child: Scaffold(
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
            Consumer<NoticeProvider>(
              builder: (context, notice, _) {
                showNoticeList = notice.sorting(context: context, sort: sort);

                return StatefulBuilder(
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
                        title: Text(
                          'Notices',
                          style: GoogleFonts.rubik(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              DropdownButtonFormField<String>(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                value: sort,
                                items: dropDowns,
                                onChanged: (value) {
                                  if (value != null) {
                                    sort = value;
                                    showNoticeList = notice.sorting(context: context, sort: sort);

                                    set(() {});
                                  }
                                },
                                dropdownColor: Colors.white,
                                iconEnabledColor: Colors.white,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.filter_alt_outlined,
                                    color: Color(0xFF2855AE),
                                    size: 20,
                                  ),
                                  suffixIcon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Color(0xFF2855AE),
                                    size: 30,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        sliver: SliverList.builder(
                          itemCount: showNoticeList.isEmpty ? 1 : showNoticeList.length,
                          itemBuilder: (context, index) {
                            if (notice.isLoading) {
                              return SizedBox(
                                height: MediaQuery.of(context).size.height - 200,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF2855AE),
                                  ),
                                ),
                              );
                            }

                            if (showNoticeList.isEmpty) {
                              return SizedBox(
                                height: MediaQuery.of(context).size.height - 200,
                                child: Center(
                                  child: Text(
                                    sort == 'latest'
                                        ? 'There is not any latest notice'
                                        : 'There is no notice',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.rubik(
                                      color: Colors.black54,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              );
                            }

                            NoticeModel n = showNoticeList[index];

                            return GestureDetector(
                              onTap: () => showDialogForNotice(
                                context: context,
                                notice: n,
                              ),
                              onLongPress: () => bottomSheetForNotice(
                                context: context,
                                isEdit: true,
                                noticeModel: n,
                              ),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.black38,
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (UserSharedPreferences.role == 'teacher')
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: n.year
                                            .map(
                                              (e) => Container(
                                                margin: const EdgeInsets.only(right: 10),
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 10, vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFE6EFFF),
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: Text(
                                                  e,
                                                  style: GoogleFonts.rubik(
                                                    color: const Color(0xFF6789CA),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    if (UserSharedPreferences.role == 'teacher')
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    Text(
                                      n.title,
                                      style: GoogleFonts.rubik(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (n.photoUrl != '') const Divider(),
                                    if (n.photoUrl != '')
                                      Image.network(
                                        n.photoUrl,
                                        alignment: Alignment.center,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    const Divider(),
                                    Text(
                                      n.description,
                                      style: GoogleFonts.rubik(
                                        color: Colors.black54,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
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
                );
              },
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: UserSharedPreferences.role == 'teacher'
            ? GestureDetector(
                onTap: () => bottomSheetForNotice(context: context),
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
              )
            : null,
      ),
    );
  }
}
