import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:online_college/consts/routes.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/model/event_model.dart';
import 'package:online_college/providers/event_provider.dart';
import 'package:online_college/widgets/bottom_sheet_for_event.dart';
import 'package:provider/provider.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<EventProvider>(context, listen: false).getEventList(context: context);
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
          Consumer<EventProvider>(
            builder: (context, event, _) {
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
                      'Events',
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    sliver: SliverList.builder(
                      itemCount: event.eventList.isEmpty ? 1 : event.eventList.length,
                      itemBuilder: (context, index) {
                        if (event.isLoading) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height - 200,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF2855AE),
                              ),
                            ),
                          );
                        }

                        if (event.eventList.isEmpty) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height - 200,
                            child: Center(
                              child: Text(
                                'There is no event',
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

                        EventModel e = event.eventList[index];

                        return GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, arguments: e, Routes.eventDetail),
                          child: Container(
                            height: 130,
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
                                Text(
                                  e.title,
                                  style: GoogleFonts.rubik(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                SizedBox(
                                  height: 80,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.black26,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Hero(
                                          tag: e.eid,
                                          child: Image.network(
                                            e.url,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container();
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width - 152,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.date_range_outlined,
                                                  color: Color(0xFF6789CA),
                                                  size: 15,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  DateFormat('dd MMM yy, HH:mm aa')
                                                      .format(DateTime.parse(e.dateTime)),
                                                  style: GoogleFonts.rubik(
                                                    color: const Color(0xFF6789CA),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              e.description,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.rubik(
                                                color: Colors.black54,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
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
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: UserSharedPreferences.role == 'teacher'
          ? GestureDetector(
              onTap: () => bottomSheetForEvent(context: context),
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
    );
  }
}
