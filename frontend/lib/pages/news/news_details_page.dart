import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/pages/news/news_form.dart';
import 'package:frontend/services/event_service.dart';
import 'package:intl/intl.dart';

import '../../models/news.dart';
import '../../models/event.dart';
import '../../models/error.dart';

class NewsDetailsPage extends StatelessWidget {
  final Map<String, dynamic> news;
  final VoidCallback onDelete;
  final Function(News) onUpdate;
  final bool admin;
  NewsDetailsPage({required this.news,
    required this.onUpdate, required this.onDelete, required this.admin});

  @override
  Widget build(BuildContext context) {
    News currentNews = News.fromMap(news);

    String dateOfEvent = DateFormat('yyyy-MM-dd').format(currentNews.dateOfEvent);
    String dateAdded = DateFormat('yyyy-MM-dd').format(currentNews.dateAdded!);
    String startingTime = currentNews.startingTime.format(context);
    String endingTime = currentNews.endingTime.format(context);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          currentNews.name,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
        actions: [
          Visibility(
            visible: admin == true,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewsForm(
                                initNews: currentNews,
                                onSave: (updatedNews){
                                  onUpdate(updatedNews);
                                  Navigator.pop(context);
                                }
                            )
                        )
                    );
                  },
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    onDelete();
                  },
                  icon: Icon(Icons.delete),
                ),
              ],
            )
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.735,
                    child:SingleChildScrollView(
                      child:Column(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              createOneDetail(
                                  Icons.access_time,
                                  'Date and Time',
                                  '$dateOfEvent, $startingTime - $endingTime'),
                              SizedBox(
                                height: 16,
                              ),
                              createOneDetail(
                                  Icons.place,
                                  'Place',
                                  currentNews.place
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              createOneDetail(
                                  Icons.description_outlined,
                                  'Description',
                                  currentNews.description ?? 'No description is available'
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              createOneDetail(
                                  Icons.date_range_rounded,
                                  'Addition date',
                                  dateAdded
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    )
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                  padding: EdgeInsets.only(bottom: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async{
                        Event event = convertNewsToEvent(currentNews);
                        try{
                          await EventService.createEvent(event);
                          Navigator.pop(context, 'News successfully added to Planner');
                        }
                        catch(error){
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                    'Error'
                                ),
                                content: Text(error is Error ? error.text : 'Unexpected error has occurred'),
                                contentTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
                                actions: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'Close',
                                          )),
                                    ],
                                  )
                                ],
                              )
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff49D3F2),
                        elevation: 4.0,
                        padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius:  BorderRadius.circular(10)
                        ),
                      ),
                      child: Text(
                        'Add to Planner',
                        style: TextStyle(
                          color: Colors.grey[850],
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              )

            ]
          ),
        ],
      )
    );
  }

  Widget createOneDetail(IconData icon, String label, String data){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Color(0xff3db2cc),
          size: 28,
        ),
        SizedBox(
            width: 16.0,
        ),
        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  data,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                ),
              ],
            )
        ),
      ],
    );
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
