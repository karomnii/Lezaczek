import 'package:flutter/material.dart';
import 'package:frontend/models/event.dart';

class News{
  int newsId;
  int userId;
  String name;
  String? description;
  String place;
  DateTime? dateAdded;
  DateTime dateOfEvent;
  TimeOfDay startingTime;
  TimeOfDay endingTime;

  News({
    required this.newsId,
    required this.userId,
    required this.name,
    this.description,
    required this.place,
    this.dateAdded,
    required this.dateOfEvent,
    required this.startingTime,
    required this.endingTime,
  });

  factory News.fromJson(Map<String, dynamic> jsonData){
    return News(
        newsId: jsonData['newsId'],
        userId: jsonData['userId'],
        name: jsonData['name'],
        description: jsonData['description'],
        place: jsonData['place'],
        dateAdded: DateTime.utc(
          jsonData['dateAdded'][0],
          jsonData['dateAdded'][1],
          jsonData['dateAdded'][2],
        ),
        dateOfEvent: DateTime.utc(
          jsonData['dateOfEvent'][0],
          jsonData['dateOfEvent'][1],
          jsonData['dateOfEvent'][2],
        ),
        startingTime: TimeOfDay(
          hour: jsonData['startingTime'][0],
          minute: jsonData['startingTime'][1],
        ),
        endingTime: TimeOfDay(
          hour: jsonData['endingTime'][0],
          minute: jsonData['endingTime'][1],
        ),
    );
  }

  Map<String, dynamic> convertToMap(){
    return{
      'newsId' : newsId,
      'userId' : userId,
      'name' : name,
      'description' : description,
      'place' : place,
      'dateAdded' : dateFormatter(dateAdded!),
      'dateOfEvent' : dateFormatter(dateOfEvent),
      'startingTime' : timeFormatter(startingTime),
      'endingTime' : timeFormatter(endingTime),
    };
  }

  factory News.fromMap(Map<String, dynamic> mapData){
    return News(
      newsId: mapData['newsId'],
      userId: mapData['userId'],
      name: mapData['name'],
      description: mapData['description'],
      place: mapData['place'],
      dateAdded: parseDate(mapData['dateAdded']),
      dateOfEvent: parseDate(mapData['dateOfEvent']),
      startingTime: parseTime(mapData['startingTime']),
      endingTime: parseTime(mapData['endingTime'])
    );
  }

  static TimeOfDay parseTime(String time){
    final splitUp = time.split(':');
    return TimeOfDay(hour: int.parse(splitUp[0]), minute: int.parse(splitUp[1]));
  }

  static String timeFormatter(TimeOfDay time){
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}"; //hh:mm format
  }

  static DateTime parseDate(String date){
    final splitUp = DateTime.parse(date);
    return DateTime(splitUp.year, splitUp.month, splitUp.day);
  }

  static String dateFormatter(DateTime date){
    return "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}"; //yyyy-mm-dd format
  }

  Event convertNewsToEvent(News news) {
    return Event(
      eventId: news.newsId,
      userID: news.userId,
      name: news.name,
      description: news.description,
      place: news.place,
      eventType: EventType.SINGLE,
      dateStart: news.dateOfEvent,
      dateEnd: news.dateOfEvent,
      startingTime: news.startingTime,
      endingTime: news.endingTime,
    );
  }
}