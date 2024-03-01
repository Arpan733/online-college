import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/providers/event_provider.dart';
import 'package:online_college/widgets/bottom_sheet_for_event.dart';
import 'package:provider/provider.dart';

class EventDetailScreen extends StatefulWidget {
  final String eid;

  const EventDetailScreen({super.key, required this.eid});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<EventProvider>(context, listen: false)
          .getEvent(context: context, eid: widget.eid);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        Provider.of<EventProvider>(context, listen: false)
            .getEvent(context: context, eid: widget.eid);
        setState(() {});
      },
      backgroundColor: const Color(0xFF2855AE),
      color: Colors.white,
      child: Scaffold(
        body: Consumer<EventProvider>(
          builder: (context, event, child) => Stack(
            children: [
              Positioned(
                bottom: 0,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'assets/images/background 1.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
              event.isLoading
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF2855AE),
                        ),
                      ),
                    )
                  : CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              Container(
                                height: 360,
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(top: 40),
                                alignment: Alignment.center,
                                color: Colors.black26,
                                child: Hero(
                                  tag: event.event.eid,
                                  child: Image.network(
                                    event.event.url,
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
                                          DateFormat('dd MMM yy, hh:mm aa')
                                              .format(DateTime.parse(event.event.dateTime)),
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
                                      event.event.title,
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
                                      event.event.description,
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
                top: 30,
                left: 10,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_outlined,
                    color: Colors.black87,
                  ),
                ),
              ),
              UserSharedPreferences.role == 'teacher' &&
                      !event.isLoading &&
                      !DateTime.now().isAfter(DateTime.parse(event.event.dateTime))
                  ? Positioned(
                      top: 30,
                      right: 60,
                      child: IconButton(
                        onPressed: () {
                          event.deleteEvent(context: context, eid: event.event.eid);
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.delete_outlined,
                          color: Colors.red,
                        ),
                      ),
                    )
                  : Container(),
              UserSharedPreferences.role == 'teacher' &&
                      !event.isLoading &&
                      !DateTime.now().isAfter(DateTime.parse(event.event.dateTime))
                  ? Positioned(
                      top: 30,
                      right: 10,
                      child: IconButton(
                        onPressed: () {
                          bottomSheetForEvent(
                              context: context, isEdit: true, eventModel: event.event);

                          event.getEvent(context: context, eid: widget.eid);
                          setState(() {});
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
      ),
    );
  }
}
