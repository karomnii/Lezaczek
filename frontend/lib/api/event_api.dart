import 'dart:convert';
import 'package:frontend/models/event.dart';
import 'package:frontend/models/error.dart';
import 'package:frontend/helpers/http_helper.dart';
import 'package:http/http.dart';

class EventApi {
  Future<List<Event>> getEventsByDate(String selectedDate) async {
    final response = await HttpHelper.get(
        'http://localhost:8080/api/v1/events/date/$selectedDate');
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseJson = json.decode(response.body);
      if (responseJson['result'] == 'ok') {
        final List<dynamic> eventsJson = responseJson['events'];
        return eventsJson.map((json) => Event.fromJson(json)).toList();
      } else {
        throw Error.fromJson(responseJson);
      }
    } else {
      final errorJson = json.decode(response.body);
      throw Error.fromJson(errorJson);
    }
  }

  Future<Event> createEvent(Event event) async {
    final response = await HttpHelper.put('http://localhost:8080/api/v1/events',
        body: event.toMap());
    print(event.toMap());
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseJson = json.decode(response.body);
      if (responseJson['result'] == 'ok') {
        return Event.fromJson(responseJson['events'][0]);
      } else {
        throw Error.fromJson(responseJson);
      }
    } else {
      final errorJson = json.decode(response.body);
      throw Error.fromJson(errorJson);
    }
  }

  Future<Event> updateEvent(Event event) async {
    final response = await HttpHelper.post(
        'http://localhost:8080/api/v1/events',
        body: event.toMap());
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseJson = json.decode(response.body);
      if (responseJson['result'] == 'ok') {
        return Event.fromJson(responseJson['events'][0]);
      } else {
        throw Error.fromJson(responseJson);
      }
    } else {
      final errorJson = json.decode(response.body);
      throw Error.fromJson(errorJson);
    }
  }

  Future<void> deleteEvent(int eventId) async {
    final response =
        await HttpHelper.delete('http://localhost:8080/api/v1/events/$eventId');
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseJson = json.decode(response.body);
      if (responseJson['result'] == 'ok') {
        return;
      } else {
        throw Error.fromJson(responseJson);
      }
    } else {
      final errorJson = json.decode(response.body);
      throw Error.fromJson(errorJson);
    }
  }
}
