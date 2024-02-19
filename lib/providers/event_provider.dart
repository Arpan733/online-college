import 'package:flutter/material.dart';
import 'package:online_college/model/event_model.dart';
import 'package:online_college/repositories/event_firestore.dart';

class EventProvider extends ChangeNotifier {
  List<EventModel> _eventList = [];

  List<EventModel> get eventList => _eventList;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  setIsLoading({required bool loading}) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> addEvent({required BuildContext context, required EventModel eventModel}) async {
    await EventFireStore().addEventToFireStore(context: context, eventModel: eventModel);

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
}
