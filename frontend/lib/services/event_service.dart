import 'package:frontend/models/user.dart';
import 'package:frontend/api/event_api.dart';
import 'package:frontend/models/event.dart';

class EventService {
  static final _api = EventApi();

  static Future<List<Event>> getEventsByDate(String selectedDate) async {
    return _api.getEventsByDate(selectedDate);
  }

  static Future<Event?> createEvent(Event event) async {
    return _api.createEvent(event);
  }

  static Future<Event?> updateEvent(Event event) async {
    return _api.updateEvent(event);
  }

  static Future<void> deleteEvent(int eventId) async {
    return _api.deleteEvent(eventId);
  }
}
