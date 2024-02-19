import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/model/event_model.dart';
import 'package:online_college/providers/event_provider.dart';
import 'package:online_college/widgets/bottom_sheet_for_event.dart';
import 'package:provider/provider.dart';

class EventDetailScreen extends StatefulWidget {
  final EventModel eventModel;

  const EventDetailScreen({super.key, required this.eventModel});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
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
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        height: 320,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        color: Colors.black26,
                        child: Hero(
                          tag: widget.eventModel.eid,
                          child: Image.network(
                            widget.eventModel.url,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container();
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                      .format(DateTime.parse(widget.eventModel.dateTime)),
                                  style: GoogleFonts.rubik(
                                    color: const Color(0xFF6789CA),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              widget.eventModel.title,
                              style: GoogleFonts.rubik(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              widget.eventModel.description,
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
                ),
              ],
            ),
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_outlined,
                  color: Colors.black87,
                ),
              ),
            ),
            UserSharedPreferences.role == 'teacher'
                ? Positioned(
                    top: 10,
                    right: 60,
                    child: IconButton(
                      onPressed: () {
                        Provider.of<EventProvider>(context, listen: false)
                            .deleteEvent(context: context, eid: widget.eventModel.eid);
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.delete_outlined,
                        color: Colors.red,
                      ),
                    ),
                  )
                : Container(),
            UserSharedPreferences.role == 'teacher'
                ? Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      onPressed: () {
                        bottomSheetForEvent(
                            context: context, isEdit: true, eventModel: widget.eventModel);
                      },
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: Colors.black87,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
