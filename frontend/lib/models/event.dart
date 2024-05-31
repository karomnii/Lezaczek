import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      dateStart: DateTime.parse(json['dateStart']),
      dateEnd: DateTime.parse(json['dateEnd']),
      startingTime: TimeOfDay(hour: int.parse(json['startingTime'].split(':')[0]), minute: int.parse(json['startingTime'].split(':')[1])),
      endingTime: TimeOfDay(hour: int.parse(json['endingTime'].split(':')[0]), minute: int.parse(json['endingTime'].split(':')[1])),
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
      'dateStart': dateStart.toIso8601String(),
      'dateEnd': dateEnd.toIso8601String(),
      'startingTime': '${startingTime.hour}:${startingTime.minute}',
      'endingTime': '${endingTime.hour}:${endingTime.minute}',
    };
  }
}
