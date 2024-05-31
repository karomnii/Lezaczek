import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum EventType { SINGLE, DAILY, WEEKLY }

enum EventType { SINGLE, DAILY, WEEKLY }

class Event {
  int eventId;
  int userID;
  String name;
  String? description;
  String? place;
  EventType eventType;
  DateTime dateStart;
  DateTime dateEnd;
  TimeOfDay startingTime;
  TimeOfDay endingTime;

  Event({
    required this.eventId,
    required this.userID,
    required this.name,
    this.description,
    this.place,
    required this.eventType,
    required this.dateStart,
    required this.dateEnd,
    required this.startingTime,
    required this.endingTime,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventId: json['eventId'],
      userID: json['userID'],
      name: json['name'],
      description: json['description'],
      place: json['place'],
      eventType: EventType.values.firstWhere((e) => e.toString() == 'EventType.' + json['eventType']),
      dateStart: _parseDateTime(json['dateStart']),
      dateEnd: _parseDateTime(json['dateEnd']),
      startingTime: _parseTimeOfDay(json['startingTime']),
      endingTime: _parseTimeOfDay(json['endingTime']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'userID': userID,
      'name': name,
      'description': description,
      'place': place,
      'eventType': eventType.toString().split('.').last,
      'dateStart': _formatDateTime(dateStart),
      'dateEnd': _formatDateTime(dateEnd),
      'startingTime': _formatTimeOfDay(startingTime),
      'endingTime': _formatTimeOfDay(endingTime),
    };
  }

  static TimeOfDay _parseTimeOfDay(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1])
    );
  }

  static String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';
  }

  static String _formatDateTime(DateTime date)
  {
    String stringDate ="";
    stringDate = "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}" ;
    return stringDate;
  }

  static DateTime _parseDateTime(String date)
  {
    final parts = DateTime.parse(date);
    return DateTime(parts.year, parts.month, parts.day);
  }
}

