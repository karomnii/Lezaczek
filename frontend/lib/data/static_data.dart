// lib/data/static_data.dart

import 'package:flutter/material.dart';
import '../models/event.dart';


List<Event> staticEvents = [
  Event(
    eventId: 1,
    userID: 1,
    name: "Meeting with Bob",
    description: "Discuss the Q3 report.",
    place: "Office",
    eventType: EventType.SINGLE,
    dateStart: DateTime(2024, 5, 31),
    dateEnd: DateTime(2024, 5, 31),
    startingTime: TimeOfDay(hour: 10, minute: 30),
    endingTime: TimeOfDay(hour: 11, minute: 30),
  ),
  Event(
    eventId: 2,
    userID: 1,
    name: "Lunch with Alice",
    description: "Catch up on project updates.",
    place: "Cafeteria",
    eventType: EventType.SINGLE,
    dateStart: DateTime(2024, 6, 1),
    dateEnd: DateTime(2024, 6, 1),
    startingTime: TimeOfDay(hour: 12, minute: 0),
    endingTime: TimeOfDay(hour: 13, minute: 0),
  ),
  Event(
    eventId: 3,
    userID: 1,
    name: "Team Meeting",
    description: "Review sprint goals.",
    place: "Conference Room",
    eventType: EventType.WEEKLY,
    dateStart: DateTime(2024, 6, 3),
    dateEnd: DateTime(2024, 6, 3),
    startingTime: TimeOfDay(hour: 9, minute: 0),
    endingTime: TimeOfDay(hour: 10, minute: 0),
  ),
  Event(
    eventId: 4,
    userID: 1,
    name: "Client Presentation",
    description: "Present new product features.",
    place: "Client Office",
    eventType: EventType.SINGLE,
    dateStart: DateTime(2024, 6, 5),
    dateEnd: DateTime(2024, 6, 5),
    startingTime: TimeOfDay(hour: 14, minute: 0),
    endingTime: TimeOfDay(hour: 16, minute: 0),
  ),
  Event(
    eventId: 5,
    userID: 1,
    name: "Training Session",
    description: "New software training.",
    place: "Training Room",
    eventType: EventType.DAILY,
    dateStart: DateTime(2024, 6, 6),
    dateEnd: DateTime(2024, 6, 6),
    startingTime: TimeOfDay(hour: 11, minute: 0),
    endingTime: TimeOfDay(hour: 12, minute: 0),
  ),
  Event(
    eventId: 6,
    userID: 1,
    name: "Weekly Review",
    description: "Review progress on projects.",
    place: "Office",
    eventType: EventType.WEEKLY,
    dateStart: DateTime(2024, 6, 7),
    dateEnd: DateTime(2024, 6, 7),
    startingTime: TimeOfDay(hour: 15, minute: 0),
    endingTime: TimeOfDay(hour: 16, minute: 0),
  ),
  // Add more dummy events as needed
];

