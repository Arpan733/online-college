import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/model/event_model.dart';
import 'package:online_college/providers/all_user_provider.dart';
import 'package:online_college/repositories/event_firestore.dart';
import 'package:online_college/repositories/notifications.dart';
import 'package:online_college/widgets/dialog_for_event.dart';
import 'package:provider/provider.dart';

class EventProvider extends ChangeNotifier {
  List<EventModel> _eventList = [];

  List<EventModel> get eventList => _eventList;

  EventModel _event = EventModel(
      eid: 'eid', title: 'title', description: 'description', url: 'url', dateTime: 'dateTime');

  EventModel get event => _event;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> addEvent({required BuildContext context, required EventModel eventModel}) async {
    await EventFireStore().addEventToFireStore(context: context, eventModel: eventModel);

    List<String> tokens = [];

    if (!context.mounted) return;
    Provider.of<AllUserProvider>(context, listen: false).studentsList.forEach((element) {
      if (element.notificationToken != "") {
        tokens.add(element.notificationToken);
      }
    });

    if (!context.mounted) return;
    Provider.of<AllUserProvider>(context, listen: false).teachersList.forEach((element) {
      if (element.notificationToken != "") {
        tokens.add(element.notificationToken);
      }
    });

    tokens.remove(UserSharedPreferences.notificationToken);

    NotificationServices().sendNotification(
      title: eventModel.title,
      message:
          'Time: ${DateFormat('dd/MM/yyyy hh:mm aa').format(DateTime.parse(eventModel.dateTime))}\nDescription: ${eventModel.description}',
      tokens: tokens,
      pd: {
        'page': 'eventDetail',
        'id': eventModel.eid,
      },
    );

    if (!context.mounted) return;
    await getEventList(context: context);
  }

  Future<void> updateEvent({required BuildContext context, required EventModel eventModel}) async {
    await EventFireStore().updateEventAtFireStore(context: context, eventModel: eventModel);

    if (!context.mounted) return;
    await getEventList(context: context);
  }

  Future<void> deleteEvent({required BuildContext context, required String eid}) async {
    await EventFireStore().deleteEventFromFireStore(context: context, eid: eid);

    if (!context.mounted) return;
    await getEventList(context: context);
  }

  Future<void> getEventList({required BuildContext context}) async {
    _eventList = [];
    _isLoading = true;
    notifyListeners();

    List<EventModel> response = await EventFireStore().getEventListFromFireStore(context: context);

    if (response.isNotEmpty) {
      _eventList = response;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getEvent({required BuildContext context, required String eid}) async {
    _event = EventModel(
        eid: 'eid', title: 'title', description: 'description', url: 'url', dateTime: 'dateTime');
    _isLoading = true;
    notifyListeners();

    EventModel? response = await EventFireStore().getEventFromFireStore(context: context, eid: eid);

    if (response != null) {
      _event = response;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> checkUpcomingEvent({required BuildContext context}) async {
    await getEventList(context: context);

    for (var element in eventList) {
      if (DateTime.now().year == DateTime.parse(element.dateTime).year &&
          DateTime.now().month == DateTime.parse(element.dateTime).month &&
          DateTime.now().day == DateTime.parse(element.dateTime).day &&
          DateTime.now().isBefore(DateTime.parse(element.dateTime))) {
        if (!context.mounted) return;
        await showDialogForEvent(context: context, event: element, time: 'Today');
      }

      if (DateFormat('dd/MM/yyyy').format(DateTime.now().add(const Duration(days: 1))) ==
          DateFormat('dd/MM/yyyy').format(DateTime.parse(element.dateTime))) {
        if (!context.mounted) return;
        await showDialogForEvent(context: context, event: element, time: 'Tomorrow');
      }
    }
  }

  List<EventModel> sorting({
    required BuildContext context,
    required String sort,
  }) {
    List<EventModel> showEventList = [];

    if (sort == 'By Time') {
      showEventList = eventList.map((element) => EventModel.fromJson(element.toJson())).toList();
      showEventList.sort(
        (a, b) {
          DateTime aDate = DateTime.parse(a.dateTime);
          DateTime bDate = DateTime.parse(b.dateTime);
          return aDate.compareTo(bDate);
        },
      );
    } else if (sort == 'Upcoming') {
      for (var element in eventList) {
        if (DateTime.now().isBefore(DateTime.parse(element.dateTime))) {
          showEventList.add(element);
        }
      }
    } else if (sort == 'Past') {
      for (var element in eventList) {
        if (DateTime.now().isAfter(DateTime.parse(element.dateTime))) {
          showEventList.add(element);
        }
      }
    } else if (sort == 'All') {
      showEventList = eventList;
    }

    return showEventList;
  }
}
