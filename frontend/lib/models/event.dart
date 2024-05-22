// lib/models/event.dart

import 'package:flutter/material.dart';

class Event {
  final int eventId;
  final int userId;
  final String name;
  final String? description;
  final String? place;
  final int eventType;
  final DateTime dateAdded;
  final DateTime dateStart;
  final DateTime dateEnd;
  final TimeOfDay? startingTime;
  final TimeOfDay? endingTime;

  Event({
    required this.eventId,
    required this.userId,
    required this.name,
    this.description,
    this.place,
    required this.eventType,
    required this.dateAdded,
    required this.dateStart,
    required this.dateEnd,
    this.startingTime,
    this.endingTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'userId': userId,
      'name': name,
      'description': description,
      'place': place,
      'eventType': eventType,
      'dateAdded': dateAdded.toIso8601String(),
      'dateStart': dateStart.toIso8601String(),
      'dateEnd': dateEnd.toIso8601String(),
      'startingTime': startingTime != null
          ? '${startingTime!.hour.toString().padLeft(2, '0')}:${startingTime!.minute.toString().padLeft(2, '0')}'
          : null,
      'endingTime': endingTime != null
          ? '${endingTime!.hour.toString().padLeft(2, '0')}:${endingTime!.minute.toString().padLeft(2, '0')}'
          : null,
    };
  }
}
