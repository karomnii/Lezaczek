import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/helpers/http_helper.dart';

import '../models/news.dart';
import '../models/error.dart';
const String basicUrl = "http://localhost:8080/api/v1/news";
class NewsApi{
  Future<List<News>> getNews() async {
    final response = await HttpHelper.get(basicUrl);
    if(response.statusCode == 200){
      final Map<String, dynamic> responseMap = json.decode(response.body);
      if(responseMap['result'] == 'ok'){
        List<dynamic> newsList = responseMap['news'];
        final filteredNews = newsList.where((news) {
          List dateComponents = news['dateOfEvent'];
          List timeComponents = news['endingTime'];
          final DateTime todayDate = DateTime(
            DateTime
                .now()
                .year,
            DateTime
                .now()
                .month,
            DateTime
                .now()
                .day,
          );
          final DateTime dateOfEvent = DateTime(
              dateComponents[0], dateComponents[1], dateComponents[2]);
          final TimeOfDay endingTime = TimeOfDay(
              hour: timeComponents[0], minute: timeComponents[1]);
          if (dateOfEvent.isAfter(todayDate) ||
              (dateOfEvent.isAtSameMomentAs(todayDate) && endingTime.hour > TimeOfDay.now().hour ||
              (dateOfEvent.isAtSameMomentAs(todayDate) && endingTime.hour == TimeOfDay.now().hour
              && endingTime.minute > TimeOfDay.now().minute))) {
                return true;
          }
          deleteOutdatedNews(news['newsId']);
          return false;
        }
        ).toList();
        return filteredNews.map((json) => News.fromJson(json)).toList();
      }
      else{
        throw Error.fromJson(responseMap);
      }
    }
    else{
      throw Error.fromJson(json.decode(response.body));
    }
  }

  Future<News> createNews(News news) async{
    final response = await HttpHelper.post(basicUrl,
      body: news.convertToMap()
    );
    if(response.statusCode == 200){
      final Map<String, dynamic> responseMap = json.decode(response.body);
      if(responseMap['result'] == 'ok'){
        return News.fromJson(responseMap['news'][0]);
      }
      else{
        throw Error.fromJson(responseMap);
      }
    }
    else{
      throw Error.fromJson(json.decode(response.body));
    }
  }

  Future<News> updateNews(News news) async{
    final response = await HttpHelper.put(
      basicUrl,
      body: news.convertToMap()
    );
    if(response.statusCode == 200){
      final Map<String, dynamic> responseMap = json.decode(response.body);
      if(responseMap['result'] == 'ok'){
        return News.fromJson(responseMap['news'][0]);
      }
      else{
        throw Error.fromJson(responseMap);
      }
    }
    else{
      throw Error.fromJson(json.decode(response.body));
    }
  }

  Future<void> deleteNews(int newsId) async{
    final response = await HttpHelper.delete('$basicUrl/$newsId');
    if(response.statusCode == 200){
      final Map<String, dynamic> responseMap = json.decode(response.body);
      if(responseMap['result'] != 'ok'){
        throw Error.fromJson(responseMap);
      }
    }
    else{
      throw Error.fromJson(json.decode(response.body));
    }
  }

  Future<void> deleteOutdatedNews(int newsId) async {
    await HttpHelper.delete('$basicUrl/outdated/$newsId');
  }
}